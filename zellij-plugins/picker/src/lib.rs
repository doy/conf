use zellij_tile::prelude::*;

use std::fmt::Write as _;

use unicode_width::UnicodeWidthChar as _;

const PICKERWORKER_PERMISSIONS: &[PermissionType] =
    &[PermissionType::ReadApplicationState];
const PICKERWORKER_EVENTS: &[EventType] = &[
    EventType::Key,
    EventType::CustomMessage,
    EventType::PaneUpdate,
    EventType::TabUpdate,
];

pub fn permissions() -> &'static [PermissionType] {
    PICKERWORKER_PERMISSIONS
}

pub fn subscribe() {
    zellij_tile::prelude::subscribe(PICKERWORKER_EVENTS);
}

#[derive(
    Debug, Clone, Default, serde::Serialize, serde::Deserialize, PartialEq, Eq,
)]
pub struct Entry<T> {
    pub string: String,
    pub data: T,
}

impl<T> AsRef<str> for Entry<T> {
    fn as_ref(&self) -> &str {
        &self.string
    }
}

#[derive(Debug, Clone, Default, serde::Serialize, serde::Deserialize)]
pub struct Renderer<T> {
    visible_entries: Vec<(Entry<T>, Vec<u32>)>,
    query: String,
    selected: usize,
    input_mode: InputMode,
    rows: usize,
    cols: usize,
}

impl<T> Renderer<T> {
    pub fn render(&self) {
        use owo_colors::OwoColorize as _;

        print!("  ");
        if self.input_mode == InputMode::Normal && self.query.is_empty() {
            print!(
                "{}",
                "(press / to search)".fg::<owo_colors::colors::BrightBlack>()
            );
        } else {
            print!("{}", self.query);
            if self.input_mode == InputMode::Search {
                print!("{}", " ".bg::<owo_colors::colors::Green>());
            }
        }
        println!();

        let lines: Vec<_> = self
            .visible_entries
            .iter()
            .enumerate()
            .map(|(i, (item, indices))| {
                let mut line = String::new();

                if i == self.selected {
                    write!(
                        &mut line,
                        "{} ",
                        ">".fg::<owo_colors::colors::Yellow>()
                    )
                    .unwrap();
                } else {
                    write!(&mut line, "  ").unwrap();
                }

                let mut current_col = 2;
                for (char_idx, c) in item.string.chars().enumerate() {
                    if current_col + c.width().unwrap_or(0) > self.cols - 6 {
                        write!(
                            &mut line,
                            "{}",
                            " [...]".fg::<owo_colors::colors::BrightBlack>()
                        )
                        .unwrap();
                        break;
                    }
                    if indices.contains(&u32::try_from(char_idx).unwrap()) {
                        write!(
                            &mut line,
                            "{}",
                            c.fg::<owo_colors::colors::Cyan>()
                        )
                        .unwrap();
                    } else if i == self.selected {
                        write!(
                            &mut line,
                            "{}",
                            c.fg::<owo_colors::colors::Yellow>()
                        )
                        .unwrap();
                    } else {
                        write!(&mut line, "{}", c).unwrap();
                    }

                    current_col += c.width().unwrap_or(0);
                }
                line
            })
            .collect();

        print!("{}", lines.join("\n"));
    }
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub enum Request {
    Event(Event),
    ChangeMode(InputMode),
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub enum Response<T> {
    Render(Renderer<T>),
    Select(Entry<T>),
    Cancel,
}

pub trait Picker<'a>: Default {
    const WORKER_NAME: &'static str;
    type Item: std::fmt::Debug
        + Default
        + Clone
        + serde::Serialize
        + serde::de::DeserializeOwned
        + PartialEq
        + Eq;

    fn update(
        &mut self,
        event: &Event,
        all_entries: &mut Vec<Entry<Self::Item>>,
    ) -> bool;

    fn handle_event(event: Event) -> Option<Response<Self::Item>> {
        send_request(
            Self::WORKER_NAME,
            Self::WORKER_NAME,
            &Request::Event(event.clone()),
        );
        match event {
            Event::CustomMessage(message, id) if id == Self::WORKER_NAME => {
                Some(serde_json::from_str(&message).unwrap())
            }
            _ => None,
        }
    }

    fn enter_search_mode() {
        send_request(
            Self::WORKER_NAME,
            Self::WORKER_NAME,
            &Request::ChangeMode(InputMode::Search),
        );
    }
}

#[derive(
    Debug,
    Default,
    serde::Serialize,
    serde::Deserialize,
    Clone,
    Copy,
    PartialEq,
    Eq,
)]
pub enum InputMode {
    #[default]
    Normal,
    Search,
}

