use zellij_tile::prelude::*;

#[derive(Default)]
struct State {
    picker: zellij_nucleo::Picker<Vec<u8>>,
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
        match self.picker.update(&event) {
            Some(zellij_nucleo::Response::Select(entry)) => {
                self.pane_tracker.write(entry.data);
                close_self();
            }
            Some(zellij_nucleo::Response::Cancel) => {
                close_self();
            }
            None => {}
        }

        self.pane_tracker.update(&event);

        match event {
            Event::PermissionRequestResult(PermissionStatus::Granted) => {
                run_command(
                    &["rg", "--files", "--hidden"],
                    util::ctx("rg files"),
                );
            }
            Event::RunCommandResult(code, stdout, _, ctx) => {
                if code == Some(0) && ctx["source"] == "rg files" {
                    self.picker.extend(
                        stdout.trim_ascii_end().split(|c| *c == b'\n').map(
                            |s| zellij_nucleo::Entry {
                                string: String::from_utf8_lossy(s)
                                    .into_owned(),
                                data: s.to_vec(),
                            },
                        ),
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
