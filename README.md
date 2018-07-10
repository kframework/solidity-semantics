# solidity-semantics

A K semantics of the Solidity programming language.
More info here...

## Intro 

## How to build/run

### System Dependencies

The following are needed for building/running KSolidity:

-   GNU [Bison](https://www.gnu.org/software/bison/), [Flex](https://github.com/westes/flex), and [Autoconf](http://www.gnu.org/software/autoconf/).
-   GNU [libmpfr](http://www.mpfr.org/) and [libtool](https://www.gnu.org/software/libtool/).
-   Java 8 JDK (eg. [OpenJDK](http://openjdk.java.net/))
-   [Opam](https://opam.ocaml.org/doc/Install.html), **important**: Ubuntu users prior to 15.04 **must** build from source, as the Ubuntu install for 14.10 and prior is broken.
    `opam repository` also requires `rsync`.

On Ubuntu >= 15.04 (for example):

```sh
sudo apt-get install make gcc maven openjdk-8-jdk flex opam pkg-config libmpfr-dev autoconf libtool pandoc zlib1g-dev
```

To run proofs, you will also need [Z3](https://github.com/Z3Prover/z3) prover; on Ubuntu:

```sh
sudo apt-get install z3 libz3-dev
```

### K5

Install [K] from the official repository.

### Java Backend (slow execution and proving)

```
make build-java
```

### OCaml Backend (fast execution)

First install the needed OCaml dependencies (only need to do once).
With `$(k_installation)` set to the path where [K] is installed

```
opam init --quiet --no-setup
opam repository add k "$(k_installation)/k-distribution/target/release/k/lib/opam" \
	|| opam repository set-url k "$(k_installation)/k-distribution/target/release/k/lib/opam"
opam update
opam switch 4.03.0+k
eval $(opam config env)
opam install --yes mlgmp zarith uuidm
```

Then you can build the OCaml interpreter.

```
make build-ocaml
```

## Etc...


# Resources

[K]: <https://github.com/kframework/k>
