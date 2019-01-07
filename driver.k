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





//rule 
//    #run 
//        TESTID : 
//            {
//                KEY :(VAL:JSON), 
//                NEXT , 
//                REST:JSONList
//            }
//              
//    => 
//    
//    #run 
//        TESTID : 
//        { 
//            NEXT, 
//            KEY: VAL, 
//            REST
//        }
//     
//     requires KEY in #execKeys

rule 
    #run 
        TESTID : 
            {
                KEY :(VAL:JSON), 
                NEXT , 
                REST:JSONList
            }
              
    => 
    
    #run 
        TESTID : 
        { 
            NEXT, 
            KEY: VAL, 
            REST
        }
     requires KEY in #execKeys



rule 
    #run 
        TESTID : 
            {
                KEY :(VAL:JSON), 
                REST:JSONList
            }
              
    => 
    
    #run 
        TESTID : 
        { 
            KEY: VAL
        }
     requires KEY in #execKeys











syntax Set ::= "#postKeys"        [function]

rule 
    #run TESTID : 
        {
            KEY : VAL:JSON, 
            REST
        } 
        
        => 
        
        #run TESTID : {REST} ~> #check TESTID : {KEY:VAL}
     requires KEY in #postKeys

rule #postKeys => (SetItem("post"))


rule <k> #run TESTID : { "exec" : EXEC:JSON } =>
             #load "exec" : EXEC ~> #execute ... </k>

rule <k> #load "exec" : {"code" : #solidity(EXEC:Statements)} => . ... </k>
     <program> _ => EXEC </program>



endmodule



