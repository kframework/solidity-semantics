
requires "solidity-syntax.k"
requires "configuration.k"

module CONTRACT

imports SOLIDITY-SYNTAX
imports CONFIGURATION
imports KAST

rule  Ps:PragmaDirectives Cs:ContractDefinitions => Cs
rule [ContractDefinitions]:
     C:ContractDefinition Cs:ContractDefinitions => C ~> Cs

rule .ContractDefinitions => .

rule [ContractDefinition]:
     <k> contract C:Id { Cs:ContractParts } => #pcsContractParts(C,Cs) ...  </k>
     (.Bag =>
       <Contract>
	  <cname> C </cname>
	  <functions> .Bag </functions>
	  <stateVar> .List </stateVar>
          ...
       </Contract>
     )

syntax SolidityItem
       ::= #pcsContractParts(Id, ContractParts)
         | #pcsContractPart(Id, ContractPart)


rule #pcsContractParts(Ct:Id, .ContractParts) => .
rule #pcsContractParts(Ct:Id, C:ContractPart Cs:ContractParts) =>
     	   #pcsContractPart(Ct, C) ~> #pcsContractParts(Ct,Cs)

rule [StateVariableDeclaration]:
     <k> #pcsContractPart(C:Id, T:TypeName F:FunQuantifiers V:Id;) =>
     	  . ...</k>
     <Contract>
         <cname> C </cname>
         <stateVar> ... .List => ListItem(#varInfo(V, #undef_Value, T, #storage)) </stateVar>
         ...
     </Contract>

rule 
     <k> #pcsContractPart(C:Id, T:TypeName F:FunQuantifiers V:Id = E;) =>
     	  . ...</k>
     <Contract>
         <cname> C </cname>
         <stateVar> ... .List => ListItem(#varInfo(V, E, T, #storage)) </stateVar>
         ...
     </Contract>

rule [VariableDeclaration]:
    <k> T:TypeName S:StorageLocations X:Id => #allocate(C, CN, #varInfo(X:Id, #undef_Value,T:TypeName, #mem)) ~> #end_Exp ...</k>
    <currentAccount> #account(C:Int, CN:Id) </currentAccount>

rule
    <k> T:TypeName S:StorageLocations X:Id = E:Value => #allocate(C, CN, #varInfo(X:Id, E,T:TypeName, #mem)) ~> #end_Exp ...</k>
    <currentAccount> #account(C:Int, CN:Id) </currentAccount>

syntax SolidityItem
       ::= #createStateVars(Int, Id, List) 
         | #exeConstructor(Id,Int,ExpressionList) [strict(3)]

rule [New-Contract-Instance]:
     <k> new C:Id ( Es:ExpressionList )  =>  #createStateVars(N, C, SV)
                        ~> #exeConstructor(C,N,Es) ~>  N ...</k>
     <Contract>
         <cname> C </cname>
         <stateVar> SV:List </stateVar>
      ...
     </Contract>
     <numOfAccounts> N:Int => N +Int 1 </numOfAccounts>
     (.Bag =>
       <account>
	  <acctID> #account(N,C) </acctID>
	  <balance> 0 </balance>
	  <context> .Map </context>
	  <code>
		<associatedContract> .K </associatedContract>
		<availableContracts> .K </availableContracts>
	  </code>
	  <Storage> .Map </Storage>
	  <nonce> 0 </nonce>
	  ...
       </account>)

rule #createStateVars(N:Int, CN:Id, ListItem(VInfo) L:List) => #allocate(N, CN, VInfo) ~> #createStateVars(N, CN, L)

rule #createStateVars(N:Int, CN:Id, .List) => .

rule 
     <k> #exeConstructor(C:Id,N:Int,Es:Values) => functionCall(N;String2Id("constructor"); Es); ... </k>
     <Contract>
         <cname> C </cname>
         <Constructor> true </Constructor>
         ...
     </Contract>

rule 
     <k> #exeConstructor(C:Id,N:Int,Es:Values) => . ... </k>
     <Contract>
         <cname> C </cname>
         <Constructor> false </Constructor>
         ...
     </Contract>


endmodule

