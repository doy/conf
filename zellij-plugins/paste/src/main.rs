use zellij_tile::prelude::*;

const DEFAULT_COMMANDS: &[&str] =
    &["pbpaste", "wl-paste", "xclip -o -selection clipboard"];

#[derive(Default)]
struct State {
    got_permission: bool,
    cmds: Vec<(String, Option<bool>)>,
    pending_pastes: usize,
}

impl State {
    fn cmd(&self) -> Option<&str> {
        if self.cmds.iter().all(|cmd| cmd.1.is_some()) {
            self.cmds
                .iter()
                .find(|cmd| cmd.1.unwrap())
                .map(|cmd| cmd.0.as_ref())
        } else {
            None
        }
    }
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
        self.cmds = configuration
            .get("cmds")
            .map(|cmds| cmds.split(',').collect())
            .unwrap_or_else(|| DEFAULT_COMMANDS.to_vec())
            .into_iter()
            .map(|s| (s.to_string(), None))
            .collect();
    }

    fn pipe(&mut self, _message: PipeMessage) -> bool {
        if let Some(cmd) = self.cmd() {
            run_command(&["sh", "-c", cmd], ctx("paste"));
        } else {
            self.pending_pastes += 1;
        }

        false
    }

    fn update(&mut self, event: Event) -> bool {
        match event {
            Event::PermissionRequestResult(PermissionStatus::Granted) => {
                self.got_permission = true;
                set_selectable(false);
                hide_self();

                let ctx = ctx("which");
                for (i, (cmd, _)) in self.cmds.iter().enumerate() {
                    let mut ctx = ctx.clone();
                    ctx.insert("idx".to_string(), i.to_string());
                    let cmd = cmd.split_whitespace().next().unwrap();
                    run_command(&["which", cmd], ctx);
                }
            }
            Event::RunCommandResult(code, stdout, _, context) => {
                match context.get("source").map(|s| s.as_str()) {
                    Some("which") => {
                        let idx: usize =
                            context.get("idx").unwrap().parse().unwrap();
                        self.cmds[idx].1 = Some(code == Some(0));
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

        if self.pending_pastes > 0 {
            if let (true, Some(cmd)) = (self.got_permission, self.cmd()) {
                for _ in 0..self.pending_pastes {
                    run_command(&["sh", "-c", cmd], ctx("paste"));
                }
                self.pending_pastes = 0;
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
