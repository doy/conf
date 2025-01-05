use zellij_tile::prelude::*;

#[derive(Default)]
struct State {
    picker: zellij_nucleo::Picker<u32>,
}

register_plugin!(State);

impl ZellijPlugin for State {
    fn load(
        &mut self,
        configuration: std::collections::BTreeMap<String, String>,
    ) {
        request_permission(&[
            PermissionType::ReadApplicationState,
            PermissionType::ChangeApplicationState,
        ]);

        subscribe(&[EventType::TabUpdate]);
        self.picker.load(&configuration);
    }

    fn update(&mut self, event: Event) -> bool {
        match self.picker.update(&event) {
            Some(zellij_nucleo::Response::Select(entry)) => {
                go_to_tab(entry.data);
                close_self();
            }
            Some(zellij_nucleo::Response::Cancel) => {
                close_self();
            }
            None => {}
        }

        if let Event::TabUpdate(tabs) = event {
            let len = tabs.len();
            let digits = if len == 0 {
                1
            } else {
                usize::try_from(len.ilog10()).unwrap() + 1
            };

            self.picker.clear();
            self.picker
                .extend(tabs.iter().map(|tab| zellij_nucleo::Entry {
                    data: u32::try_from(tab.position).unwrap(),
                    string: format!(
                        "{:digits$}: {}",
                        tab.position + 1,
                        tab.name
                    ),
                }));

            self.picker.select(
                get_focused_tab(&tabs).map(|tab| tab.position).unwrap_or(0),
            );
        }

        self.picker.needs_redraw()
    }

    fn render(&mut self, rows: usize, cols: usize) {
        self.picker.render(rows, cols);
    }
}
