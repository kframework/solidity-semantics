
requires "solidity.k"

module DRIVER-SYNTAX

import SOLIDITY

syntax START
       ::= ContractDefinitions JSON

rule Cs:ContractDefinitions J:JSON => Cs ~> J ~> #clearContracts

syntax JSONKey
       ::= String | Int
       	 | #Account(Id)

syntax JSON
       ::= String
     | JSONKey  ":" JSON
     | JSONKey  ":" Value
     | "{" JSONList "}"
     | "[" JSONList "]"
     | #solidity(Statements)
     | #solidity(Expression)
     | "#" "(" Value "," Value ")"
     | MemStatus


syntax MemStatusList
       ::= List{MemStatus, ""}

syntax MemStatus
       ::= #exists(String,Value)
         | #balance(Int)

syntax JSONList
       ::= List{JSON, ","}

syntax SolidityCommand
       ::= "#check" JSON
         | "#run" JSON        //this is the test command

syntax SolidityCommand
       ::= "#success"
         | "#failure" String
         | "#clear"
         | "#clearContracts"
         | "#initializeTestEngine"

syntax SolidityCommand
       ::= "#load" JSON

syntax SoliditySimulation
       ::= ".SoliditySimulation"
         | SolidityCommand SoliditySimulation

syntax SoliditySimulation
       ::= JSON

syntax JSONList
       ::= #sortJSONList ( JSONList )            [function]
         | #sortJSONList ( JSONList , JSONList ) [function, klabel(#sortJSONListAux)]

rule #sortJSONList(JS) => #sortJSONList(JS, .JSONList)
rule #sortJSONList(.JSONList, LS)            => LS
rule #sortJSONList(((KEY : VAL:JSON) , REST), LS)
     => #insertJSONKey((KEY : VAL), #sortJSONList(REST, LS))

syntax JSONList ::= #insertJSONKey ( JSON , JSONList )        [function]
rule #insertJSONKey( JS , .JSONList ) => JS , .JSONList
rule #insertJSONKey( (KEY : VAL:JSON) , ((KEY' : VAL':JSON) , REST) )
     => (KEY : VAL)   , (KEY' : VAL'), REST
     requires KEY <String KEY'

rule #insertJSONKey( (KEY : VAL:JSON) , ((KEY' : VAL':JSON) , REST) )
     => (KEY' : VAL') , #insertJSONKey((KEY : VAL) , REST)
     requires KEY >=String KEY'

syntax Bool ::= #isSorted ( JSONList ) [function]
 // -------------------------------------------------
rule #isSorted( .JSONList ) => true
rule #isSorted( KEY : _:JSON )   => true
rule #isSorted( (KEY : _:JSON) , (KEY' : VAL:JSON) , REST ) =>
     KEY <=String KEY' andThenBool #isSorted((KEY' : VAL) , REST)

endmodule

module DRIVER

imports DRIVER-SYNTAX
imports SOLIDITY


rule
    <k> #clear => . ... </k>
    <ethereum>
        <solidity>
            <execEngine>
                <output>          _ => .K                             </output>
                <statusCode>      _ => .K                             </statusCode>
                <callStack>       _ => .List                          </callStack>
                <interimStates>   _ => .List                          </interimStates>
                <touchedAccounts> _ => .K                             </touchedAccounts>

                <currentAccount>  _ => #account(0, #Testing-Engine#)  </currentAccount>
                <result>          _ => #undef_Value                   </result>
                <mode>            _ => .K                             </mode>

                <callState>
                    <program> _ => .K </program>
                    <id>        _ =>  0 </id>
                    <caller>    _ => .K </caller>
                    <callData>  _ => .K </callData>
                    <callValue> _ =>  0 </callValue>

                    <env>  _ => .Map </env>
                    <tenv> _ => .Map </tenv>
                    <localMem> _ => .Map </localMem>
                    <memorySlots> _ => 0 </memorySlots>

                    <gas>         _ => 0:Int </gas>
                    <memoryUsed>  _ => 0:Int </memoryUsed>
                    <previousGas> _ => 0:Int </previousGas>

                    <static>    _ => false:Bool </static>
                    <callDepth> _ => 0          </callDepth>

                    <abnormalMode>   _ =>  false:Bool      </abnormalMode>
                    <abnormalCode>   _ =>  .K              </abnormalCode>

                    <isExternalFunctionCall> false:Bool </isExternalFunctionCall>
                </callState>

                <substate>
                    <selfDestruct> _ => .Set  </selfDestruct>
                    <log>          _ => .List </log>
                    <refund>       _ => 0     </refund>
                </substate>

                <gasPrice> _ => 0 </gasPrice>
                <origin>   _ => 0 </origin>

                <block>
                    <hashes>     _ => .List </hashes>
                    <coinbase>   _ => 0     </coinbase>
                    <difficulty> _ => 0     </difficulty>
                    <number>     _ => 0     </number>
                    <gasLimit>   _ => 0     </gasLimit>
                    <timestamp>  _ => 0     </timestamp>
                </block>
            </execEngine>

            ...
        </solidity>

        <network>
            <activeAccounts> _ => .Set </activeAccounts>

            <accounts>
                _ => .Bag
            </accounts>

            <txOrder>   _ => .List </txOrder>
            <txPending> _ => .List </txPending>

            <messages>
                _ => .Bag
            </messages>
        </network>
    </ethereum>

