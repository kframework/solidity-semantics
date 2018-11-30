# Settings
# --------

BUILD_DIR:=$(CURDIR)/.build

K_SUBMODULE:=$(BUILD_DIR)/k

.PHONY: all clean deps k-deps build test

clean:
	rm -rf $(BUILD_DIR)
	git submodule update --init

# Dependencies
# ------------

deps: k-deps
k-deps: $(K_SUBMODULE)/make.timestamp

$(K_SUBMODULE)/make.timestamp:
	@echo "== submodule: $@"
	git submodule update --init -- $(K_SUBMODULE)
	cd $(K_SUBMODULE) \
		&& mvn package -q -DskipTests -U
	touch $(K_SUBMODULE)/make.timestamp

K_BIN=$(K_SUBMODULE)/k-distribution/target/release/k/bin

# Building
# --------

build: build-java
build-java: .build/java/driver-kompiled/timestamp

# Tangle definition from *.md files

k_files:=driver.k configuration.k contract.k expression.k function.k solidity.k solidity-syntax.k statement.k
java_files:=$(patsubst %,.build/java/%,$(k_files))
defn_files:=$(java_files)

defn: $(defn_files)

.build/java/%.k: %.k
	mkdir -p $(dir $@)
	cp $< $@

# Java Backend

.build/java/driver-kompiled/timestamp: $(java_files)
	@echo "== kompile: $@"
	$(K_BIN)/kompile --debug --main-module DRIVER --backend java \
					--syntax-module DRIVER $< --directory .build/java -I .build/java

# Tests
# -----

test: build-java
