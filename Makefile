SHELL=/usr/local/bin/fish

BUILD_DIR := build
SRC_DIR := src
SRCS := $(shell find $(SRC_DIR) -name '*.java')
CLSS := $(SRCS:$(SRC_DIR)/%.java=$(BUILD_DIR)/%.class)

.PHONY: clean
clean:
	rm -rf build

.PHONY: run
run: $(BUILD_DIR)/jlox.jar
	java -jar $(BUILD_DIR)/jlox.jar $(args)

$(BUILD_DIR)/jlox.jar: $(BUILD_DIR)/Manifest.MF $(CLSS)
	cd $(BUILD_DIR) && jar cmf Manifest.MF jlox.jar **/*.class

$(BUILD_DIR)/jlox: $(BUILD_DIR)/jlox.jar
	mkdir -p $(BUILD_DIR)/jlox
	cd $(BUILD_DIR)/jlox && tar xzvf ../jlox.jar

$(CLSS): $(BUILD_DIR)/classes.list
	javac -d $(BUILD_DIR) @$(BUILD_DIR)/classes.list

$(BUILD_DIR)/classes.list: $(SRCS)
	find $(SRC_DIR) -name '*.java' > $(BUILD_DIR)/classes.list

$(BUILD_DIR)/Manifest.MF: Manifest.MF
	mkdir -p $(dir $@)
	cp Manifest.MF $(BUILD_DIR)

