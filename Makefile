OPENAPI   := server-api/openapi.yaml
ASYNCAPI  := asyncapi.yaml

.PHONY: docs docs-bundle docs-asyncapi help

help:
	@echo "Usage:"
	@echo "  make docs          Build all HTML docs and bundle OpenAPI spec"
	@echo "  make docs-bundle   Bundle OpenAPI \$$ref references into a single file"
	@echo "  make docs-asyncapi Build HTML docs from the AsyncAPI SSE spec"

docs: docs-bundle docs-asyncapi
	npx @redocly/cli build-docs $(OPENAPI) -o openapi.html
	@echo "Docs written to openapi.html"

docs-bundle:
	npx @redocly/cli bundle $(OPENAPI) -o openapi.bundled.yaml
	@echo "Bundled spec written to openapi.bundled.yaml"

docs-asyncapi:
	npx @asyncapi/cli generate fromTemplate $(ASYNCAPI) @asyncapi/html-template -o asyncapi-docs --force-write
	@echo "AsyncAPI docs written to asyncapi-docs/"
