# Settings
# --------

BUILD_DIR:=$(CURDIR)/.build
K_SUBMODULE:=$(BUILD_DIR)/k

.PHONY: clean \
        deps k-deps \
        build build-java build-ocaml \
        defn defn-java defn-ocaml \
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
java_defn:=$(patsubst %,$(java_dir)/%,$(k_files))
java_kompiled:=$(java_dir)/driver-kompiled/timestamp

ocaml_dir=$(BUILD_DIR)/defn/ocaml
ocaml_defn:=$(patsubst %,$(ocaml_dir)/%,$(k_files))
ocaml_kompiled:=$(ocaml_dir)/driver-kompiled/interpreter

# Tangle definition from *.md files

defn: defn-java defn-ocaml
defn-java: $(java_defn)
defn-ocaml: $(ocaml_defn)

$(java_dir)/%.k: %.k
	mkdir -p $(dir $@)
	cp $< $@

$(ocaml_dir)/%.k: %.k
	mkdir -p $(dir $@)
	cp $< $@

# Build

build: build-java build-ocaml
build-java: $(java_kompiled)
build-ocaml: $(ocaml_kompiled)

$(java_kompiled): $(java_defn)
	@echo "== kompile: $@"
	$(K_BIN)/kompile --backend java --directory $(java_dir) \
	                 --syntax-module DRIVER --main-module DRIVER $<

$(ocaml_kompiled): $(ocaml_defn)
	@echo "== kompile: $@"
	eval $$(opam config env) \
	    $(K_BIN)/kompile -O3 --non-strict --backend ocaml --directory $(ocaml_dir) \
	                     --syntax-module DRIVER --main-module DRIVER $<

# Tests
# -----

TEST=./ksol test

test_files:=$(wildcard tests/*.sol)

test: $(test_files:=.test)

%.test:
	$(TEST) $*
