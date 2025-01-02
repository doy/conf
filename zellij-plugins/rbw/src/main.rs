use zellij_tile::prelude::*;

use picker::Picker as _;

#[derive(
    Clone, Default, serde::Serialize, serde::Deserialize, PartialEq, Eq,
)]
struct RbwEntry {
    name: String,
    user: Option<String>,
    folder: Option<String>,
}

#[derive(Default)]
struct State {
    picker_renderer: picker::Renderer<RbwEntry>,
    tabs: Vec<TabInfo>,
    panes: PaneManifest,
}

#[derive(Default, serde::Serialize, serde::Deserialize)]
struct RbwPicker;

impl picker::Picker<'_> for RbwPicker {
    const EVENTS: &'static [EventType] = &[EventType::RunCommandResult];
    const WORKER_NAME: &'static str = "rbw_picker";
    type Item = RbwEntry;

    fn update(
        &mut self,
        event: &Event,
        all_entries: &mut Vec<picker::Entry<Self::Item>>,
    ) -> bool {
        if let Event::RunCommandResult(code, stdout, _, ctx) = event {
            if ctx["source"] == "rbw ls" {
                if *code == Some(0) {
                    *all_entries = std::str::from_utf8(stdout)
                        .unwrap()
                        .trim_end_matches('\n')
                        .split('\n')
                        .map(|line| {
                            let mut parts = line.trim().split('\t');
                            let name = parts.next().unwrap().to_string();
                            assert!(!name.is_empty());
                            let user = parts.next().unwrap_or("").to_string();
                            let user = if user.is_empty() {
                                None
                            } else {
                                Some(user)
                            };
                            let folder =
                                parts.next().unwrap_or("").to_string();
                            let folder = if folder.is_empty() {
                                None
                            } else {
                                Some(folder)
                            };
                            let parts: Vec<_> = [
                                folder.clone(),
                                Some(name.clone()),
                                user.clone(),
                            ]
                            .into_iter()
                            .flatten()
                            .collect();
                            picker::Entry {
                                data: RbwEntry { name, user, folder },
                                string: parts.join("/"),
                            }
                        })
                        .collect();
                } else {
                    todo!();
                }
                return true;
            }
        }
        false
    }
}

register_plugin!(State);
register_worker!(
    picker::PickerWorker<'static, RbwPicker>,
    rbw_picker_worker,
    RBW_PICKER_WORKER
);

impl ZellijPlugin for State {
    fn load(
        &mut self,
        _configuration: std::collections::BTreeMap<String, String>,
    ) {
        request_permission(&[
            PermissionType::ReadApplicationState,
            PermissionType::RunCommands,
            PermissionType::WriteToStdin,
        ]);
        RbwPicker::subscribe();
        subscribe(&[
            EventType::RunCommandResult,
            EventType::PermissionRequestResult,
        ]);
        RbwPicker::enter_search_mode();
    }

    fn update(&mut self, event: Event) -> bool {
        if let Some(response) = RbwPicker::handle_event(event.clone()) {
            match response {
                picker::Response::Render(renderer) => {
                    self.picker_renderer = renderer;
                    return true;
                }
                picker::Response::Select(entry) => {
                    let mut cmd = vec!["rbw", "get", &entry.data.name];
                    if let Some(user) = &entry.data.user {
                        cmd.push(user);
                    }
                    if let Some(folder) = &entry.data.folder {
                        cmd.push("--folder");
                        cmd.push(folder);
                    }
                    run_command(&cmd, ctx("rbw get"));
                }
                picker::Response::Cancel => {
                    close_self();
                }
            }
        } else {
            match event {
                Event::PermissionRequestResult(PermissionStatus::Granted) => {
                    run_command(
                        &["rbw", "ls", "--fields", "name,user,folder"],
                        ctx("rbw ls"),
                    );
                }
                Event::TabUpdate(tabs) => {
                    self.tabs = tabs;
                }
                Event::PaneUpdate(panes) => {
                    self.panes = panes;
                }
                Event::RunCommandResult(code, stdout, _, ctx) => {
                    if ctx["source"] == "rbw get" {
                        if code == Some(0) {
                            if let Some(pane) = get_focused_pane(
                                get_focused_tab(&self.tabs)
                                    .map(|tab| tab.position)
                                    .unwrap_or(0),
                                &self.panes,
                            ) {
                                if !pane.is_plugin {
                                    write_to_pane_id(
                                        stdout,
                                        PaneId::Terminal(pane.id),
                                    );
                                }
                            }
                            close_self();
                        } else {
                            todo!()
                        }
                    }
                }
                _ => (),
            }
        }

        false
    }

    fn render(&mut self, _: usize, _: usize) {
        self.picker_renderer.render();
    }
}

fn ctx(source: &str) -> std::collections::BTreeMap<String, String> {
    let mut map = std::collections::BTreeMap::new();
    map.insert("source".to_string(), source.to_string());
    map
}
