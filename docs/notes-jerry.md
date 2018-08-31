Actually I think it is better to make solidity-semantics as similar to evm-semantics as possible
so that it has `<localMem>` and `<storage>` that work identically with evm-semantics.
There are several benefits:
* uniformity with evm-semantics
    * easier program equivalence checking between evm bytecode and solidity
* can support inlined assembly
* ...?
* some examples in the comments below

Below is example configuration (based on evm-semantics).  (probably not complete)
```k
    configuration
      <k> $PGM:EthereumSimulation </k>
      ...

      <ethereum>
        <solidity> // solidity virtual machine

          // Mutable during a single transaction
          // -----------------------------------

          <output>          ?  </output>
          <statusCode>      ?  </statusCode>
          <callStack>       ?  </callStack>
          <interimStates>   ?  </interimStates>
          <touchedAccounts> ?  </touchedAccounts>

          <callState>
            // desugared solidity contract: resolve modifier, inheritance, using-for ....
            // don't need to keep this in <callState>, just put it in <account>
            // <program> code </program>

            <id>        0          </id>
            <caller>    0          </caller>
            <callData>  .WordStack </callData>
            <callValue> 0          </callValue>

            // env: map from qualified name to either storage or local memory
            <env> QName |-> Reference </env>
            // QName ::= Id | Id.Id /* struct member */ | ... 
            // Reference ::= storage(Index, Offset)  // Index, Offset are Word a.k.a. uint256
            //             | memory(Index, Offset)

            // tenv: map from qualified name to type
            <tenv> QName |-> Type </tenv>
            // where Type ::= uintXX ... | array | struct(members) | ...

            // evm stack: we need this if we want full support for inlined assembly
            <wordStack>   ? </wordStack>           // \mu_s
            // memory: same as evm!!
            // exact allocation strategy may vary(unlike storage), but anyway semantics should be indentical
            <localMem>    Index |-> Word </localMem>            // \mu_m
            // evm program counter: not needed?
            <pc>          ?          </pc>                  // \mu_pc
            // gas: how?
            <gas>         ?          </gas>                 // \mu_g
            <memoryUsed>  ?          </memoryUsed>          // \mu_i
            <previousGas> ?          </previousGas>

            // not needed?
            <static>    ?     </static>
            // needed?
            <callDepth> 0     </callDepth>
          </callState>

          // A_* (execution substate)
          <substate>
            <selfDestruct> .Set  </selfDestruct>            // A_s
            <log>          .List </log>                     // A_l
            <refund>       0     </refund>                  // A_r
          </substate>

          // Immutable during a single transaction
          // -------------------------------------

          <gasPrice> 0 </gasPrice>                          // I_p
          <origin>   0 </origin>                            // I_o

          // I_H* (block information)
          // not needed, maybe
          ...
        </solidity>

        // Ethereum Network
        // ================

        <network>

          // Accounts Record
          // ---------------

          <activeAccounts> .Set </activeAccounts>
          <accounts>
            <account multiplicity="*" type="Map">
              <acctID>  0                      </acctID>
              <balance> 0                      </balance>
              // code is just collection of functions, events, ...
              //<code>    .WordStack:AccountCode </code>
              <fun>         name |-> desugared code </fun>
              <internalFun> name |-> desugared code </internalFun>
              <event>       name |-> event </event>
              // newly defined types like structs
              <types>       name |-> Type  </types>

              // this is exactly same as evm
              // Solidity has rules to allocate indices/offset(packing) to each storage
              // variable and I think these rules should be the part of Solidity semantics,
              // so that the storage usage of solidity program and evm bytecode have
              // the same effect on the storage.
              <storage> Index |-> Word  </storage>
              // Q. Why include allocation rules in solidity semantics?
              // A. 
              // * These rules are explained in the offical solidity docs
              // https://solidity.readthedocs.io/en/v0.4.24/miscellaneous.html?highlight=pack#layout-of-state-variables-in-storage
              // * AFAIK, allocation is not affected by optimization level.
              // * some contracts make use of this allocation rule to implement some nice stuff e.g.
              // https://github.com/gnosis/safe-contracts/blob/d279480b0be2562aab7dd0a751113ba8681e816e/contracts/common/MasterCopy.sol
              // https://github.com/gnosis/safe-contracts/blob/d279480b0be2562aab7dd0a751113ba8681e816e/contracts/proxies/Proxy.sol
              //

              // not needed, maybe?
              <nonce>   ?                </nonce>
            </account>
          </accounts>

          // Transactions Record
          // -------------------

          <txOrder>   .List </txOrder>
          <txPending> .List </txPending>

          // can be simplified?
          <messages>
            <message multiplicity="*" type="Map">
              <msgID>      0          </msgID>
              <txNonce>    0          </txNonce>            // T_n
              <txGasPrice> 0          </txGasPrice>         // T_p
              <txGasLimit> 0          </txGasLimit>         // T_g
              <to>         .Account   </to>                 // T_t
              <value>      0          </value>              // T_v
              <sigV>       0          </sigV>               // T_w
              <sigR>       .WordStack </sigR>               // T_r
              <sigS>       .WordStack </sigS>               // T_s
              <data>       .WordStack </data>               // T_i/T_e
            </message>
          </messages>

        </network>

      </ethereum>
```

Example rule for packed storage variable assignment
```k
    rule <k> QName = Val; => . ... </k>
         <id> AcctId </id>
         <env> QName |-> storage(Index, Offset) ... </env>
         <tenv> QName |-> Ty ... </tenv>
         <acctID> AcctId </acctID>
         <storage> Index |-> (W => #update(W, Val, Offset, #typeSize(Ty))) ... </storage>
         // representation of word example
         // W == #word([0..19] |-> Addr
         //            [20] |-> Bool ...)
```
Loop
```k
    rule while(C) B => for(;C;) B [macro]
    rule <k> for(Init Cond; Step) B => Init ~> #forInit(Cond,Step,B) ~> #setEnv(Env) ... </k>
         <env> Env </env>

    ...
```


### supporting inline assembly
* [functional style example 1](https://github.com/gnosis/safe-contracts/blob/d279480b0be2562aab7dd0a751113ba8681e816e/contracts/common/SignatureDecoder.sol#L41-L50)
* [functional style example 2](https://github.com/gnosis/safe-contracts/blob/d279480b0be2562aab7dd0a751113ba8681e816e/contracts/proxies/Proxy.sol#L26-L32)

Now that we have `<localMem>` and `<storage>` that work like that of evm, we can make the example above work as expected.
If we want to support [literal style](https://solidity.readthedocs.io/en/v0.4.24/assembly.html?highlight=assembly#literals) and stack operations,
we will need to implement evm stack which will be used only for this.


### Desugaring
Current solidity-semantics uses explicit cells for modifiers, inheritance, using-for, ... 
They can be desugared to simple contract without them just by simple transformations and parameter renaming.

### misc
* There are too many cells in configurations. `<uintSize>` is totally unnecessary. `[function]` terms are used for this kind of things.
* `gasleft()`?
* mining?

