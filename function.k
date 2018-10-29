
requires "solidity-syntax.k"
requires "configuration.k"
requires "contract.k"

module FUNCTION

imports SOLIDITY-SYNTAX
imports CONFIGURATION
imports CONTRACT

syntax State
       ::= #state(ContractInstanceSig,Map,ControlFlag)
         | #state(Map,ControlFlag)

syntax ControlFlag
       ::= #return(Bool,Value)

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

rule [External-Function-Call]:
     <k> functionCall(C:Int; F:Id; Vs:Values) => #Call(F,Vs)  ~> #returnContract ...</k>
     <currentAccount> #account(C1,N1) => #account(C,N) </currentAccount>
     <env> Rho:Map => CRho </env>
     <callStack> .List => ListItem(#state(#account(C1,N1), Rho, #return(false,#undef_Value))) ... </callStack>
     <callDepth> Dep => Dep +Int 1 </callDepth>
     <account>
         <acctID> #account(C,N:Id) </acctID>
         <context> CRho:Map </context>
         ...
     </account>


rule [Internal-Function-Call]:
     <k> functionCall(F:Id; Vs:Values) => #Call(F,Vs) ~> #return ... </k>
     <env> ENV:Map  </env>
     <localCalls> .List => ListItem(#state(ENV,#return(false,#undef_Value))) ... </localCalls> 

rule 
     <k> #Call(F:Id, Vs:Values) => #BindInputParams(Ps, Vs) ~> #BindReturnParams(OPs, .Values) ~> #CallBody(Ss) ...</k>
     <currentAccount> #account(C:Int,N:Id) </currentAccount>
     <Contract>
         <cname> N:Id </cname>
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
     <k> #InitParam(T:TypeName S:StorageLocations X:Id, V) => #allocate(C:Int, #varInfo(X:Id, V:Value, T:TypeName, #mem)) ...</k>
     <currentAccount> #account(C:Int,N:Id) </currentAccount>

rule 
     <k> #InitParam(T:TypeName, V) => . ...</k>

rule [Call-Function-Body]:
     <k> #CallBody(S:Statement Ss:Statements) => #exeStmt(S) ~> #CallBody(Ss) ...</k>

rule 
     <k> #CallBody(.Statements) => . ...</k>

rule
    <k> #exeStmt(S:SimpleStatement;) => S; ...</k>
    <localCalls> ListItem(#state(_:Map,#return(false,_:Value))) ... </localCalls>

rule
     <k> #exeStmt(S:SimpleStatement;) => . ...</k>
     <localCalls> ListItem(#state(_:Map,#return(true,_:Value))) ... </localCalls>

rule
     <k> #exeStmt(S:SimpleStatement;) => S; ...</k>
     <localCalls> .List </localCalls>
     <callStack> ListItem(#state(#account(_:Int,_:Id), _:Map, #return(false,_:Value))) ... </callStack>

rule
     <k> #exeStmt(S:SimpleStatement;) => . ...</k>
     <localCalls> .List </localCalls>
     <callStack> ListItem(#state(#account(_:Int,_:Id), _:Map, #return(true,_:Value))) ... </callStack>

rule [Local-Call-Return]:
     <k> #return  => V  ... </k>
     <localCalls> ListItem(#state(Rho,#return(_:Bool,V:Value))) => .List ... </localCalls> 
     <env> _ => Rho </env>

rule [External-Call-Return]:
     <k> #returnContract => V ... </k>
     <callStack> ListItem(#state(C, Rho, #return(_:Bool,V:Value))) => .List ... </callStack>
     <env> _ => Rho </env>
     <currentAccount> _ => C  </currentAccount>
     <callDepth> Depth => Depth -Int 1 </callDepth>

rule [ReturnValue-In-ExternalCall]:
     <k> return V:Value  => #end_Exp ... </k>
     <localCalls> .List </localCalls>
     <callStack> ListItem(#state(C, Rho, #return(_:Bool => true, _:Value => V))) ... </callStack>

rule [ReturnValue-In-LocalCall]:
     <k> return V:Value  => #end_Exp ... </k>
     <localCalls> ListItem(#state(Rho,#return(_:Bool => true, _:Value => V))) ... </localCalls>

rule [Return-In-ExternalCall]:
     <k> return  => #end_Exp ... </k>
     <localCalls> .List </localCalls>
     <callStack> ListItem(#state(C, Rho, #return(_:Bool => true, _:Value))) ... </callStack>

rule [Return-In-LocalCall]:
     <k> return  => #end_Exp ... </k>
     <localCalls> ListItem(#state(Rho,#return(_:Bool => true, _:Value))) ... </localCalls>



endmodule



