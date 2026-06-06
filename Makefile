OPENAPI       := server-api/openapi.yaml
ASYNCAPI      := asyncapi.yaml
PATHS         := server-api/_paths.generated.yaml

.PHONY: docs docs-bundle docs-asyncapi build-api-docs help

help:
	@echo "Usage:"
	@echo "  make docs            Build all HTML docs and bundle OpenAPI spec"
	@echo "  make docs-bundle     Bundle OpenAPI \$$ref references into a single file"
	@echo "  make docs-asyncapi   Build HTML docs from the AsyncAPI SSE spec"
	@echo "  make build-api-docs  Regenerate $(PATHS) from the server-api/ tree"

docs: docs-bundle docs-asyncapi
	npx @redocly/cli build-docs $(OPENAPI) -o openapi.html
	@echo "Docs written to openapi.html"

docs-bundle: build-api-docs
	npx @redocly/cli bundle $(OPENAPI) -o openapi.bundled.yaml
	@echo "Bundled spec written to openapi.bundled.yaml"

build-api-docs:
	python3 scripts/build_api_docs.py

docs-asyncapi:
	npx @asyncapi/cli generate fromTemplate $(ASYNCAPI) @asyncapi/html-template -o asyncapi-docs --force-write
	@echo "AsyncAPI docs written to asyncapi-docs/"
