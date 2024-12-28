use zellij_tile::prelude::*;

#[derive(Default)]
struct State {
    got_permission: bool,
    cmd: Option<String>,
    buffer: usize,
    ready: usize,
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
            EventType::PermissionRequestResult,
            EventType::RunCommandResult,
        ]);
        self.cmd = configuration.get("cmd").cloned();
    }

    fn pipe(&mut self, _message: PipeMessage) -> bool {
        if self.got_permission {
            if let Some(cmd) = &self.cmd {
                run_command(&["sh", "-c", cmd], ctx("paste"));
            } else {
                self.buffer += 1;
            }
        } else {
            self.buffer += 1;
        }

        false
    }

    fn update(&mut self, event: Event) -> bool {
        match event {
            Event::PermissionRequestResult(PermissionStatus::Granted) => {
                self.got_permission = true;
                set_selectable(false);
                hide_self();

                run_command(&["which", "pbpaste"], ctx("which pbpaste"));
                run_command(&["which", "wl-paste"], ctx("which wl-paste"));
                run_command(&["which", "xclip"], ctx("which xclip"));
            }
            Event::RunCommandResult(code, stdout, _, context) => {
                match context.get("source").map(|s| s.as_str()) {
                    Some("which pbpaste") => {
                        if code == Some(0) {
                            self.cmd = Some("pbpaste".to_string());
                        }
                        self.ready += 1;
                    }
                    Some("which wl-paste") => {
                        if code == Some(0) {
                            self.cmd = Some("wl-paste".to_string());
                        }
                        self.ready += 1;
                    }
                    Some("which xclip") => {
                        if code == Some(0) && self.cmd.is_none() {
                            self.cmd = Some(
                                "xclip -o -selection clipboard".to_string(),
                            );
                        }
                        self.ready += 1;
                    }
                    Some("paste") => {
                        if code == Some(0) {
                            write(stdout);
                        }
                    }
                    _ => {}
                }
            }
            _ => (),
        }

        if self.got_permission && self.ready == 3 && self.buffer > 0 {
            if let Some(cmd) = &self.cmd {
                for _ in 0..self.buffer {
                    run_command(&["sh", "-c", cmd], ctx("paste"));
                }
                self.buffer = 0;
            }
        }

        false
    }
}

fn ctx(source: &str) -> std::collections::BTreeMap<String, String> {
    let mut map = std::collections::BTreeMap::new();
    map.insert("source".to_string(), source.to_string());
    map
}
