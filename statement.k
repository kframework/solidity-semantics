

requires "solidity-syntax.k"
requires "configuration.k"

module STATEMENT

imports SOLIDITY-SYNTAX
imports CONFIGURATION

rule S:Statement Ss:Statements => #exeStmt(S) ~> Ss
rule .Statements => .

rule if (true) S:Statement => #exeStmt(S)
rule if (false) S:Statement => .
rule if (true) S:Statement else S1:Statement => #exeStmt(S)
rule if (false) S:Statement else S1:Statement => #exeStmt(S1)

rule #exeStmt({ Ss:Statements }) =>  Ss 

rule #exeStmt(S:IfStatement) => S 

rule _:Value ; => . 

rule
    <k> #exeStmt(S) => S ...</k>
    <callStack> .List </callStack>
    <localCalls> .List </localCalls>

endmodule
