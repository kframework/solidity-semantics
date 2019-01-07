
requires "solidity.k"

module DRIVER-SYNTAX

import SOLIDITY

syntax START
       ::= ContractDefinitions JSON

rule Cs:ContractDefinitions J:JSON => Cs ~> J

syntax JSONKey
       ::= String | Int

syntax JSON
       ::= String
         | JSONKey  ":" JSON
     | "{" JSONList "}"
     | "[" JSONList "]"
     | #solidity(Statements)
     | #solidity(Expression)
     | MemStatusList

syntax MemStatusList
       ::= List{MemStatus, ""} 

syntax MemStatus
       ::= #exists(String,Value)

syntax JSONList
       ::= List{JSON, ","}

syntax SolidityCommand
       ::= "#check" JSON
         | "#run" JSON        //this is the test command

syntax SolidityCommand
       ::= "#success"
         | "#failure" String

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
rule #sortJSONList(((KEY : VAL) , REST), LS)
     => #insertJSONKey((KEY : VAL), #sortJSONList(REST, LS))

syntax JSONList ::= #insertJSONKey ( JSON , JSONList )        [function]
rule #insertJSONKey( JS , .JSONList ) => JS , .JSONList
rule #insertJSONKey( (KEY : VAL) , ((KEY' : VAL') , REST) )
     => (KEY : VAL)   , (KEY' : VAL'), REST
     requires KEY <String KEY'

rule #insertJSONKey( (KEY : VAL) , ((KEY' : VAL') , REST) )
     => (KEY' : VAL') , #insertJSONKey((KEY : VAL) , REST)
     requires KEY >=String KEY'

syntax Bool ::= #isSorted ( JSONList ) [function]
 // -------------------------------------------------
rule #isSorted( .JSONList ) => true
rule #isSorted( KEY : _ )   => true
rule #isSorted( (KEY : _) , (KEY' : VAL) , REST ) =>
     KEY <=String KEY' andThenBool #isSorted((KEY' : VAL) , REST)

endmodule

module DRIVER

imports DRIVER-SYNTAX
imports SOLIDITY

rule <k> V:Value ~> #check Json:JSON => #check Json ...  </k>
     <result> _ =>  V </result>

rule <k> .SoliditySimulation  => . </k>
rule <k> SC   SCs:SoliditySimulation => SC ~> SCs </k>

rule <k> JOSNINPUT:JSON => #run JOSNINPUT ... </k>

rule #failure _ => .

/************************
    running tests
*************************/

rule <k> #run {.JSONList} => . ... </k>
rule <k> #run {TESTID : { TEST:JSONList }, TESTS}
      => #run (TESTID : {#sortJSONList(TEST)})
      ~> #run {TESTS} ...
     </k>

syntax Set ::= "#execKeys"        [function]

rule #execKeys => (SetItem("exec"))

rule #run TESTID : {KEY:(VAL:JSON), NEXT , REST:JSONList}
              => #run TESTID : { NEXT, KEY:VAL , REST}
     requires KEY in #execKeys

rule #run TESTID : {KEY:(VAL:JSON), REST:JSONList}
        => #run TESTID : { KEY:VAL }
requires KEY in #execKeys

syntax Set ::= "#postKeys"        [function]

rule #run TESTID : {KEY : VAL:JSON, REST} => #run TESTID : {REST} ~> #check TESTID : {KEY:VAL}
     requires KEY in #postKeys

rule #postKeys => (SetItem("post"))

rule <k> #load DATA : { .JSONList } => .  ... </k>
    rule <k> #load DATA : { KEY : VALUE , REST } => #load DATA : { KEY : VALUE } ~> #load DATA : { REST } ... </k>
      requires REST =/=K .JSONList andBool DATA =/=String "transaction"


rule <k> #run TESTID : { "exec" : EXEC:JSON} =>
             #load "exec" : EXEC ~> #execute ... </k>

rule <k> #load "exec" : {"code" : #solidity(EXEC:Statements), .JSONList} => . ... </k>
     <program> _ => EXEC </program>





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

rule #check TESTID : {"post" : POST} => #check "post" : POST ~> #failure TESTID

rule <k> #check "post" : {"result" : #solidity(V:Value), REST:JSONList} => #check "post" : {REST}  ... </k>
     <result> V </result>

rule <k> #check "post" : {.JSONList} => . ... </k>
     <mode> _ => "SUCCESS" </mode>

rule <k> #check "post" : {"mem" : #exists(S:String, V:Value) Ms:MemStatusList, REST:JSONList}
                 => #check "post" : {"mem" : Ms} ~> #check "post" : {REST} ... </k>
     <env> ... String2Id(S) |-> #storedVar( I:Int , _ , _)... </env>
     <localMem> ... I |-> V ... </localMem>

// This shouldn't be needed I think... But it gets stuck if removed. 
rule <k> #check "post" : {"mem" : #exists(S:String, V:Value) Ms:MemStatusList, .MemStatusList}
                 => #check "post" : {"mem" : Ms} ... </k>
     <env> ... String2Id(S) |-> #storedVar( I:Int , _ , _)... </env>
     <localMem> ... I |-> V ... </localMem>

rule #check "post" : {"mem" : .MemStatusList} => .

endmodule



