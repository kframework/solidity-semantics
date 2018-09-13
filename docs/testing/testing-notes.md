# Thoughts about testing

## Goal

* to create a nice Solidity test suite to validate the semantics

## Starting points

* a good place to start are the tests from the Solidity Compiler
   * can't be used exactly as they are (because they are embedded in C++ code)
* we can also add more tests (not necessarily limit ourselves to the compiler tests), but let's start with ones from the compiler

## Nice to have features

* keep the test suite as much "tool agnostic" as possible, so that other people can use it for other project; if we succeed in this, test suite can go in separate repo for people to use. 


## Initial attempt

As a starting point, we can use the `ktest` scripts (included in K5) that provides some basic functionality for running tests and checking against an expected result.

In order to keep the tests more general and not too tied to our K implementation, we should avoid requiring the inspection of specific cells (or combination of cells); this would obviously give us maximum "power" and granularity, but also makes the tests only usables by us. 

Instead, we may want to only check for specific "output". How do we obtain such output? We can add a set of auxiliary/helper commands to the semantics, to be used for testing (not accessible to regulr users) e.g.:
    
* `logValue(123) // prints 123 on stdout`
* `logValue(functionCall(...)) // prints result of function call`

(in conjunction with an auxiliary cell in the configuration, that keeps such a log)

### Example

This is what a test could look like.

`test.sol`:

```
// This is the actual contract from the Solidity test suite
contract Test {

    int foo = 123;

    function f(uint n) returns(uint nfac) {
        nfac = 1;
        var i = 2;
        do { nfac *= i++; } while (i <= n);
    }
}

// And this is added by us, in order to test the contract
contract main 
{
    function main() { 
        new Test();   
        logValue(functionCall(-1; 0; f; 4; msginfo(-1,0,2,2)));
        logValue(functionCall(-1; 0; f; 5; msginfo(-1,0,2,2)));
        logValue(functionCall(-1; 0; f; 6; msginfo(-1,0,2,2)));
    }
}
```

`test.sol.out`:

```
24
120
720
```

And then run it with 
```
make test.sol
```

or run all the tests with 

```
make krun
```

This, while very simple, already works and can be useful as a starting point.

### How to improve? Next steps?

Consider the example again. 

The second part, 

```
contract main 
{
    function main() { 
        new Test();   
        logValue(functionCall(-1; 0; f; 4; msginfo(-1,0,2,2)));
        logValue(functionCall(-1; 0; f; 5; msginfo(-1,0,2,2)));
        logValue(functionCall(-1; 0; f; 6; msginfo(-1,0,2,2)));
    }
}
```

is actually not part of the original compiler test, but something added by us in order to make function calls and log the results. 

If we really want to release the test suite as a separate project, this could get in the way (although, honestly, there is nothing wrong if we keep it this way - the compiler test suite has something equivalent, in the form of C++ calls). 

Given that this is boilerplate code, can we automate it? 
Can introduce an extra file, say

`test.in`

```
function: f
input: 4
expected: 24

function: f
input: 5
expected: 120

function: f
input: 6
expected: 720

```

and then have our script generate the boilerplate:

```
contract main 
{
    function main() { 
        new Test();   
        logValue(functionCall(-1; 0; f; 4; msginfo(-1,0,2,2)));
        logValue(functionCall(-1; 0; f; 5; msginfo(-1,0,2,2)));
        logValue(functionCall(-1; 0; f; 6; msginfo(-1,0,2,2)));
    }
}
``` 

as well as the `test.out`?

If we do something like this, then out tests will simply look like this:

`test.sol`:

```
contract Test {

    int foo = 123;

    function f(uint n) returns(uint nfac) {
        nfac = 1;
        var i = 2;
        do { nfac *= i++; } while (i <= n);
    }
}
```

`test.in`:

```
function: f
input: 4
expected: 24

function: f
input: 5
expected: 120

function: f
input: 6
expected: 720
```

which makes them perfectly general and usable in other projects.

## Suggestions from Everett

If you want a more generic way of doing tests, you might consider "building them in", for instance, have your main look something like this (forgive the non-solidity psuedo-code):

```
main() {
   return call1() == result1 && call2() == result2 && call3() == result3;
}
```

This will let you test multiple things at once, and now you only need to check "does it return True or False" as the test result, which is fairly easy to adapt to other test frameworks as well.

### Pros

* simple to check (only `true`/`false`)

### Cons

* when a test fail, we don't know which of the multiple calls failed, we need to check manually
