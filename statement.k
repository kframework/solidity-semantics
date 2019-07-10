

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

syntax ContractCellMap
syntax Map ::= ContractCellMap

syntax Bool ::= Id "in_contracts" "(" ContractCellMap ")" [function, hook(MAP.in_keys)]

//**************************************************************************//
// I was planing to have the following rule for address conversion.
// However, the behavior of the in_keys() funciton is not what I expected.
// Thus, I have another work-around, which works, but may not be perfect.
// Maybe someone can help me to check on this?

/*
rule [Address-Conversion]:
    <k> #localFunctionCall(FN:Id, (V:Value, .Values)) => V ... </k>
    <contracts> CTS </contracts>
    requires (FN in_contracts(CTS))
*/

rule [Address-Conversion]:
    <k> #localFunctionCall(FN:Id, (V:Value, .Values)) => V ... </k>
    <Contract>
        <cname> FN </cname>
        ...
    </Contract>

//******************************************************************/


//**************************************************************************//
// I was planing to have the following rule for Syntactic-Sugar-Internal-Call.
// However, the behavior of the in_keys() funciton is not what I expected.
// Thus, I have another work-around, which works, but may not be perfect.
// Maybe someone can help me to check on this?

/*
rule [Syntactic-Sugar-Internal-Call]:
    <k> #localFunctionCall(FN:Id, ARGS:Values) => functionCall(FN; ARGS) ... </k>
    <contracts> CTS </contracts>
    requires notBool (FN in keys(CTS))
*/

rule [Syntactic-Sugar-Internal-Call]:
    <k> #localFunctionCall(FN:Id, ARGS:Values) => functionCall(FN; ARGS) ... </k>
    <currentAccount> #account(C:Int,N:AccountId) </currentAccount>
     <Contract>
         <cname> N </cname>
         <Function>
             <fname> FN </fname>
             ...
         </Function>
         ...
     </Contract>
//******************************************************************/


rule [Send-Fund]:
    <k> #externalFunctionCall(#memberAccess(Base:Id, FN:Id), ARGS:Values) => Base ~> "#FundSend#" ~> ARGS ... </k>
    <env> ... Base |-> #storedVar(_:Int, _:AddressPayableType, _:MemFlag, 1) ...</env>
    requires (Id2String(FN) ==String "send")

rule [Transfer-Fund]:
    <k> #externalFunctionCall(#memberAccess(Base:Id, FN:Id), ARGS:Values) => Base ~> "#TransferFund#" ~> ARGS ... </k>
    <env> ... Base |-> #storedVar(_:Int, _:AddressPayableType, _:MemFlag, 1) ...</env>
    requires (Id2String(FN) ==String "transfer")

rule [Syntactic-Sugar-External-Call-Decompose]:
    <k> #externalFunctionCall(#memberAccess(Base:Id, FN:Id), ARGS:Values) => #memberAccess(Base, FN) ~> ARGS ... </k>
    requires (notBool (Id2String(FN) ==String "send")) andBool (notBool (Id2String(FN) ==String "transfer"))

rule [Syntactic-Sugar-External-Call-Compose]:
    <k> #memberAccess(Base:Int, FN:Id) ~> ARGS:Values => functionCall(Base; FN; ARGS) ... </k>

rule [Transfer-Fund-Successful]:
    <k> Base:Int ~> "#TransferFund#" ~> V:Int, .Values => #end_Exp ... </k>
    <currentAccount> #account(CID,CNAME) </currentAccount>
    <accounts>
        <account>
            <acctID> CID </acctID>
            <balance> B => B -Int V </balance>
            ...
        </account>
        <account>
            <acctID> Base </acctID>
            <balance> B2 => B2 +Int V </balance>
            ...
        </account>
        ...
    </accounts>
    requires B >=Int V

rule [Transfer-Fund-Failed]:
    <k> Base:Int ~>  "#TransferFund#" ~> V:Int, .Values => #end_Exp ... </k>
    <currentAccount> #account(CID,CNAME) </currentAccount>
    <callState>
        ...
        <abnormalMode> _:Bool => true </abnormalMode>
        <abnormalCode> _ => #transfer-failed# </abnormalCode>
    </callState>
    <accounts>
        <account>
            <acctID> CID </acctID>
            <balance> B </balance>
            ...
        </account>
        <account>
            <acctID> Base </acctID>
            <balance> B2 </balance>
            ...
        </account>
        ...
    </accounts>
    requires B <Int V


rule [Transfer-Send-Successful]:
    <k> Base:Int ~> "#FundSend#" ~> V:Int, .Values => true ... </k>
    <currentAccount> #account(CID,CNAME) </currentAccount>
    <accounts>
        <account>
            <acctID> CID </acctID>
            <balance> B => B -Int V </balance>
            ...
        </account>
        <account>
            <acctID> Base </acctID>
            <balance> B2 => B2 +Int V </balance>
            ...
        </account>
        ...
    </accounts>
    requires B >=Int V

rule [Transfer-Send-Failed]:
    <k> Base:Int ~>  "#FundSend#" ~> V:Int, .Values => false ... </k>
    <currentAccount> #account(CID,CNAME) </currentAccount>
    <accounts>
        <account>
            <acctID> CID </acctID>
            <balance> B </balance>
            ...
        </account>
        <account>
            <acctID> Base </acctID>
            <balance> B2 </balance>
            ...
        </account>
        ...
    </accounts>
    requires B <Int V

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
