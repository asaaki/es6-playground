# NEEDS:
# npm install -g babel uglify-js

SRC_DIR=src
DIST_DIR=dist
TOOLS_DIR=tools

ES6_DIR_TREE=$(shell find $(SRC_DIR) -type d)
ES6_FILES=$(shell find $(SRC_DIR) -name "*.es6")

JS_DIR_TREE=$(subst $(SRC_DIR),$(DIST_DIR),$(ES6_DIR_TREE))
_JS_FILES=$(ES6_FILES:.es6=.js)
JS_FILES=$(subst $(SRC_DIR),$(DIST_DIR),$(_JS_FILES))

BABEL_HELPERS=$(TOOLS_DIR)/babelHelpers.js
BABEL_FLAGS=--remove-comments -r -M -m amd

ALMOND=$(TOOLS_DIR)/almond.js
ENTRYPOINT=$(SRC_DIR)/main.js

APP_FILE_NAME=app
APP_FILE=$(DIST_DIR)/$(APP_FILE_NAME).js
APP_FILE_MIN=$(DIST_DIR)/$(APP_FILE_NAME).min.js
APP_FILES=$(APP_FILE) $(APP_FILE_MIN)
OUT_FILES=$(APP_FILES) $(APP_FILES:.js=.js.gz)

all: build

build: compile merge minify compress

dirs:
	mkdir -p $(JS_DIR_TREE)

compile: $(JS_FILES)

$(JS_FILES): $(DIST_DIR)/%.js: $(SRC_DIR)/%.es6 dirs
	cd $(SRC_DIR) && babel $(BABEL_FLAGS) $*.es6 | sed -e 's/_babelHelpers/babelHelpers/g' > ../$@

merge: compile $(ALMOND) $(BABEL_HELPERS) dirs
	cat $(ALMOND) $(BABEL_HELPERS) $(JS_FILES) $(ENTRYPOINT) > $(APP_FILE)

minify: merge dirs
	uglifyjs --compress --mangle -- $(APP_FILE) > $(APP_FILE_MIN)

compress: minify dirs
	gzip --force --keep $(APP_FILES)

clean:
	rm -rf $(DIST_DIR)
