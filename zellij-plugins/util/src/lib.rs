use zellij_tile::prelude::*;

#[derive(Default)]
pub struct FocusedPaneTracker {
    tabs: Vec<TabInfo>,
    panes: PaneManifest,
}

impl FocusedPaneTracker {
    pub fn load(&self) {
        subscribe(&[EventType::TabUpdate, EventType::PaneUpdate]);
    }

    pub fn update(&mut self, event: &Event) {
        match event {
            Event::TabUpdate(tabs) => {
                self.tabs = tabs.clone();
            }
            Event::PaneUpdate(panes) => {
                self.panes = panes.clone();
            }
            _ => {}
        }
    }

    pub fn write(&self, bytes: Vec<u8>) {
        if let Some(id) = self.get_focused_pane_id() {
            write_to_pane_id(bytes, id);
        }
    }

    pub fn write_chars(&self, string: &str) {
        if let Some(id) = self.get_focused_pane_id() {
            write_chars_to_pane_id(string, id);
        }
    }

    fn get_focused_pane_id(&self) -> Option<PaneId> {
        get_focused_pane(
            get_focused_tab(&self.tabs)
                .map(|tab| tab.position)
                .unwrap_or(0),
            &self.panes,
        )
        .and_then(|pane| {
            (!pane.is_plugin).then_some(PaneId::Terminal(pane.id))
        })
    }
}

pub fn ctx(source: &str) -> std::collections::BTreeMap<String, String> {
    let mut map = std::collections::BTreeMap::new();
    map.insert("source".to_string(), source.to_string());
    map
}
