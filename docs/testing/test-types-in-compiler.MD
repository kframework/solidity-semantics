# What kind of tests there are in the Solidity Compiler?

See https://github.com/runtimeverification/solidity/blob/sol2iele/test/libsolidity/SolidityEndToEndTest.cpp (or the tests, in our `test` folder, which are taken from there)

Here are some samles of the kind of checks they do (indexed by a representative test name from the compiler's suite). 
We should achieve something similar...

* transaction_status

```
compileAndRun(sourceCode);
callContractFunction("f()");
BOOST_CHECK(m_transactionSuccessful);
```

* smoke_test

```
compileAndRun(sourceCode);
testContractAgainstCppOnRange("f(uint256)", [](u256 const& a) -> u256 { return a * 7; }, 0, 100);
```

* empty_contract

```
compileAndRun(sourceCode);
BOOST_CHECK(callContractFunction("i_am_not_there()", bytes()).empty());
```

* exp_zero_literal

```
compileAndRun(sourceCode);
ABI_CHECK(callContractFunction("f()", bytes()), toBigEndian(u256(1)));
```

* calling_other_functions

```
testContractAgainstCpp("run(uint256)", collatz_cpp, u256(0));
testContractAgainstCpp("run(uint256)", collatz_cpp, u256(1));
...
```

* type_conversions_cleanup

```
compileAndRun(sourceCode);
BOOST_REQUIRE(callContractFunction("test()") == bytes({0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
														   0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0x00, 0x11, 0x22,
														   0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0x00, 0x11, 0x22}));
```
}

* send_ether

```
u256 amount(130);
compileAndRun(sourceCode, amount + 1);
u160 address(23);
ABI_CHECK(callContractFunction("a(address,uint256)", address, amount), encodeArgs(1));
BOOST_CHECK_EQUAL(balanceAt(address), amount);
```

* log0

```
compileAndRun(sourceCode);
callContractFunction("a()");
BOOST_REQUIRE_EQUAL(m_logs.size(), 1);
BOOST_CHECK_EQUAL(m_logs[0].address, m_contractAddress);
BOOST_CHECK_EQUAL(h256(m_logs[0].data), h256(u256(1)));
BOOST_CHECK_EQUAL(m_logs[0].topics.size(), 0);
```