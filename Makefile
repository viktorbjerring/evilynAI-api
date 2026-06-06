OPENAPI       := server-api/openapi.yaml
ASYNCAPI      := asyncapi.yaml
TOOLS_MODULE  := server-api/tools/tools-module.yaml

.PHONY: docs docs-bundle docs-asyncapi build-tools-module help

help:
	@echo "Usage:"
	@echo "  make docs                Build all HTML docs and bundle OpenAPI spec"
	@echo "  make docs-bundle         Bundle OpenAPI \$$ref references into a single file"
	@echo "  make docs-asyncapi       Build HTML docs from the AsyncAPI SSE spec"
	@echo "  make build-tools-module  Regenerate $(TOOLS_MODULE) from modules/*/*.yaml"

docs: docs-bundle docs-asyncapi
	npx @redocly/cli build-docs $(OPENAPI) -o openapi.html
	@echo "Docs written to openapi.html"

docs-bundle: build-tools-module
	npx @redocly/cli bundle $(OPENAPI) -o openapi.bundled.yaml
	@echo "Bundled spec written to openapi.bundled.yaml"

build-tools-module:
	python3 scripts/build_tools_module.py

docs-asyncapi:
	npx @asyncapi/cli generate fromTemplate $(ASYNCAPI) @asyncapi/html-template -o asyncapi-docs --force-write
	@echo "AsyncAPI docs written to asyncapi-docs/"
