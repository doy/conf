use zellij_tile::prelude::*;

#[derive(Default)]
struct State {
    picker: zellij_nucleo::Picker<()>,
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
            PermissionType::ReadApplicationState,
            PermissionType::RunCommands,
            PermissionType::WriteToStdin,
        ]);

        subscribe(&[
            EventType::TabUpdate,
            EventType::PaneUpdate,
            EventType::RunCommandResult,
            EventType::PermissionRequestResult,
        ]);
        self.picker.load(&configuration);
        self.picker.enter_search_mode();
    }

    fn update(&mut self, event: Event) -> bool {
        match self.picker.update(&event) {
            Some(zellij_nucleo::Response::Select(entry)) => {
                if let Some(pane) = get_focused_pane(
                    get_focused_tab(&self.tabs)
                        .map(|tab| tab.position)
                        .unwrap_or(0),
                    &self.panes,
                ) {
                    if !pane.is_plugin {
                        write_chars_to_pane_id(
                            &entry.string,
                            PaneId::Terminal(pane.id),
                        );
                    }
                }
                close_self();
            }
            Some(zellij_nucleo::Response::Cancel) => {
                close_self();
            }
            None => {}
        }

        match event {
            Event::PermissionRequestResult(PermissionStatus::Granted) => {
                run_command(&["rg", "--files", "--hidden"], ctx("rg files"));
            }
            Event::TabUpdate(tabs) => {
                self.tabs = tabs;
            }
            Event::PaneUpdate(panes) => {
                self.panes = panes;
            }
            Event::RunCommandResult(code, stdout, _, ctx) => {
                if code == Some(0) && ctx["source"] == "rg files" {
                    self.picker.extend(
                        std::str::from_utf8(&stdout)
                            .unwrap()
                            .trim_end_matches('\n')
                            .split('\n')
                            .map(str::to_string)
                            .map(|string| zellij_nucleo::Entry {
                                string,
                                data: (),
                            }),
                    )
                }
            }
            _ => {}
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
