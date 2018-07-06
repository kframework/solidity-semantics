clean:
	rm -f -r *~ tests/*~

cleanall:
	rm -f -r *~ *-kompiled

deps: ocaml-deps

ocaml-deps:
	opam init --quiet --no-setup
	opam repository add k "$(k_submodule)/k-distribution/target/release/k/lib/opam" \
		|| opam repository set-url k "$(k_submodule)/k-distribution/target/release/k/lib/opam"
	opam update
	opam switch 4.03.0+k
	eval $$(opam config env) \
	opam install --yes mlgmp zarith uuidm

defn_files:=solidity.k solidity-syntax.k configuration.k mcontract.k function.k statement.k

build: 	     build-java build-ocaml
build-java:  solidity-kompiled/timestamp
build-ocaml: solidity-kompiled/interpreter

solidity-kompiled/timestamp: $(defn_files)
	kompile $< --main-module SOLIDITY --syntax-module SOLIDITY-SYNTAX --backend java

solidity-kompiled/interpreter: $(defn_files)
	eval $$(opam config env) \
	kompile --gen-ml-only -O3 --non-strict \
			--main-module SOLIDITY --syntax-module SOLIDITY-SYNTAX $< \
		&& ocamlfind opt -c solidity-kompiled/constants.ml -package gmp -package zarith \
		&& ocamlfind opt -c -I solidity-kompiled \
		&& ocamlfind opt -a -o solidity-kompiled/semantics.cmxa \
		&& ocamlfind remove solidity-semantics-plugin \
		&& ocamlfind install solidity-semantics-plugin META solidity-kompiled/semantics.cmxa solidity-kompiled/semantics.a \
		&& kompile --packages solidity-semantics-plugin -O3 --non-strict \
					 --main-module SOLIDITY --syntax-module SOLIDITY-SYNTAX $< --directory solidity-kompiled \
		&& cd solidity-kompiled \
		&& ocamlfind opt -o interpreter \
				-package gmp -package dynlink -package zarith -package str -package uuidm -package unix -package solidity-semantics-plugin \
				-linkpkg -inline 20 -nodynlink -O3 -linkall \
				constants.cmx prelude.cmx plugin.cmx parser.cmx lexer.cmx run.cmx interpreter.ml
