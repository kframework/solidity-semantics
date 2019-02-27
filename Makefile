# Settings
# --------

build_dir:=.build
defn_dir:=$(build_dir)/defn
k_submodule:=$(build_dir)/k
k_bin:=$(k_submodule)/k-distribution/target/release/k/bin

.PHONY: deps ocaml-deps \
        defn defn-ocaml \
        build build-ocaml \
        test test-execution test-simple test-proof

all: build

clean:
	rm -rf $(build_dir)
	git submodule update --init --recursive

# Build Dependencies (K Submodule)
# --------------------------------

deps: $(k_submodule)/make.timestamp ocaml-deps

$(k_submodule)/make.timestamp:
	git submodule update --init --recursive
	cd $(k_submodule) && mvn package -DskipTests -Dllvm.backend.skip -Dhaskell.backend.skip
	touch $(k_submodule)/make.timestamp

ocaml-deps:
	eval $$(opam config env) \
	    opam install --yes mlgmp zarith uuidm

# Building Definition
# -------------------

sol_files:=driver.k configuration.k function.k solidity-syntax.k contract.k expression.k solidity.k statement.k

ocaml_dir:=$(defn_dir)/ocaml
ocaml_defn:=$(patsubst %, $(ocaml_dir)/%, $(sol_files))
ocaml_kompiled:=$(ocaml_dir)/test-kompiled/interpreter

java_dir:=$(defn_dir)/java
java_defn:=$(patsubst %, $(java_dir)/%, $(sol_files))
java_kompiled:=$(java_dir)/test-kompiled/compiled.txt

# Tangle definition from *.md files

defn: defn-ocaml defn-java
defn-ocaml: $(ocaml_defn)
defn-java: $(java_defn)

$(ocaml_dir)/%.k: %.k
	@echo "==  copy: $@"
	mkdir -p $(dir $@)
	cp $< $@

$(java_dir)/%.k: %.k
	@echo "==  copy: $@"
	mkdir -p $(dir $@)
	cp $< $@

# Build definitions

build: build-ocaml build-java
build-ocaml: $(ocaml_kompiled)
build-java: $(java_kompiled)

$(ocaml_kompiled): $(ocaml_defn)
	@echo "== kompile: $@"
	eval $$(opam config env)                                 \
	    $(k_bin)/kompile -O3 --non-strict --backend ocaml    \
	    --directory $(ocaml_dir) -I $(ocaml_dir)             \
	    --main-module DRIVER --syntax-module DRIVER $<

$(java_kompiled): $(java_defn)
	@echo "== kompile: $@"
	eval $$(opam config env)                                 \
	    $(k_bin)/kompile --backend java                      \
	    --directory $(java_dir) -I $(java_dir)               \
	    --main-module DRIVER --syntax-module DRIVER $<

# Testing
# -------

TEST_CONCRETE_BACKEND=java
TEST_SYMBOLIC_BACKEND=java
TEST=./ksol

tests/%.test: tests/%
	 $(TEST) test --backend $(TEST_CONCRETE_BACKEND) $<

tests/%.prove: tests/%
	$(TEST) prove --backend $(TEST_SYMBOLIC_BACKEND) $<

test: test-execution test-proof

### Execution Tests

test-execution: test-simple

simple_tests:=$(wildcard tests/simple/*.sol)

test-simple: $(simple_tests:=.test)

### Proof Tests

proof_tests:=$(wildcard tests/proofs/*-spec.k)

test-proof: $(proof_tests:=.prove)
