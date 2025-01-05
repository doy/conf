use zellij_tile::prelude::*;

use picker::Picker as _;

#[derive(Default)]
struct State {
    picker_renderer: picker::Renderer<u32>,
}

#[derive(Default, serde::Serialize, serde::Deserialize)]
struct TabPicker;

impl picker::Picker<'_> for TabPicker {
    const WORKER_NAME: &'static str = "tab_picker";
    type Item = u32;

    fn update(
        &mut self,
        event: &Event,
        all_entries: &mut Vec<picker::Entry<Self::Item>>,
    ) -> bool {
        if let Event::TabUpdate(tabs) = event {
            let digits = digits(tabs.len());
            *all_entries = tabs
                .iter()
                .map(|tab| picker::Entry {
                    data: u32::try_from(tab.position).unwrap(),
                    string: format!(
                        "{:digits$}: {}",
                        tab.position + 1,
                        tab.name
                    ),
                })
                .collect();
            true
        } else {
            false
        }
    }
}

register_plugin!(State);
register_worker!(
    picker::PickerWorker<'static, TabPicker>,
    tab_picker_worker,
    TAB_PICKER_WORKER
);

impl ZellijPlugin for State {
    fn load(
        &mut self,
        _configuration: std::collections::BTreeMap<String, String>,
    ) {
        let mut permissions = vec![
            PermissionType::ReadApplicationState,
            PermissionType::ChangeApplicationState,
        ];
        permissions.extend(picker::permissions());
        request_permission(&permissions);

        subscribe(&[EventType::TabUpdate]);
        picker::subscribe();
    }

    fn update(&mut self, event: Event) -> bool {
        if let Event::TabUpdate(tabs) = &event {
            TabPicker::select(
                get_focused_tab(tabs).map(|tab| tab.position).unwrap_or(0),
            );
        }

        match TabPicker::handle_event(event) {
            Some(picker::Response::Render(renderer)) => {
                self.picker_renderer = renderer;
                return true;
            }
            Some(picker::Response::Select(tab)) => {
                go_to_tab(tab.data);
                close_self();
            }
            Some(picker::Response::Cancel) => {
                close_self();
            }
            None => {}
        }

        false
    }

    fn render(&mut self, _: usize, _: usize) {
        self.picker_renderer.render();
    }
}

fn digits(n: usize) -> usize {
    if n == 0 {
        1
    } else {
        usize::try_from(n.ilog10()).unwrap() + 1
    }
}
