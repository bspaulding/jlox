SHELL=/usr/local/bin/fish

BUILD_DIR := build
SRC_DIR := src

jar: $(BUILD_DIR) $(BUILD_DIR)/Manifest.MF
	cd $(BUILD_DIR) && jar cmf Manifest.MF jlox.jar **/*.class

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	find $(SRC_DIR) -name '*.java' > $(BUILD_DIR)/classes.list
	javac -d $(BUILD_DIR) @$(BUILD_DIR)/classes.list

$(BUILD_DIR)/Manifest.MF:
	cp Manifest.MF $(BUILD_DIR)

run: jar
	java -jar $(BUILD_DIR)/jlox.jar $(args)

unjar: jar
	mkdir -p $(BUILD_DIR)/jlox
	cd $(BUILD_DIR)/jlox && tar xzvf ../jlox.jar

clean:
	rm -rf build