rule <k> #clearContracts => . ... </k>
     <contracts>
       _ => .Bag
     </contracts>

rule <k> V:ValueResult ~> #check Json:JSON => #check Json ...  </k>
     <result> _ =>  V </result>

rule <k> .SoliditySimulation  => . </k>
rule <k> SC   SCs:SoliditySimulation => SC ~> SCs </k>

rule <k> JOSNINPUT:JSON => #run JOSNINPUT ... </k>

/************************
    running tests
*************************/

rule <k> #run {.JSONList} => . ... </k>
rule <k> #run {TESTID : { TEST:JSONList }, TESTS}
      => #run (TESTID : {#sortJSONList(TEST)})
      ~> #run {TESTS} ...
     </k>

// This rule is used to deploy the #Testing-Engine# constract (with initial balance 10000)
// Because we may need to transfer money to contracts to be tested
rule [Initialize-Test-Engine]:
    <k> #initializeTestEngine => . ... </k>
    <activeAccounts> AA:Set (.Set => SetItem(#account(size(AA), #Testing-Engine#))) </activeAccounts>
    <accounts>
    ...
    (.Bag =>
        <account>
            <acctID> size(AA) </acctID>
            <contractName> #Testing-Engine# </contractName>
            <balance> 10000 </balance>
            <acctEnv> .Map </acctEnv>
            <code>
                <associatedContract> .K </associatedContract>
                <availableContracts> .K </availableContracts>
            </code>
            <acctStorage> .Map </acctStorage>
            <nonce> 0 </nonce>
            ...
        </account>
    )
    </accounts>

rule <k> #run TESTID : { "exec" : EXEC:JSON , "post" : POST:JSON , "pre" : PRE:JSON , .JSONList }
      => #initializeTestEngine
      ~> #load  "pre"  : PRE
      ~> #load  "exec" : EXEC
      ~> #execute
      ~> #check "post" : POST
      ~> #failure TESTID
     ...
     </k>

rule <k> #run TESTID : { "exec" : EXEC:JSON , "post" : POST:JSON , .JSONList }
      => #initializeTestEngine
      ~> #load  "exec" : EXEC
      ~> #execute
      ~> #check "post" : POST
      ~> #failure TESTID
     ...
     </k>


rule <k> #load "exec" : {"code" : #solidity(EXEC:Statements), .JSONList} => . ... </k>
     <program> _ => EXEC </program>

rule <k> #load "pre" : {"block.number": N:Int, JS:JSONList} => #load "pre" : {JS} ... </k>
     <number> _ => N </number>

rule <k> #load "pre" : {"block.timestamp": N:Int, JS:JSONList} => #load "pre" : {JS} ... </k>
     <timestamp> _ => N </timestamp>


rule <k> #load "pre" : {"msg.sender": #(A,N), JS:JSONList} => #load "pre" : {JS} ... </k>

rule <k> #load "pre" : {.JSONList} => . ... </k>



/******************************
    For parse
*******************************/

syntax Int ::= #parseAddr ( String ) [function]

// -----------------------------------------------
rule #parseAddr(S) => #addr(#parseHexWord(S))

syntax Int ::= #addr ( Int ) [function]
 // ---------------------------------------
rule #addr(W) => W %Word pow160


    syntax Int ::= "pow256" /* 2 ^Int 256 */
                 | "pow255" /* 2 ^Int 255 */
                 | "pow160" /* 2 ^Int 160 */
                 | "pow16"  /* 2 ^Int 16  */
 // ----------------------------------------

rule pow256 => 115792089237316195423570985008687907853269984665640564039457584007913129639936 [macro]
rule pow255 => 57896044618658097711785492504343953926634992332820282019728792003956564819968  [macro]
rule pow160 => 1461501637330902918203684832716283019655932542976 [macro]
rule pow16  => 65536 [macro]

syntax Int ::= Int "+Word" Int [function]
                 | Int "*Word" Int [function]
                 | Int "-Word" Int [function]
                 | Int "/Word" Int [function]
                 | Int "%Word" Int [function]
 // -----------------------------------------
    rule W0 +Word W1 => chop( W0 +Int W1 )
    rule W0 -Word W1 => chop( W0 -Int W1 ) requires W0 >=Int W1
    rule W0 -Word W1 => chop( (W0 +Int pow256) -Int W1 ) requires W0 <Int W1
    rule W0 *Word W1 => chop( W0 *Int W1 )
    rule W0 /Word W1 => 0                    requires W1  ==Int 0
    rule W0 /Word W1 => chop( W0 /Int W1 )   requires W1 =/=Int 0
    rule W0 %Word W1 => 0                    requires W1  ==Int 0
    rule W0 %Word W1 => chop( W0 modInt W1 ) requires W1 =/=Int 0

 syntax Int ::= chop ( Int ) [function, smtlib(chop)]
 // ----------------------------------------------------
    rule chop ( I:Int ) => I modInt pow256 [concrete, smt-lemma]


syntax Int ::= #parseHexWord ( String ) [function]
             | #parseWord    ( String ) [function]
 // --------------------------------------------------
    rule #parseHexWord("")   => 0
    rule #parseHexWord("0x") => 0
    rule #parseHexWord(S)    => String2Base(replaceAll(S, "0x", ""), 16) requires (S =/=String "") andBool (S =/=String "0x")

    rule #parseWord("") => 0
    rule #parseWord(S)  => #parseHexWord(S) requires lengthString(S) >=Int 2 andBool substrString(S, 0 , 2) ==String "0x"
    rule #parseWord(S)  => String2Int(S) [owise]


// -----  Rules for check --------

rule <k> #failure _ => #clear ... </k>
     <mode> _ => "SUCCESS" </mode>

rule <k> #check "post" : {.JSONList} => . ... </k>

rule <k> #check "post" : { K1 : V1:JSON , REST }
     	 	=> #check "post" : { (K1 : V1) } ~> #check "post" : { REST } ... </k>


rule <k> #check "post" : {"result" : #solidity(V:ValueResult) } => . ... </k>
     <result> V </result>


rule <k> #check "post" : { "mem" : { .JSONList} } => . ... </k>



rule <k> #check "post" : { "mem" : { MS, MSL } }
     	 => #check "post" : { "mem" : MS } ~> #check "post" : { "mem" : { MSL } } ... </k>



rule <k> #check "post" : { ("mem" : #exists(S:String, V:Value)) } => . ... </k>
     <env> ... String2Id(S) |-> #storedVar( I:Int , _ , _, _, _, _)... </env>
     <localMem> ... I |-> V ... </localMem>

//rule <k> #check "post" : { "mem" : .MemStatusList } => . ... </k>
//rule <k> #check "post" : { "mem" : MS MSL } => #check "post" : { "mem" : MS } ~> #check "post" : { "mem" : MSL } ... </k>
//rule <k> #check "post" : { "mem" : #exists(S:String, V:Value) } => . ... </k>
//     <env> ... String2Id(S) |-> #storedVar( I:Int , _ , _, _, _, _)... </env>
//     <localMem> ... I |-> V ... </localMem>

rule #check "post" : { (#Account(ADD:Id) : {M, Ms}) } =>
     	    #check "post" : {(#Account(ADD) : M)} ~> #check "post" : {#Account(ADD) : { Ms }}


rule <k> #check "post" : { (#Account(_) : { .JSONList}) } => . ... </k>

rule <k> #check "post" : { (#Account(ADD:Id) : #exists(S:String, V:Value)) } => . ... </k>
     <env> ... ADD |-> #storedVar(I:Int, _ , _, _, _, _) ... </env>
     <localMem> ... I |-> Addr ... </localMem>
     <acctID> Addr </acctID>
     <acctEnv> ... String2Id(S) |-> #storedVar(Loc:Int,_,_, _, _, _) ... </acctEnv>
     <acctStorage> ... Loc |-> V ... </acctStorage>


rule <k> #check "post" : { (#Account(ADD:Id) : #balance(V:Int) )} => . ... </k>
     <env> ... ADD |-> #storedVar(I:Int, _ , _, _, _, _) ... </env>
     <localMem> ... I |-> Addr ... </localMem>
     <acctID> Addr </acctID>
     <balance> V </balance>

rule #check "post" : { .JSONList } => .


endmodule
