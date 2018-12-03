# K-Solidity

Semantics of Solidity in K

## Prerequisites

With the new Makefile, K is now a submodule of this project. 

In order to obtain and build K (if not done already) use: 

```
make deps
```

This should clone the k repository into `.build/k`.

## Building the K definition 

For now, only the Java backend is supported. 
To build the definition, use: 


```
make build
```

In order to clean the current build, just use

```
make clean
```

Notice that the kompiled definition is now saved in `./build/java`. 

## How to run test cases

Once the prerequisites are in place and the definition is kompiled, it is possible to run test cases. 

If you previously had a separate installation of k, notice that this is not necessary anymore, since K is now included as a submodule (if you have another installation of K you may still be able to use that, however we do not recommend it). 

This means invoking `.build/k/k-distribution/target/release/k/bin/krun` (assuming you are currently located at the root of this repo). 

We will provide a helper script soon, but for now, you can simply use: 

```
.build/k/k-distribution/target/release/k/bin/krun tests/t1.sol
```

If the test case is passed then the cell <mode/> in the configuation is success else the cell `<k/>` is stuck at some unfinished term.


## More info

For more information, please consult the `Makefile`
