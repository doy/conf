use zellij_tile::prelude::*;

use std::fmt::Write as _;

use owo_colors::OwoColorize as _;
use unicode_width::UnicodeWidthChar as _;

const PICKER_EVENTS: &[EventType] = &[EventType::Key];

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

#[derive(Debug)]
pub enum Response<T> {
    Select(Entry<T>),
    Cancel,
}

#[derive(Debug, Default, Clone, Copy, PartialEq, Eq)]
enum InputMode {
    #[default]
    Normal,
    Search,
}

#[derive(Default)]
pub struct Picker<T: Clone + PartialEq> {
    query: String,
    all_entries: Vec<Entry<T>>,
    search_results: Vec<(Entry<T>, Vec<u32>)>,
    selected: usize,
    input_mode: InputMode,
    needs_redraw: bool,

    pattern: nucleo_matcher::pattern::Pattern,
    matcher: nucleo_matcher::Matcher,
}

impl<T: Clone + PartialEq> Picker<T> {
    pub fn load(
        &mut self,
        _configuration: &std::collections::BTreeMap<String, String>,
    ) {
        subscribe(PICKER_EVENTS);
    }

    pub fn update(&mut self, event: &Event) -> Option<Response<T>> {
        match event {
            Event::Key(key) => self.handle_key(key),
            _ => None,
        }
    }

    pub fn render(&mut self, rows: usize, cols: usize) {
        if rows == 0 {
            return;
        }

        let visible_entry_count = rows - 1;
        let visible_entries: Vec<(Entry<T>, Vec<u32>)> = self
            .search_results
            .iter()
            .skip((self.selected / visible_entry_count) * visible_entry_count)
            .take(visible_entry_count)
            .cloned()
            .collect();
        let visible_selected = self.selected % visible_entry_count;

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

        let lines: Vec<_> = visible_entries
            .iter()
            .enumerate()
            .map(|(i, (item, indices))| {
                let mut line = String::new();

                if i == visible_selected {
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
                    if current_col + c.width().unwrap_or(0) > cols - 6 {
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
                    } else if i == visible_selected {
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

        self.needs_redraw = false;
    }

    pub fn needs_redraw(&self) -> bool {
        self.needs_redraw
    }

    pub fn select(&mut self, idx: usize) {
        self.selected = idx;
        self.needs_redraw = true;
    }

    pub fn clear(&mut self) {
        self.all_entries.clear();
        self.search();
    }

    pub fn extend(&mut self, iter: impl IntoIterator<Item = Entry<T>>) {
        self.all_entries.extend(iter);
        self.search();
    }

    pub fn enter_search_mode(&mut self) {
        self.input_mode = InputMode::Search;
    }

    fn search(&mut self) {
        let prev_selected = self
            .search_results
            .get(self.selected)
            .map(|(entry, _)| entry.clone());

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

        if let Some(prev_selected) = prev_selected {
            self.selected = self
                .search_results
                .iter()
                .enumerate()
                .find_map(|(idx, (entry, _))| {
                    (*entry == prev_selected).then_some(idx)
                })
                .unwrap_or(0);
        }

        self.needs_redraw = true;
    }

    fn handle_key(&mut self, key: &KeyWithModifier) -> Option<Response<T>> {
        self.handle_global_key(key)
            .or_else(|| match self.input_mode {
                InputMode::Normal => self.handle_normal_key(key),
                InputMode::Search => self.handle_search_key(key),
            })
    }

    fn handle_normal_key(
        &mut self,
        key: &KeyWithModifier,
    ) -> Option<Response<T>> {
        match key.bare_key {
            BareKey::Char('j') if key.has_no_modifiers() => {
                self.down();
            }
            BareKey::Char('k') if key.has_no_modifiers() => {
                self.up();
            }
            BareKey::Char(c @ '1'..='8') if key.has_no_modifiers() => {
                let position =
                    usize::try_from(c.to_digit(10).unwrap() - 1).unwrap();
                return self
                    .search_results
                    .get(position)
                    .map(|item| Response::Select(item.0.clone()));
            }
            BareKey::Char('9') if key.has_no_modifiers() => {
                return self
                    .search_results
                    .last()
                    .map(|item| Response::Select(item.0.clone()))
            }
            BareKey::Char('/') if key.has_no_modifiers() => {
                self.input_mode = InputMode::Search;
                self.needs_redraw = true;
            }
            _ => {}
        }

        None
    }

    fn handle_search_key(
        &mut self,
        key: &KeyWithModifier,
    ) -> Option<Response<T>> {
        match key.bare_key {
            BareKey::Char(c) if key.has_no_modifiers() => {
                self.query.push(c);
                self.search();
                self.selected = 0;
            }
            BareKey::Backspace if key.has_no_modifiers() => {
                self.query.pop();
                self.search();
                self.selected = 0;
            }
            _ => {}
        }

        None
    }

    fn handle_global_key(
        &mut self,
        key: &KeyWithModifier,
    ) -> Option<Response<T>> {
        match key.bare_key {
            BareKey::Tab if key.has_no_modifiers() => {
                self.down();
            }
            BareKey::Down if key.has_no_modifiers() => {
                self.down();
            }
            BareKey::Tab if key.has_modifiers(&[KeyModifier::Shift]) => {
                self.up();
            }
            BareKey::Up if key.has_no_modifiers() => {
                self.up();
            }
            BareKey::Esc if key.has_no_modifiers() => {
                self.input_mode = InputMode::Normal;
                self.needs_redraw = true;
            }
            BareKey::Char('c') if key.has_modifiers(&[KeyModifier::Ctrl]) => {
                return Some(Response::Cancel);
            }
            BareKey::Enter if key.has_no_modifiers() => {
                return Some(Response::Select(
                    self.search_results[self.selected].0.clone(),
                ));
            }
            _ => {}
        }

        None
    }

    fn down(&mut self) {
        if self.search_results.is_empty() {
            return;
        }
        self.selected = (self.search_results.len() + self.selected + 1)
            % self.search_results.len();
        self.needs_redraw = true;
    }

    fn up(&mut self) {
        if self.search_results.is_empty() {
            return;
        }
        self.selected = (self.search_results.len() + self.selected - 1)
            % self.search_results.len();
        self.needs_redraw = true;
    }
}
