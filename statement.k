

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

rule #exeStmt(S:WhileStatement) => S


rule _:Value ; => .

rule
    <k> #exeStmt(S:SimpleStatement;) => S; ...</k>
    <callStack> .List </callStack>

rule
    #localFunctionCall(FN:Id, ARGS:Values) => functionCall(FN; ARGS)      [structural]

rule [While]:
    <k> while (E:Expression) S:Statement => if (E) { S #loop_mark while (E) S } ... </k>        [structural]

rule [Normal-Loop-Mark]:
    <k> #exeStmt(#loop_mark) => . ... </k>
    <callState>
        ...
        <abnormalMode> false </abnormalMode>
    </callState>

rule [Exception-Skip]:
    <k> S:Statement => . ... </k>
    <callState>
        ...
        <abnormalMode> true </abnormalMode>
    </callState>

rule [Exception-Continue-Loop-Mark]:
    <k> #exeStmt(#loop_mark) => . ... </k>
    <callState>
        ...
        <abnormalMode> true => false </abnormalMode>
        <abnormalCode> #continue# => .K </abnormalCode>
    </callState>

rule [Continue]:
    <k> #exeStmt(S:Continue) => . ... </k>
    <callState>
        ...
        <abnormalMode> _:Bool => true </abnormalMode>
        <abnormalCode> _ => #continue# </abnormalCode>
    </callState>

rule [Break]:
    <k> #exeStmt(S:Break) => . ... </k>
    <callState>
        ...
        <abnormalMode> _:Bool => true </abnormalMode>
        <abnormalCode> _ => #break# </abnormalCode>
    </callState>

rule [Exception-Break-Loop-Mark]:
    <k> ( #exeStmt(#loop_mark) ~> S:WhileStatement .Statements) => . ... </k>
    <callState>
        ...
        <abnormalMode> true => false </abnormalMode>
        <abnormalCode> #break# => .K </abnormalCode>
    </callState>

/*
rule [Exception-Return-Loop-Mark]:
    <k> ( #exeStmt(#loop_mark) ~> S:WhileStatement .Statements) => . ... </k>
    <callState>
        ...
        <abnormalMode> true </abnormalMode>
        <abnormalCode> #return# </abnormalCode>
    </callState>
*/

endmodule
