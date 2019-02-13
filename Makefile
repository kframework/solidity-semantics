# Settings
# --------

BUILD_DIR:=$(CURDIR)/.build
K_SUBMODULE:=$(BUILD_DIR)/k

.PHONY: clean \
        deps k-deps \
        build build-java \
        defn defn-java \
        test

clean:
	rm -rf $(BUILD_DIR)
	git submodule update --init --recursive

# Dependencies
# ------------

deps: k-deps
k-deps: $(K_SUBMODULE)/make.timestamp

$(K_SUBMODULE)/make.timestamp:
	@echo "== submodule: $@"
	git submodule update --init --recursive
	cd $(K_SUBMODULE) && mvn package -q -DskipTests -U -Dllvm.backend.skip -Dhaskell.backend.skip
	touch $(K_SUBMODULE)/make.timestamp

K_BIN=$(K_SUBMODULE)/k-distribution/target/release/k/bin

# Building
# --------

k_files:=driver.k configuration.k contract.k expression.k function.k solidity.k solidity-syntax.k statement.k

java_dir=$(BUILD_DIR)/defn/java
java_defn:=$(patsubst %,$(java_dir)%,$(k_files))
java_kompiled:=$(java_dir)/driver-kompiled/timestamp

# Tangle definition from *.md files

defn: defn-java
defn-java: $(java_defn)

$(java_dir)/%.k: %.k
	cp $< $@

# Build

build: build-java
build-java: $(java_kompiled)

$(java_kompiled): $(java_defn)
	@echo "== kompile: $@"
	$(K_BIN)/kompile --backend java --directory $(java_dir) \
	                 --syntax-module DRIVER --main-module DRIVER $<

# Tests
# -----

test: build-java
