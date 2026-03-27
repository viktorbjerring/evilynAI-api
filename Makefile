OPENAPI := openapi.yaml

.PHONY: docs docs-bundle help

help:
	@echo "Usage:"
	@echo "  make docs        Build HTML API docs and bundle OpenAPI spec"
	@echo "  make docs-bundle Bundle OpenAPI \$$ref references into a single file"

docs: docs-bundle
	npx @redocly/cli build-docs $(OPENAPI) -o openapi.html
	@echo "Docs written to openapi.html"

docs-bundle:
	npx @redocly/cli bundle $(OPENAPI) -o openapi.bundled.yaml
	@echo "Bundled spec written to openapi.bundled.yaml"
