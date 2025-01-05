use zellij_tile::prelude::*;

#[derive(
    Debug, Clone, Default, serde::Serialize, serde::Deserialize, PartialEq, Eq,
)]
struct RbwEntry {
    name: String,
    user: Option<String>,
    folder: Option<String>,
}

#[derive(Default)]
struct State {
    picker: zellij_nucleo::Picker<RbwEntry>,
    tabs: Vec<TabInfo>,
    panes: PaneManifest,
}

register_plugin!(State);

impl ZellijPlugin for State {
    fn load(
        &mut self,
        configuration: std::collections::BTreeMap<String, String>,
    ) {
        request_permission(&[
            PermissionType::RunCommands,
            PermissionType::WriteToStdin,
        ]);

        subscribe(&[
            EventType::RunCommandResult,
            EventType::PermissionRequestResult,
        ]);
        self.picker.load(&configuration);
        self.picker.enter_search_mode();
    }

    fn update(&mut self, event: Event) -> bool {
        if let Some(response) = self.picker.update(&event) {
            match response {
                zellij_nucleo::Response::Select(entry) => {
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
                zellij_nucleo::Response::Cancel => {
                    close_self();
                }
            }
        }

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
                if ctx["source"] == "rbw ls" && code == Some(0) {
                    self.picker.clear();
                    self.picker.extend(
                        std::str::from_utf8(&stdout)
                            .unwrap()
                            .trim_end_matches('\n')
                            .split('\n')
                            .map(|line| {
                                let mut parts = line.trim().split('\t');
                                let name = parts.next().unwrap().to_string();
                                assert!(!name.is_empty());
                                let user =
                                    parts.next().unwrap_or("").to_string();
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
                                zellij_nucleo::Entry {
                                    data: RbwEntry { name, user, folder },
                                    string: parts.join("/"),
                                }
                            }),
                    );
                    return true;
                } else if ctx["source"] == "rbw get" && code == Some(0) {
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
                }
            }
            _ => (),
        }

        self.picker.needs_redraw()
    }

    fn render(&mut self, rows: usize, cols: usize) {
        self.picker.render(rows, cols);
    }
}

fn ctx(source: &str) -> std::collections::BTreeMap<String, String> {
    let mut map = std::collections::BTreeMap::new();
    map.insert("source".to_string(), source.to_string());
    map
}
