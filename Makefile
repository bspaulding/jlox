APP_NAME := $(shell basename $(shell pwd))
BUILD_DIR := build
SRC_DIR := src
SRCS := $(shell find $(SRC_DIR) -name '*.java')
CLSS := $(SRCS:$(SRC_DIR)/%.java=$(BUILD_DIR)/%.class)

.PHONY: run
run: $(BUILD_DIR)/$(APP_NAME).jar
	java $(JAVA_OPTS) -jar $(BUILD_DIR)/$(APP_NAME).jar $(args)

$(BUILD_DIR)/$(APP_NAME).jar: $(BUILD_DIR)/Manifest.MF $(CLSS)
	jar cvfm $(BUILD_DIR)/$(APP_NAME).jar $(BUILD_DIR)/Manifest.MF -C $(BUILD_DIR)/ .

$(BUILD_DIR)/$(APP_NAME): $(BUILD_DIR)/$(APP_NAME).jar
	mkdir -p $(BUILD_DIR)/$(APP_NAME)
	cd $(BUILD_DIR)/$(APP_NAME) && tar xzvf ../$(APP_NAME).jar

$(CLSS): $(BUILD_DIR)/classes.list
	javac -d $(BUILD_DIR) @$(BUILD_DIR)/classes.list

$(BUILD_DIR)/classes.list: $(SRCS)
	find $(SRC_DIR) -name '*.java' > $(BUILD_DIR)/classes.list

$(BUILD_DIR)/Manifest.MF: Manifest.MF
	mkdir -p $(dir $@)
	cp Manifest.MF $(BUILD_DIR)

.PHONY: generate-ast
generate-ast: $(BUILD_DIR)/$(APP_NAME).jar
	java $(JAVA_OPTS) -cp $(BUILD_DIR)/$(APP_NAME).jar com.craftinginterpreters.tool.GenerateAst src/com/craftinginterpreters/lox/

.PHONY: print-ast
print-ast: $(BUILD_DIR)/$(APP_NAME).jar
	java $(JAVA_OPTS) -cp $(BUILD_DIR)/$(APP_NAME).jar com.craftinginterpreters.lox.AstPrinter

.PHONY: clean
clean:
	rm -rf build

