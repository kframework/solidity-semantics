

requires "solidity-syntax.k"
requires "configuration.k"

module STATEMENT

imports SOLIDITY-SYNTAX
imports CONFIGURATION


rule
    <k> S:Statement Ss:Statements => #exeStmt(S) ~> Ss ... </k>

rule
    <k> .Statements => . ... </k>

rule
    <k> if (true) S:Statement => #exeStmt(S) ... </k>

rule
    <k> if (false) S:Statement => . ... </k>

rule
    <k> if (true) S:Statement else S1:Statement => #exeStmt(S) ... </k>

rule
    <k> if (false) S:Statement else S1:Statement => #exeStmt(S1) ... </k>

rule
    <k> { Ss:Statements } =>  Ss ... </k>

rule
    <k> #exeStmt(S:BlockStatement) => S ... </k>
    <callState>
        ...
        <abnormalMode> false </abnormalMode>
    </callState>

rule
    <k> _:Value ; => . ... </k>

rule
    <k> #exeStmt(S:SimpleStatement;) => S; ...</k>
    <callStack> .List </callStack>

rule
    <k> #localFunctionCall(FN:Id, ARGS:Values) => functionCall(FN; ARGS) ... </k>     [structural]

rule [While]:
    <k> while (E:Expression) S:Statement => if (E) { S #loop_mark while (E) S } ... </k>        [structural]

rule [Normal-Loop-Mark]:
    <k> #exeStmt(#loop_mark) => . ... </k>
    <callState>
        ...
        <abnormalMode> false </abnormalMode>
    </callState>

rule [Exception-Skip]:
    <k> #exeStmt(S:BlockStatement) => . ... </k>
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

rule [Exception-Return-Loop-Mark]:
    <k> (#exeStmt(#loop_mark) ~> S:WhileStatement .Statements) => . ... </k>
    <callState>
        ...
        <abnormalMode> true </abnormalMode>
        <abnormalCode> #return# </abnormalCode>
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

endmodule