#[derive(Default, serde::Serialize, serde::Deserialize)]
pub struct PickerWorker<'a, T: Picker<'a>> {
    picker: T,
    query: String,
    all_entries: Vec<Entry<T::Item>>,
    search_results: Vec<(Entry<T::Item>, Vec<u32>)>,
    selected: usize,
    rows: usize,
    cols: usize,
    input_mode: InputMode,

    #[serde(skip_serializing, skip_deserializing)]
    pattern: nucleo_matcher::pattern::Pattern,
    #[serde(skip_serializing, skip_deserializing)]
    matcher: nucleo_matcher::Matcher,
}

impl<'a, T: Picker<'a>> PickerWorker<'a, T> {
    fn update(&mut self, event: &Event) {
        let mut update = false;

        update |= self.picker.update(event, &mut self.all_entries);

        match event {
            Event::Key(key) => update |= self.handle_key(key),
            Event::TabUpdate(tabs) => {
                self.selected = get_focused_tab(tabs)
                    .map(|info| info.position)
                    .unwrap_or(0);
            }
            Event::PaneUpdate(panes) => {
                let id = get_plugin_ids().plugin_id;
                for pane in panes.panes.values().flatten() {
                    if pane.is_plugin && pane.id == id {
                        if self.rows != pane.pane_content_rows
                            || self.cols != pane.pane_content_columns
                        {
                            self.rows = pane.pane_content_rows;
                            self.cols = pane.pane_content_columns;
                            update = true;
                        }
                        break;
                    }
                }
            }
            _ => {}
        }

        if update {
            self.search();
            self.render();
        }
    }

    fn handle_key(&mut self, key: &KeyWithModifier) -> bool {
        self.handle_global_key(key)
            .or_else(|| match self.input_mode {
                InputMode::Normal => self.handle_normal_key(key),
                InputMode::Search => self.handle_search_key(key),
            })
            .unwrap_or(false)
    }

    fn handle_normal_key(&mut self, key: &KeyWithModifier) -> Option<bool> {
        match key.bare_key {
            BareKey::Char('j') if key.has_no_modifiers() => {
                self.down();
                Some(true)
            }
            BareKey::Char('k') if key.has_no_modifiers() => {
                self.up();
                Some(true)
            }
            BareKey::Char(c @ '1'..='8') if key.has_no_modifiers() => {
                let position =
                    usize::try_from(c.to_digit(10).unwrap() - 1).unwrap();
                if let Some(item) = self.search_results.get(position) {
                    Self::send_response(&Response::Select(item.0.clone()));
                }
                Some(false)
            }
            BareKey::Char('9') if key.has_no_modifiers() => {
                if let Some(item) = self.search_results.last() {
                    Self::send_response(&Response::Select(item.0.clone()));
                }
                Some(false)
            }
            BareKey::Char('/') if key.has_no_modifiers() => {
                self.input_mode = InputMode::Search;
                Some(true)
            }
            _ => None,
        }
    }

    fn handle_search_key(&mut self, key: &KeyWithModifier) -> Option<bool> {
        match key.bare_key {
            BareKey::Char(c) if key.has_no_modifiers() => {
                self.query.push(c);
                Some(true)
            }
            BareKey::Backspace if key.has_no_modifiers() => {
                self.query.pop();
                Some(true)
            }
            _ => None,
        }
    }

    fn handle_global_key(&mut self, key: &KeyWithModifier) -> Option<bool> {
        match key.bare_key {
            BareKey::Tab if key.has_no_modifiers() => {
                self.down();
                Some(true)
            }
            BareKey::Down if key.has_no_modifiers() => {
                self.down();
                Some(true)
            }
            BareKey::Tab if key.has_modifiers(&[KeyModifier::Shift]) => {
                self.up();
                Some(true)
            }
            BareKey::Up if key.has_no_modifiers() => {
                self.up();
                Some(true)
            }
            BareKey::Esc if key.has_no_modifiers() => {
                self.input_mode = InputMode::Normal;
                Some(true)
            }
            BareKey::Char('c') if key.has_modifiers(&[KeyModifier::Ctrl]) => {
                Self::send_response(&Response::Cancel);
                Some(false)
            }
            BareKey::Enter if key.has_no_modifiers() => {
                Self::send_response(&Response::Select(
                    self.search_results[self.selected].0.clone(),
                ));
                Some(false)
            }
            _ => None,
        }
    }

    fn search(&mut self) {
        let prev_len = self.search_results.len();

        self.pattern.reparse(
            &self.query,
            nucleo_matcher::pattern::CaseMatching::Ignore,
            nucleo_matcher::pattern::Normalization::Smart,
        );
        let mut haystack = vec![];
        let mut new_search_results: Vec<_> = self
            .all_entries
            .iter()
            .filter_map(|entry| {
                let haystack = nucleo_matcher::Utf32Str::new(
                    &entry.string,
                    &mut haystack,
                );
                let mut indices = vec![];
                self.pattern
                    .indices(haystack, &mut self.matcher, &mut indices)
                    .map(|score| (entry.clone(), score, indices))
            })
            .collect();
        new_search_results
            .sort_by_key(|(_, score, _)| std::cmp::Reverse(*score));
        self.search_results = new_search_results
            .into_iter()
            .map(|(entry, _, indices)| (entry, indices))
            .collect();

        if prev_len != self.search_results.len() {
            self.selected = 0;
        }
    }

    fn render(&self) {
        if self.rows == 0 {
            return;
        }
        let visible_entry_count = self.rows - 1;
        let renderer = Renderer {
            visible_entries: self
                .search_results
                .iter()
                .skip(
                    (self.selected / visible_entry_count)
                        * visible_entry_count,
                )
                .take(visible_entry_count)
                .cloned()
                .collect(),
            query: self.query.clone(),
            selected: self.selected % visible_entry_count,
            input_mode: self.input_mode,
            rows: self.rows,
            cols: self.cols,
        };
        Self::send_response(&Response::Render(renderer));
    }

    fn send_response(response: &Response<T::Item>) {
        send_response(T::WORKER_NAME, response);
    }

    fn down(&mut self) {
        if self.search_results.is_empty() {
            return;
        }
        self.selected = (self.search_results.len() + self.selected + 1)
            % self.search_results.len();
    }

    fn up(&mut self) {
        if self.search_results.is_empty() {
            return;
        }
        self.selected = (self.search_results.len() + self.selected - 1)
            % self.search_results.len();
    }
}

impl<'a, T> zellij_tile::ZellijWorker<'a> for PickerWorker<'a, T>
where
    T: Picker<'a> + serde::Serialize + serde::Deserialize<'a>,
{
    fn on_message(&mut self, message: String, id: String) {
        if id != T::WORKER_NAME {
            return;
        }

        match serde_json::from_str(&message) {
            Ok(Request::Event(event)) => self.update(&event),
            Ok(Request::ChangeMode(mode)) => {
                self.input_mode = mode;
            }
            Err(_e) => todo!(),
        }
    }
}

fn send_request(worker_name: &str, message_id: &str, request: &Request) {
    post_message_to(PluginMessage::new_to_worker(
        worker_name,
        &serde_json::to_string(request).unwrap(),
        message_id,
    ));
}

fn send_response<T: serde::Serialize>(
    message_id: &str,
    response: &Response<T>,
) {
    post_message_to_plugin(PluginMessage::new_to_plugin(
        &serde_json::to_string(response).unwrap(),
        message_id,
    ));
}
