
requires "solidity-syntax.k"
requires "configuration.k"
requires "contract.k"

module FUNCTION

imports SOLIDITY-SYNTAX
imports CONFIGURATION
imports CONTRACT

rule [function-definition]:
    <k> #pcsContractPart(Ct:Id, function F:Id (Ps:FParameters) FQ:FunQuantifiers returns (Rs:FParameters) {B})
            => . ... </k>
    <Contract>
        <cname> Ct </cname>
        (.Bag =>
            <Function>
            <fname> F </fname>
            <inputParams> Ps </inputParams>
            <Returns> Rs </Returns>
            <quantifiers> FQ </quantifiers>
            <visibility> .K </visibility>
            <body> B </body>
            </Function>)
         ...
    </Contract>

rule
    <k> #pcsContractPart(Ct:Id, function F:Id (Ps:FParameters) FQ:FunQuantifiers {B})
            => . ... </k>
    <Contract>
        <cname> Ct </cname>
        (.Bag =>
            <Function>
            <fname> F </fname>
            <inputParams> Ps </inputParams>
            <Returns> .FParameters </Returns>
            <quantifiers> FQ </quantifiers>
            <visibility> .K </visibility>
            <body> B </body>
            </Function>)
         ...
    </Contract>

rule
    <k> #pcsContractPart(Ct:Id, function F:Id (Ps:FParameters) FQ:FunQuantifiers returns (Rs:FParameters);)
            => . ... </k>
    <Contract>
        <cname> Ct </cname>
        (.Bag =>
            <Function>
            <fname> F </fname>
            <inputParams> Ps </inputParams>
            <Returns> Rs </Returns>
            <quantifiers> FQ </quantifiers>
            <visibility> .K </visibility>
            <body> .Statements </body>
            </Function>)
         ...
    </Contract>

rule
    <k> #pcsContractPart(Ct:Id, function F:Id (Ps:FParameters) FQ:FunQuantifiers;)
            => . ... </k>
    <Contract>
        <cname> Ct </cname>
        (.Bag =>
            <Function>
            <fname> F </fname>
            <inputParams> Ps </inputParams>
            <Returns> .FParameters </Returns>
            <quantifiers> FQ </quantifiers>
            <visibility> .K </visibility>
            <body> .Statements </body>
            </Function>)
         ...
    </Contract>

rule
    <k> #pcsContractPart(Ct:Id, constructor (Ps:FParameters) FQ:FunQuantifiers {B}) => . ... </k>
    <Contract>
        <cname> Ct </cname>
        (.Bag =>
            <Function>
            <fname> String2Id("constructor") </fname>
            <inputParams> Ps </inputParams>
            <Returns> .FParameters </Returns>
            <quantifiers> FQ   </quantifiers>
            <visibility>  .K </visibility>
            <body> B </body>
            </Function>)
         <Constructor> _ => true </Constructor>
         ...
    </Contract>

rule
    <k> #pcsContractPart(Ct:Id, function (Ps:FParameters) FQ:FunQuantifiers {B})
            => . ... </k>
    <Contract>
         <cname> Ct </cname>
         (.Bag =>
             <Function>
             <fname> String2Id("fallback") </fname>
             <inputParams> Ps </inputParams>
             <Returns> .FParameters </Returns>
             <quantifiers> FQ </quantifiers>
             <visibility> .K </visibility>
             <body> B </body>
             </Function>)
          ...
    </Contract>


syntax SolidityItem
       ::= #CallBody(Statements)
         | #Call(Id,Values)
         | #InitParams(FParameters, Values)
         | #InitParam(FParameter, Value)
         | "#return"
         | "#returnContract"
         | #BindInputParams(FParameters, Values)
         | #BindReturnParams(FParameters, Values)
         | "#pushCallStack"
         | "#popCallStack"
         | #upDateCallStateBeforeExternalCall(Int)
         | "#upDateCallStateAfterExternalCall"
         | "#upDateCallStateBeforeInternalCall"


rule [External-Function-Call]:
     <k> ( functionCall(C:Int; F:Id; Vs:Values) =>
             #pushCallStack ~>
             #upDateCallStateBeforeExternalCall(C) ~>
             #Call(F,Vs) ~>
             #upDateCallStateAfterExternalCall ~>
             #popCallStack ~>
             #returnContract
         ) ...
     </k>
     [structural]


rule [Internal-Function-Call]:
     <k> (functionCall(F:Id; Vs:Values) =>
            #pushCallStack ~>
            #upDateCallStateBeforeInternalCall ~>
            #Call(F,Vs) ~>
            #popCallStack ~>
            #return
         ) ...
     </k>
     [structural]

rule [Push-CallStack]:
     <k> #pushCallStack => . ... </k>
     <callState> CS </callState>
     <callStack> ( .List => ListItem(CS) ) ... </callStack>


