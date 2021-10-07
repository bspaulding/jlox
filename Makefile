SHELL=/usr/local/bin/fish

BUILD_DIR := build
SRC_DIR := src
SRCS := $(shell find $(SRC_DIR) -name '*.java')
CLSS := $(SRCS:$(SRC_DIR)/%.java=$(BUILD_DIR)/%.class)

jar: $(BUILD_DIR)/Manifest.MF $(CLSS)
	cd $(BUILD_DIR) && jar cmf Manifest.MF jlox.jar **/*.class

$(CLSS): $(BUILD_DIR)/classes.list
	javac -d $(BUILD_DIR) @$(BUILD_DIR)/classes.list

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/Manifest.MF: $(BUILD_DIR) Manifest.MF
	cp Manifest.MF $(BUILD_DIR)

$(BUILD_DIR)/classes.list: $(SRCS)
	echo $(CLSS)
	find $(SRC_DIR) -name '*.java' > $(BUILD_DIR)/classes.list

run: jar
	java -jar $(BUILD_DIR)/jlox.jar $(args)

unjar: jar
	mkdir -p $(BUILD_DIR)/jlox
	cd $(BUILD_DIR)/jlox && tar xzvf ../jlox.jar

clean:
	rm -rf build

