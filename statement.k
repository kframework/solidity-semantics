

requires "solidity-syntax.k"
requires "configuration.k"

module STATEMENT

imports SOLIDITY-SYNTAX
imports CONFIGURATION


syntax SolidityItem ::= "#continue#"
                       | "#break#"

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
    while (E:Expression) S:Statement => if (E) { S #loop_mark while (E) S }      [structural]

rule [Normal-Loop-Mark]:
    <k> #exeStmt(#loop_mark) => . ... </k>
    <callState>
        ...
        <exceptionMode> false </exceptionMode>
    </callState>

rule [Exception-Skip]:
    <k> S:Statement => . ... </k>
    <callState>
        ...
        <exceptionMode> true </exceptionMode>
    </callState>

rule [Exception-Continue-Loop-Mark]:
    <k> #exeStmt(#loop_mark) => . ... </k>
    <callState>
        ...
        <exceptionMode> true => false </exceptionMode>
        <exceptionCode> #continue# => .K </exceptionCode>
    </callState>

rule [Continue]:
    <k> #exeStmt(S:Continue) => . ... </k>
    <callState>
        ...
        <exceptionMode> _:Bool => true </exceptionMode>
        <exceptionCode> _ => #continue# </exceptionCode>
    </callState>

rule [Break]:
    <k> #exeStmt(S:Break) => . ... </k>
    <callState>
        ...
        <exceptionMode> _:Bool => true </exceptionMode>
        <exceptionCode> _ => #break# </exceptionCode>
    </callState>

rule [Exception-Break-Loop-Mark]:
    <k> ( #exeStmt(#loop_mark) ~> S:WhileStatement .Statements) => . ... </k>
    <callState>
        ...
        <exceptionMode> true => false </exceptionMode>
        <exceptionCode> #break# => .K </exceptionCode>
    </callState>

endmodule