rule [Pop-CallStack]:
     <k> #popCallStack => . ... </k>
     <callState> _ => CS </callState>
     <callStack> ( ListItem(CS) => .List ) ... </callStack>


rule [Update-CallStack-Before-ExternalCall]:
     <k> #upDateCallStateBeforeExternalCall(C) => . ... </k>
     <currentAccount> #account(C1,N1) => #account(C,N) </currentAccount>
     <callState>
        ...
        <caller> _ => #account(C1,N1) </caller>
        <env> Rho:Map => CRho </env>
        <callDepth> Dep => Dep +Int 1 </callDepth>
        <returnFlag> RETURNFLAG => false </returnFlag>
        <isExternalFunctionCall> EXFUNCALL => true </isExternalFunctionCall>
     </callState>
     <account>
         <acctID> #account(C,N) </acctID>
         <acctEnv> CRho:Map </acctEnv>
         ...
     </account>


rule [Update-CallStack-After-ExternalCall]:
     <k> #upDateCallStateAfterExternalCall => . ... </k>
     <currentAccount> _ => C  </currentAccount>
     <callState>
        ...
        <caller> C </caller>
     </callState>


rule [Update-CallStack-Before-InternalCall]:
     <k> #upDateCallStateBeforeInternalCall => . ... </k>
     <currentAccount> #account(C,N) </currentAccount>
     <callState>
        ...
        <caller> CALLER => #account(C,N) </caller>
        <callDepth> Dep => Dep +Int 1 </callDepth>
        <returnFlag> RETURNFLAG => false </returnFlag>
        <isExternalFunctionCall> EXFUNCALL => false </isExternalFunctionCall>
     </callState>


rule
     <k> #Call(F:Id, Vs:Values) => #BindInputParams(Ps, Vs) ~> #BindReturnParams(OPs, .Values) ~> #CallBody(Ss) ...</k>
     <currentAccount> #account(C:Int,N:AccountId) </currentAccount>
     <Contract>
         <cname> N </cname>
         <Function>
             <fname> F </fname>
             <inputParams> Ps:FParameters </inputParams>
             <Returns> OPs:FParameters </Returns>
             <body> Ss:Statements </body>
             ...
         </Function>
         ...
     </Contract>

rule
     <k> #BindInputParams(Ps, Vs) => #InitParams(Ps, Vs) ...</k>

rule
     <k> #BindReturnParams(OPs, Vs) => #InitParams(OPs, Vs) ...</k>


rule
     <k> #InitParams(P:FParameter, Ps:FParameters, V:Value,Vs:Values)
                => #InitParam(P, V) ~> #InitParams(Ps, Vs) ...</k>

rule
     <k> #InitParams(P:FParameter, Ps:FParameters, .Values)
                => #InitParam(P, #undef_Value) ~> #InitParams(Ps, .Values) ...</k>

rule
     <k> #InitParams(.FParameters, .Values) => . ...</k>

rule
     <k> #InitParam(T:TypeName S:StorageLocations X:Id, V) => #allocate(C, CN, #varInfo(X:Id, V:Value, T:TypeName, #mem)) ...</k>
     <currentAccount> #account(C:Int,CN:AccountId) </currentAccount>

rule
     <k> #InitParam(T:TypeName, V) => . ...</k>

rule [Call-Function-Body]:
     <k> #CallBody(S:Statement Ss:Statements) => #exeStmt(S) ~> #CallBody(Ss) ...</k>

rule
     <k> #CallBody(.Statements) => . ...</k>

rule
     <k> #exeStmt(S:SimpleStatement;) => S; ...</k>
     <callState>
        ...
        <returnFlag> false </returnFlag>
     </callState>


/*
rule
     <k> #exeStmt(S:SimpleStatement;) => . ...</k>
     <callState>
        ...
        <returnFlag> true </returnFlag>
     </callState>
*/

rule
     <k> #exeStmt(S:Statement) => . ...</k>
     <callState>
        ...
        <returnFlag> true </returnFlag>
     </callState>

rule [Local-Call-Return]:
     <k> #return  => V  ... </k>
     <result> V </result>

rule [External-Call-Return]:
     <k> #returnContract => V ... </k>
     <result> V </result>


rule [ReturnValue]:
     <k> return V:Value  => #end_Exp ... </k>
     <result> _ => V </result>
     <callState>
        ...
        //<abnormalMode> _:Bool => true </abnormalMode>
        //<abnormalCode> _ => #return# </abnormalCode>
        <returnFlag> _:Bool => true </returnFlag>
     </callState>

rule [Return]:
     <k> return  => #end_Exp ... </k>
     <callState>
        ...
        //<abnormalMode> _:Bool => true </abnormalMode>
        //<abnormalCode> _ => #return# </abnormalCode>
        <returnFlag> _:Bool => true </returnFlag>
     </callState>


endmodule



