SRC_DIR := src/elm-scripts
ELM_OUTPUT := app/app.min.js

.PHONY: build
build:
	elm-make src/elm-scripts/Counter.elm --output=$(ELM_OUTPUT)

.PHONY: run
run: build
	cd app/ && python -m SimpleHTTPServer 8080

.PHONY: clean
clean:
	rm -f $(ELM_OUTPUT)