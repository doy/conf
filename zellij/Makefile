include ../Makefile.include

build: .config/zellij/plugins/room.wasm .config/zellij/plugins/paste.wasm

clean:
	@rm -f .config/zellij/plugins/room.wasm .config/zellij/plugins/paste.wasm

.config/zellij/plugins/room.wasm:
	@mkdir -p "$(dir $@)"
	@curl -sL https://github.com/rvcas/room/releases/latest/download/"$(notdir $@)" > "$@"

.config/zellij/plugins/paste.wasm: ../zellij-plugins/target/wasm32-wasip1/release/paste.wasm
	@mkdir -p "$(dir $@)"
	@cp $< $@

../zellij-plugins/target/wasm32-wasip1/release/paste.wasm: zellij-plugins

zellij-plugins:
	@cd ../zellij-plugins && cargo build --release
.PHONY: zellij-plugins
