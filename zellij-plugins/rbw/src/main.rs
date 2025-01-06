use zellij_tile::prelude::*;

#[derive(Debug, Clone, Default, PartialEq, Eq)]
struct RbwEntry {
    name: String,
    user: Option<String>,
    folder: Option<String>,
}

#[derive(Default)]
struct State {
    picker: zellij_nucleo::Picker<RbwEntry>,
    pane_tracker: util::FocusedPaneTracker,
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
        self.pane_tracker.load();
        self.picker.enter_search_mode();
        self.picker.set_match_paths();
        self.picker.load(&configuration);
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
                    run_command(&cmd, util::ctx("rbw get"));
                }
                zellij_nucleo::Response::Cancel => {
                    close_self();
                }
            }
        }

        self.pane_tracker.update(&event);

        match event {
            Event::PermissionRequestResult(PermissionStatus::Granted) => {
                run_command(
                    &["rbw", "ls", "--fields", "name,user,folder"],
                    util::ctx("rbw ls"),
                );
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
                    self.pane_tracker.write(stdout);
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
