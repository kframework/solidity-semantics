KSolidity: Semantics of Solidity in K
=====================================

This repository presents a prototype formal semantics of [Solidity].

Installing/Building
-------------------

### K Backends

This repository generates the build-products for the Java and OCaml backends for K in `.build/defn/java/` and `.build/defn/ocaml/`.

### System Dependencies

The following are needed for building/running KSolidity:

-   [git](https://git-scm.com/)
-   [Pandoc >= 1.17](https://pandoc.org) is used to generate the `*.k` files from the `*.md` files.
-   GNU [Bison](https://www.gnu.org/software/bison/), [Flex](https://github.com/westes/flex), and [Autoconf](http://www.gnu.org/software/autoconf/).
-   GNU [libmpfr](http://www.mpfr.org/) and [libtool](https://www.gnu.org/software/libtool/).
-   Java 8 JDK (eg. [OpenJDK](http://openjdk.java.net/))
-   [Opam](https://opam.ocaml.org/doc/Install.html), **important**: Ubuntu users prior to 15.04 **must** build from source, as the Ubuntu install for 14.10 and prior is broken.
    `opam repository` also requires `rsync`.

On Ubuntu >= 15.04 (for example):

```sh
sudo apt install                                                          \
         autoconf curl flex gcc libffi-dev libmpfr-dev libtool make maven \
         opam openjdk-8-jdk pandoc pkg-config python3 python-pygments     \
         python-recommonmark python-sphinx time zlib1g-dev
```

### Building

After installing the above dependencies, make sure the submodules are setup:

```sh
git submodule update --init --recursive
```

If you haven't already setup K's OCaml dependencies more recently than February 1, 2019, then you also need to setup the K OCaml dependencies:

```sh
./.build/k/k-distribution/src/main/scripts/bin/k-configure-opam-dev
```

**NOTE**: It may prove useful to first do `rm -rf ~/.opam` if you've setup K projcets in the past and are experiencing trouble with the newest opam libraries.
          This is a fairly destructive operation, and will break any other projects that depend on specific locally installed ocaml packages.

Finally, you can install repository specific dependencies and build the semantics:

```sh
make deps
make build
```

To only build specific backends, you can do `make build-java`, `make build-ocaml`, or `make build-haskell`.

This Repository
---------------

### Semantics Layout

The following files constitute the KSolidity semantics:

-   [configuration.k](configuration.k) is the KSolidity *configuration*, or state defintion.
-   [contract.k](contract.k) defines the semantics of defining and loading contracts into the state.
-   [driver.k](driver.k) loads and runs tests from the test-set.
-   [expression.k](expression.k) defines the semantics of Solidity expressions.
-   [function.k](function.k) defines the semantics of loading functions inside a contract.
-   [solidity.k](solidity.k) is the top-level semantics file which includes all the other files.
-   [solidity-syntax.k](solidity-syntax.k) defines the syntax of the Solidity language.
-   [statement.k](statement.k) the syntax of Solidity statements inside functions.

### Example usage: `./ksol` runner script

After building the definition, you can run the definition using `./ksol`.
The most up-to-date documentation will always be in `./ksol help`.

Run the file `tests/functionCall_2.sol`:

```sh
./ksol run tests/functionCall_2.sol
```

Run the same file as a test:

```sh
./ksol test tests/functionCall_2.sol
```

You can optionally override the default backend using the `--backend BACKEND` flag:

```sh
./ksol run --backend ocaml tests/functionCall_2.sol
```

Testing
-------

The target `test` contains all the currently passing tests.

```sh
make test
```

Resources
---------

[Solidity]: <https://solidity.readthedocs.io/>
