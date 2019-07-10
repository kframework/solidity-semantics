
requires "solidity-syntax.k"
requires "configuration.k"

module CONTRACT

imports SOLIDITY-SYNTAX
imports CONFIGURATION
imports COLLECTIONS

rule
    <k> Ps:PragmaDirectives Cs:ContractDefinitions => Cs ... </k>

rule [ContractDefinitions]:
    <k> C:ContractDefinition Cs:ContractDefinitions => C ~> Cs ... </k>

rule
    <k> .ContractDefinitions => . ... </k>

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
         <stateVar> ... .List => ListItem(#varInfo(V, #undef_Value, T, #storage, 1)) </stateVar>
         ...
     </Contract>

rule
     <k> #pcsContractPart(C:Id, T:TypeName F:FunQuantifiers V:Id = E;) =>
              . ...</k>
     <Contract>
         <cname> C </cname>
         <stateVar> ... .List => ListItem(#varInfo(V, E, T, #storage, 1)) </stateVar>
         ...
     </Contract>

rule [VariableDeclaration]:
    <k> T:TypeName S:StorageLocations X:Id => #allocate(C, CN, #varInfo(X:Id, #undef_Value,T:TypeName, #mem, 1)) ~> #end_Exp ...</k>
    <currentAccount> #account(C:Int, CN:AccountId) </currentAccount>

rule
    <k> T:TypeName S:StorageLocations X:Id = E:Value => #allocate(C, CN, #varInfo(X:Id, E,T:TypeName, #mem, 1)) ~> #end_Exp ...</k>
    <currentAccount> #account(C:Int, CN:AccountId) </currentAccount>

syntax SolidityItem
       ::= #createStateVars(Int, Id, List)
         | #exeConstructor(Id,Int,ExpressionList) [strict(3)]

rule [New-Contract-Instance]:
    <k> new C:Id ( Es:ExpressionList )  =>  #createStateVars(size(AA), C, SV)
                        ~> #exeConstructor(C, size(AA), Es) ~>  size(AA) ...</k>
    <Contract>
        <cname> C </cname>
        <stateVar> SV:List </stateVar>
      ...
    </Contract>
    <activeAccounts> AA:Set (.Set => SetItem(#account(size(AA), C))) </activeAccounts>
    <accounts>
    ...
    (.Bag =>
        <account>
            <acctID> size(AA) </acctID>
            <contractName> C </contractName>
            <balance> 0 </balance>
            <acctEnv> .Map </acctEnv>
            <code>
                <associatedContract> .K </associatedContract>
                <availableContracts> .K </availableContracts>
            </code>
            <acctStorage> .Map </acctStorage>
            <nonce> 0 </nonce>
            ...
        </account>
    )
    </accounts>

rule
    <k> #createStateVars(N:Int, CN:Id, ListItem(VInfo) L:List) => #allocate(N, CN, VInfo) ~> #createStateVars(N, CN, L) ... </k>

rule
    <k> #createStateVars(N:Int, CN:Id, .List) => . ... </k>

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

