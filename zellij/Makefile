include ../Makefile.include

build: .config/zellij/plugins/room.wasm

clean:
	@rm -f .config/zellij/plugins/room.wasm

.config/zellij/plugins/room.wasm:
	@mkdir -p "$(dir $@)"
	@curl -sL https://github.com/rvcas/room/releases/latest/download/"$(notdir $@)" > "$@"
