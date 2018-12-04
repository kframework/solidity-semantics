K-Solidity
==========

Semantics of Solidity in K

Prerequisites
-------------

With the new Makefile, K is now a submodule of this project.

In order to obtain and build K (if not done already) use:

```sh
make deps
```

This will clone and build the k repository into `.build/k`.

Building the K definition
-------------------------

For now, only the Java backend is supported.
To build the definition, use:

```sh
make build
```

In order to clean the current build, just use

```sh
make clean
```

Notice that the kompiled definition is now saved in `.build/java`.

How to run test programs
------------------------

Once the prerequisites are in place and the definition is kompiled, it is possible to run Solidity test cases using the supplied `./ksol` script.
For instructions on use, call:

```sh
./ksol help
```

More info
---------

For more information about building, please consult the `Makefile`.
For information about running, please consult the `ksol` script.
For a more fleshed out example of semantics, see <https://github.com/kframework/evm-semantics>.
