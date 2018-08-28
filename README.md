# solidity-semantics

A K semantics of the Solidity programming language.

## Dependencies

[Install the K Framework from the official repository](https://github.com/kframework/k)

## Usage

### Build

```
make kompile
```

### Run all tests

```
make tests
```

This will run all test cases in the `tests` subfolders. 

### Run individual test

For example:

```
make tests/CompilerTests/for_loop_empty.sol
```

### Build and run tests

Simply...

```
make
```

### Run an arbitrary Solidity program 

```
krun --backend java myProgram.sol
```
