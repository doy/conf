include ../Makefile.include

LOCAL_PLUGINS=fzf paste rbw tabs
BUILT_PLUGINS=$(patsubst %,../zellij-plugins/target/wasm32-wasip1/release/%.wasm,$(LOCAL_PLUGINS))
INSTALLED_PLUGINS=$(patsubst %,.config/zellij/plugins/%.wasm,$(LOCAL_PLUGINS))

build: $(INSTALLED_PLUGINS)

clean:
	@rm -f $(INSTALLED_PLUGINS)

.config/zellij/plugins/%.wasm: ../zellij-plugins/target/wasm32-wasip1/release/%.wasm
	@mkdir -p "$(dir $@)"
	@cp $< $@

$(BUILT_PLUGINS) &: $(shell git ls-files ../zellij-plugins)
	@cd ../zellij-plugins && cargo build --release && touch target/wasm32-wasip1/release/*.wasm
