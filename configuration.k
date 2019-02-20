
module CONFIGURATION

imports SOLIDITY-SYNTAX


syntax START


configuration
    <k> $PGM:START </k>
    <exit-code exit=""> 0 </exit-code>
    // ...

    <ethereum>

        // Solidity execution engine
        // =========================

        <solidity>

            // Mutable during a single transaction
            // -----------------------------------

            <execEngine>
                <output>          .K                             </output>
                <statusCode>      .K                             </statusCode>
                <callStack>       .List                          </callStack>
                <interimStates>   .List                          </interimStates>
                <touchedAccounts> .K                             </touchedAccounts>
                <currentAccount>  #account(-1, #Testing-Engine#) </currentAccount>
                <result>          .K                             </result>
                <mode>            .K                             </mode>

                <callState>

                    // Should be loaded from <account>
                    <program> .K </program>              // currently running <contract>

                    // I_*
                    <id>         0 </id>        // Currently executing contract
                    <caller>    .K </caller>    // Contract that called current contract
                    <callData>  .K </callData>  // .WordStack Copy of register arguments (?)
                    <callValue>  0 </callValue> // Value in funds passed to contract

                    // \mu_*
                    // env: map from qualified name to either storage or local memory
                    // QName ::= Id | Id.Id /* struct member */ | ...
                    // Reference ::= storage(Index, Offset)  // Index, Offset are Word a.k.a. uint256
                    //             | memory(Index, Offset)
                    <env> .Map </env>     // Map of names to references

                    // tenv: map from qualified name to type
                    // where Type ::= uintXX ... | array | struct(members) | ...
                    <tenv> .Map </tenv>         // Map names to types

                    // memory: same as evm!!
                    // exact allocation strategy may vary(unlike storage), but anyway semantics should be indentical
                    <localMem> .Map </localMem>

                    // Gas: not sure how, but I think we need it.
                    <gas>         0:Int </gas>
                    <memoryUsed>  0:Int </memoryUsed>
                    <previousGas> 0:Int </previousGas>

                    // Those are present in both KEVM and IELE.
                    // Not sure we need them, let's keep them around until figure it out.
                    <static>    false:Bool </static>
                    <callDepth> 0          </callDepth>

                    // <abnormalMode> and <abnormalCode> are used to handle abnormal terminations
                    // E.g., the "break" and "continue" statements
                    // The abnormalCode could be: #continue#, #break#, #return#, etc. (defined in solidity-syntax.k)
                    <abnormalMode>     false:Bool      </abnormalMode>
                    <abnormalCode>     .K              </abnormalCode>

                    <returnFlag>        false:Bool      </returnFlag>
                    <isExternalFunctionCall> false:Bool </isExternalFunctionCall>
                </callState>

                // A_* (execution substate)
                // (same as KEVM/IELE)
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
                // Needed or not? It is part of KEEI, but not sure. Should discuss.
                <block>
                    <hashes>     .List      </hashes>
                    <coinbase>   0          </coinbase>   // H_c
                    // <logsBloom>  .WordStack </logsBloom>  // H_b
                    <difficulty> 0          </difficulty> // H_d
                    <number>     0          </number>     // H_i
                    <gasLimit>   0          </gasLimit>   // H_l
                    <timestamp>  0          </timestamp>  // H_s
                </block>
            </execEngine>

            // This is the part of the "Solidity VM" where we keep the available contracts.
            // Those are either obtained from source file (creation) or loaded from accounts (function call).

            // When we parse Solidity source file we
            //   - desugar/preprocess modifiers, inheritance (?) etc.
            //   - create one <contract> structure for each contract declared in the sources
            // (let's not worry about those for now, and just stick to simple functions)

            // From here, <contract>s can be either deployed or executed.
            // When a contract is deployed we not only copy its <contract> cell into the <account>,
            // but we also copy the other contracts that were present in the same source file,
            // so that the deployed contract have access to them and can create and deploy them if needed.
            // (see the <account> cell below for more notes about this)

            <contracts>
                <Contract multiplicity = "*" type="Map">
                    <cname> .K </cname>

                    <functions>
                        <Function multiplicity="*" type="Map">
                            <fname>       .K </fname>
                            <inputParams> .K </inputParams>
                            <Returns>     .K </Returns>
                            <quantifiers> .K </quantifiers>
                            <visibility>  .K </visibility> // Visibility ::= public | privat
                            <body>        .K </body>
                        </Function>
                    </functions>

                    <stateVar> .List </stateVar>
                    <Constructor> false </Constructor>
                    // ... more to be added later ...

                </Contract>
            </contracts>

        </solidity>

        // Ethereum Network
        // ==========================

        <network>

            // Accounts Record
            // ---------------

            <activeAccounts> .Set </activeAccounts>

            // removed becuase we can get this number by size(activeAccounts).
            //<numOfAccounts> 0:Int </numOfAccounts>

            <accounts>
                <account multiplicity="*" type="Map">

                    // Same as in KEVM / IELE

                    <acctID> 0 </acctID>
                    <contractName> #Testing-Engine# </contractName>
                    <balance>  0 </balance>

                    // The <acctEnv> cell refers to the environment, mapping variable names to logical
                    // storage references. Actually, <acctEnv> is equivalent to the <env> cell in <execEngine>.

                    <acctEnv> .Map </acctEnv>

                    // When a contract is deployed, its <contract> data structure will be copied here.
                    // Because contracts can create other contracts (via "new") we need to also keep the
                    // set of contract that this contract can create (i.e. the set of contracts that was
                    // available at creation time, like in IELE)

                    <code>
                        <associatedContract> .K </associatedContract>    // contract deployed on this account
                        <availableContracts> .K </availableContracts>    // contracts that can be created by this account's contract
                    </code>

                    // [Jerry's notes about storage]:
                    // this is exactly same as evm
                    // Solidity has rules to allocate indices/offset(packing) to each storage
                    // variable and I think these rules should be the part of Solidity semantics,
                    // so that the storage usage of solidity program and evm bytecode have
                    // the same effect on the storage.

                    <acctStorage> .Map </acctStorage>

                    // Q. Why include allocation rules in solidity semantics?
                    // A.
                    // * These rules are explained in the offical solidity docs
                    // https://solidity.readthedocs.io/en/v0.4.24/miscellaneous.html?highlight=pack#layout-of-state-variables-in-storage
                    // * AFAIK, allocation is not affected by optimization level.
                    // * some contracts make use of this allocation rule to implement some nice stuff e.g.
                    // https://github.com/gnosis/safe-contracts/blob/d279480b0be2562aab7dd0a751113ba8681e816e/contracts/common/MasterCopy.sol
                    // https://github.com/gnosis/safe-contracts/blob/d279480b0be2562aab7dd0a751113ba8681e816e/contracts/proxies/Proxy.sol
                    //

                    <nonce> 0:Int </nonce>

                </account>
            </accounts>

            // Transactions Record
            // -------------------

            <txOrder>   .List </txOrder>
            <txPending> .List </txPending>

            // Borrowed from IELE. Notice this is more high level than KEVM
            // May need further tweaks, but that's the idea.

            <messages>
                <message multiplicity="*">
                <msgID>       0 </msgID>      // Unique ID of transaction
                <txNonce>     0 </txNonce>    // Nonce of transaction (not checked)
                <txGasPrice>  0 </txGasPrice> // Gas price of transaction
                <txGasLimit>  0 </txGasLimit> // Gas limit of transaction
                <sendto>     .K </sendto>     // Destination of transaction (.Account for account creation)
                <func>       .K </func>       // Function to call by transaction
                <value>       0 </value>      // Value in funds to transfer by transaction
                <from>        0 </from>       // Sender of transaction
                <data>       .K </data>       // .WordStack Arguments to function called by transaction
                <args>       .K </args>       //.Ints
                </message>
            </messages>

        </network>

    </ethereum>

endmodule
