requires "solidity-syntax.k"
requires "configuration.k"

module MCONTRACT

imports SOLIDITY-SYNTAX
imports CONFIGURATION

/**********************************@
	     Contract
***********************************/

rule 
  <k> contract F:Id is I:Identifiers { Cs:ContractParts } => contract F:Id { Cs:ContractParts } ... </k>

rule 
  <k> contract F:Id { Cs:ContractParts } =>  pcsContractParts(F,Cs) ... </k>
  <contractnum> N:Int => N +Int 1 </contractnum>
  (.Bag =>
    <Contract> 
      <cname> F </cname>
      <cId> N </cId>
      //<variables> .Map </variables>
      <typeName> .Map </typeName>
      <cstore> .Map </cstore>
      <dtype> .Map </dtype>
      <dstore> .Map </dstore>
      <Length> .Map </Length>
      // <contractBody> Cs </contractBody>
      <events> .Bag </events>
      <modifiers> .Bag </modifiers>
      <usingfors> .Bag </usingfors>
      <structs> .Bag </structs>
      //<arrays> .Bag </arrays>
      <newInstances> .List </newInstances>
      <constructor> 0 </constructor>
      ...
    </Contract>)

rule 
  <k> library F:Id { Cs:ContractParts } =>  pcsContractParts(F,Cs) ... </k>
  <contractnum> N:Int => N +Int 1 </contractnum>
  (.Bag =>
    <Contract> 
      <cname> F </cname>
      <cId> N </cId>
      <variables> .Map </variables>
      <typeName> .Map </typeName>
      <cstore> .Map </cstore>
      <dtype> .Map </dtype>
      <dstore> .Map </dstore>
      <Length> .Map </Length>
      // <contractBody> Cs </contractBody>
      <events> .Bag </events>
      <modifiers> .Bag </modifiers>
      <usingfors> .Bag </usingfors>
      <structs> .Bag </structs>
      <arrays> .Bag </arrays>
      <newInstances> .List </newInstances>
      <constructor> 0 </constructor>
      ...
    </Contract>)

//ContractPart

rule pcsContractParts(F, C:ContractPart Cs:ContractParts) => pcsContractPart(F,C) ~> pcsContractParts(F,Cs)
rule pcsContractParts(F,.ContractParts) => .

//StateVariableDeclaration for global variables 
    
//ElementaryTypeName 

rule 
  <k> pcsContractPart(C:Id, X:NotBool Y:FunQuantifiers Z:Id;) => allocate(C,X,String2Id("Global"),Z,0) ... </k>

rule 
  <k> allocate(C,X:ElementaryTypeName, Y:Id, Z:Id, I:Expression) => . ... </k>
  <Contract>
    <cname> C </cname>
    <vnum>  N:Int => N +Int 1 </vnum>
    <vId> (.Map => N |-> Z) ... </vId>
    <variables> ( .Map => Z |-> !Num:Int) ... </variables>
    <typeName> ( .Map => Z |-> X) ... </typeName>
    <cstore> (.Map => !Num |-> I) ... </cstore>
    <cLocation> ( .Map => Z |-> Y) ... </cLocation>
    ...
  </Contract>
     
rule 
    <k> pcsContractPart(C:Id, X:ElementaryTypeName Y:FunQuantifiers Z:Id = E;) => allocate(C,X,String2Id("Global"),Z,E) ... </k>
    
rule 
    <k> pcsContractPart(C:Id, X:SBool Y:FunQuantifiers Z:Id;) => allocate(C,X,String2Id("Global"),Z,false) ... </k>
    
//Array(Global)

//One dimensional array

rule 
    <k> allocate(C:Id, T:ElementaryTypeName[I:Int], Y:Id, Z:Id, V:Value) => NewArray(C,Z,0,I,V) ~> SetSize(C,Z) ... </k>
    <Contract>
        <cname> C </cname>
        <vnum>  N:Int => N +Int 1 </vnum>
        <vId> (.Map => N |-> Z) ... </vId>
        <variables> ( .Map => Z |-> !Num:Int) ... </variables>
        <typeName> ( .Map => Z |-> T) ... </typeName>
        <cstore> (.Map => !Num |-> !Num +Int 1) ... </cstore>
        <cLocation> ( .Map => Z |-> Y) ... </cLocation>
        <Length> (.Map => Z |-> I) ... </Length>
        <vdim> (.Map => Z |-> 1) ... </vdim>
        (.Bag =>
            <array>
                <aname> Z </aname>
                <dimensions> 1 |-> I </dimensions>
                ...
            </array>
        )
        ...
    </Contract>

rule 
    <k> pcsContractPart(C:Id, T:ElementaryTypeName[I:Int] Y:FunQuantifiers Z:Id;) => allocate(C,T[I],String2Id("Global"),Z,0) ... </k>
           
rule 
    <k> SetSize(C,Z) => CntSize(C,Z,DNum,0) ... </k>
    <Contract>
        <cname> C </cname>
        <variables> ... Z |-> E ... </variables>
        <cstore> ... E |-> (A:Int=>1) ... </cstore>
        <baseAddress> (.Map => Z |-> A:Int) ... </baseAddress>
        <array>
            <aname> Z </aname>
            <dnum> DNum </dnum>
            ...
        </array>
        ...
    </Contract>

rule 
    <k> CntSize(C,Z,DNum,N) => DSize(C,Z,N) ~> CntSize(C,Z,DNum,N +Int 1) ... </k>
    requires N<Int DNum

rule 
    <k> CntSize(C,Z,DNum,DNum) => . ... </k>

rule 
    <k> DSize(C,Z,N) => . ... </k>
    <Contract>
        <cname> C </cname>
        <variables> ... Z |-> E ... </variables>
        <cstore> ... E |-> (A=> A*Int I) ... </cstore>
        <array>
            <aname> Z </aname>
            <dimensions> ... N+Int 1 |-> I ... </dimensions>
            ...
        </array>
        ...
    </Contract>

rule 
    <k> allocate(C:Id, T:ElementaryTypeName[ ], Y:Id, Z:Id, V:Value) => . ... </k>    
    <Contract>
        <cname> C </cname>
        <vnum>  N:Int => N +Int 1 </vnum>
        <vId> (.Map => N |-> Z) ... </vId>
        <variables> ( .Map => Z |-> !Num:Int) ... </variables>
        <typeName> ( .Map => Z |-> T) ... </typeName>
        <dtype> (.Map => Z |-> T) ... </dtype>
        <cstore> (.Map => !Num:Int |-> V) ... </cstore>
        <cLocation> ( .Map => Z |-> Y) ... </cLocation>
        <Length> (.Map => Z |-> 0) ... </Length>
        <vdim> (.Map => Z |-> 0) ... </vdim>
        ...
    </Contract>   

rule 
    <k> pcsContractPart(C:Id, T:ElementaryTypeName[] Y:FunQuantifiers Z:Id;) => allocate(C,T,String2Id("Global"),Z,0) ... </k>

//Multi-dimensional array

rule 
    <k> allocate(C:Id, T:ArrayTypeName[I:Int], Y:Id, Z:Id, V:Value) => MulDArray(C,T,Z,0,I,V) ~>  SetSize(C,Z) ... </k>
    <Contract>
        <cname> C </cname>
        <vnum>  N:Int => N +Int 1 </vnum>
        <vId> (.Map => N |-> Z) ... </vId>
        <variables> ( .Map => Z |-> !Num:Int) ... </variables>
        <typeName> ( .Map => Z |-> T) ... </typeName>
        <cstore> (.Map => !Num:Int |-> !Num +Int 1) ... </cstore>
        <cLocation> ( .Map => Z |-> Y) ... </cLocation>
        <Length> (.Map => T Z|-> I) ... </Length>
        <dim> _=>1 </dim>
        <vdim> (.Map => Z |-> 1) ... </vdim>
        (.Bag =>
            <array>
                <aname> Z </aname>
                <dimensions>  1 |-> I </dimensions>
                ...
            </array>
        )
        ...
    </Contract>

rule 
    <k> pcsContractPart(C:Id, T:ArrayTypeName[I:Int] Y:FunQuantifiers Z:Id;) => allocate(C,T[I],String2Id("Global"),Z,0) ... </k>

rule
    <k> pcsContractPart(C:Id, T:ArrayTypeName[] Y:FunQuantifiers Z:Id;) => pcsContractPart(C:Id, T:ArrayTypeName Y:FunQuantifiers Z:Id;) ... </k>

rule    
    <k> MulDArray(C,T,Z,N,I,V) => ODArray(C,T,Z,N,I,V) ~> MulDArray(C,T,Z,N+Int 1,I,V)... </k>
    requires N<Int I
    
rule 
    <k> MulDArray(C,T,Z,I,I,V) => . ... </k>
       
rule 
    <k> ODArray(C,T:ArrayTypeName[Ins],Z,N,I,V) => CntLength(C,Z,T,Ins)~>MulDArray(C,T,Z,0,Ins,V) ... </k>

rule 
    <k> ODArray(C,T:ElementaryTypeName[Ins],Z,N,I,V) => cntLength(C,Z,Ins)~> NewArray(C,Z,0,Ins,V) ... </k>

rule 
    <k> CntLength(C,Z,T:TypeName,Ins) => . ... </k>
    <Contract>
        <cname> C </cname>
        <Length> ... T Z|-> (_=>Ins) ... </Length>
        ...
    </Contract>

rule 
    <k> CntLength(C,Z,T:TypeName,Ins)=> . ... </k>
    <Contract>
        <cname> C </cname>
        <Length> (.Map => T Z|-> Ins) ... </Length>
        <dim> N:Int => N +Int 1 </dim>
        <vdim> ... Z |-> (_=>N+Int 1)... </vdim>
        <array>
            <aname> Z </aname>
            <dnum> _=>N+Int 1 </dnum>
            <dimensions> (.Map => N+Int 1 |-> Ins) ... </dimensions>
            ...
        </array>
        ...
    </Contract>
              
rule 
    <k> cntLength(C,Z,Ins)=> . ... </k>
    <Contract>
        <cname> C </cname>
        <Length> ...  Z|->(_=> Ins) ... </Length>
        ...
    </Contract>

rule 
    <k> cntLength(C,Z,Ins)=> . ... </k>
    <Contract>
        <cname> C </cname>
        <Length> (.Map =>  Z |-> Ins) ... </Length>
        <dim> N:Int => N +Int 1 </dim>
        <vdim> ... Z |-> (_=>N+Int 1)... </vdim>
        <array>
            <aname> Z </aname>
            <dnum> _=>N+Int 1 </dnum>
            <dimensions> (.Map => N+Int 1 |-> Ins) ... </dimensions>
            ...
        </array>
        ...
    </Contract>
             
rule  
    <k> NewArray(C:Id,Z:Id,Y:Int,N:Int,V:Value) => NewIdx(C,Z,Y,V)~> NewArray(C,Z,(Y+Int 1),N,V)... </k> requires Y<Int N
       
rule  
    <k> NewArray(C,Z,Y,Y,V) => . ... </k>
       
rule   
    <k> NewIdx(C,Z,Y,V) => . ... </k>
    <Contract>
        <cname> C </cname>
        <vnum>  N:Int => N +Int 1 </vnum>
        <vId> (.Map => N |-> !Num:Int) ... </vId>
        <variables> ( .Map => !Num |-> !Num) ... </variables>
        <typeName> ( .Map => !Num |-> Z) ... </typeName>
        <cstore> (.Map => !Num |-> V) ... </cstore>
        ...
    </Contract>
    //Mapping
         
rule 
    <k> pcsContractPart(C:Id, mapping(E:ElementaryTypeName => T:TypeName) Y:FunQuantifiers Z:Id;) => pcsContractPart(C:Id, T:TypeName[] Y:FunQuantifiers Z:Id;) ... </k>
   
//FunctionTypeName

rule 
    <k> pcsContractPart(C:Id, X:FunctionTypeName Y:FunQuantifiers Z:Id;) => . ... </k>

//UserDefinedTypeName

rule <k> pcsContractPart(C:Id, X:Id Y:FunQuantifiers Z:Id = X (V:Values);) => new X (.ExpressionList); ... </k>

rule <k> pcsContractPart(C:Id, X:Id Y:FunQuantifiers Z:Id = new X (V:Values);) => new X (V);  ... </k>
     
rule <k> pcsContractPart(C:Id,X:UsingForDeclaration) => . ... </k>  
               
//For elementary type names in the main contract
     
rule 
    <k> T:NotBool Y:StorageLocations X:Id => 1 ...</k>
    <contractStack> ListItem(-1) ... </contractStack>
    <env> Rho => Rho[X <- !N:Int] </env>
    <store>... .Map => !N |-> 0 ...</store>

rule 
    <k> T:SBool Y:StorageLocations X:Id => 1 ...</k>
    <contractStack> ListItem(-1) ... </contractStack>
    <env> Rho => Rho[X <- !N:Int] </env>
    <store>... .Map => !N |-> false ...</store>

//Local variables 

//ElementaryTypeName 

rule 
    <k> allocate(CI,T:ElementaryTypeName,Y:Id,X:Id,E:Value) => 1 ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> Rho => Rho[X <- !N:Int] </ctContext>
        <Memory>... .Map => !N |-> E ...</Memory>
        <ctType> (.Map => X |-> T) ... </ctType>
        <ctLocation> (.Map => X |-> Y) ... </ctLocation>
        ...
    </contractInstance>
 
rule 
    <k> T:NotBool Y:StorageLocations X:Id =>  allocate(CI,T,String2Id("Local"),X,0) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0

rule 
    <k> T:SBool Y:StorageLocations X:Id =>  allocate(CI,T,String2Id("Local"),X,false) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0

rule 
    <k> T:ElementaryTypeName Y:StorageLocations X:Id = E => allocate(CI,T,String2Id("Local"),X,E) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0
      
//Mapping
            
rule mapping(E:ElementaryTypeName => T:TypeName) Y:StorageLocations X:Id; => T[] Y X;

//UserDefinedTypeName
rule 
    <k> T:UserDefinedTypeName Y:StorageLocations X:Id; => . ...</k>

//FunctionTypeName
rule 
    <k> X:FunctionTypeName Y:StorageLocations Z:Id; => . ... </k>
      
//Local Array

//One-dimensional array

rule
    <k> allocate(CI:Int, T:ElementaryTypeName [Y:Int], S:Id, X:Id, V:Value) =>  NewArrayIndexes(CI,X,0,Y,V) ~> ISetSize(CI,X) ... </k>
    <vposition> Pos:Int => 1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N:Int => N +Int 1 </ctNum>
        <ctVId> (.Map => N |-> X) ... </ctVId>
        <ctContext> ( .Map => X |-> 1) ... </ctContext>
        <ctType> ( .Map => X |-> T) ... </ctType>
        <ctStore> ... 1 |-> (_=> V) ... </ctStore>
        <ctLocation> ( .Map => X |-> S) ... </ctLocation>
        <ilength> (.Map => X |-> Y) ...</ilength>
        <Memory> (.Map => X |-> 1) ... </Memory>
        <ivdim> (.Map => X |-> 1) ... </ivdim>
        (.Bag =>
            <iarray>
                <ianame> X </ianame>
                <idimensions>  1 |-> Y </idimensions>
                ...
            </iarray>)
        ...
    </contractInstance> 

rule 
    <k> T:ElementaryTypeName [Y:Int] S:StorageLocations X:Id; => allocate(CI,T[Y],String2Id("Local"),X,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>

rule 
    <k> allocate(CI:Int, T:ElementaryTypeName[], S:Id, X:Id, V:Value) => . ...</k>
    <vposition> Pos=>1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N:Int => N +Int 1 </ctNum>
        <ctVId> (.Map => N |-> X) ... </ctVId>
        <ctContext> ( .Map => X |-> 1) ... </ctContext>
        <ctType> ( .Map => X |-> T) ... </ctType>
        <ctStore> ... 1 |-> (_=> 0) ... </ctStore>
        <ctLocation> ( .Map => X |-> S) ... </ctLocation>
        <ilength> (.Map => X |-> 0) ... </ilength>
        <ivdim> (.Map => X |-> 0) ... </ivdim>
        <ibaseaddress> (.Map => X |-> 1) ... </ibaseaddress>
        ...
    </contractInstance>
        

rule 
    <k> T:ElementaryTypeName[] S:StorageLocations X:Id; => allocate(CI,T[],String2Id("Local"),X,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
            
rule 
    <k> ISetSize(CI,X) =>  ICntSize(CI,X,DNum,0)... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack> 
    <contractInstance>
        <ctId> CI </ctId>   
        //<ctContext> ... X |-> E ... </ctContext>   
        <Memory> ... X |-> (A=> 1) ... </Memory> 
        <ibaseaddress> (.Map => X |-> A:Int) ... </ibaseaddress>
        <iarray>
            <ianame> Z </ianame>
            <idnum> DNum </idnum>
            ...
        </iarray>
        ...
    </contractInstance>
     
rule 
    <k> ICntSize(CI,X,DNum,N) => IDSize(CI,X,N) ~> ICntSize(CI,X,DNum,N +Int 1) ... </k>
    requires N<Int DNum

rule 
    <k> ICntSize(CI,X,DNum,DNum) => . ... </k>

rule 
    <k> IDSize(CI,X,N) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        //<ctContext> ... X |-> E ... </ctContext>
        <Memory> ... X |-> (A=> A*Int I) ... </Memory>
        <iarray>
            <ianame> X </ianame>
            <idimensions> ... N+Int 1 |-> I ... </idimensions>
            ...
        </iarray>
        ...
    </contractInstance>
  
rule 
    <k> NewArrayIndexes(CI,X,N,Y,V) => NewArrayIndex(CI,X,N,Y,V) ~> NewArrayIndexes(CI,X,N+Int 1,Y,V) ... </k> requires N<Int Y
rule 
    <k> NewArrayIndexes(CI,X,Y,Y,V) => . ... </k>

rule 
    <k> NewArrayIndex(CI,X,N,Y,V) => . ... </k>
    <vposition> P:Int => P +Int 1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N1:Int => N1 +Int 1 </ctNum>
        <ctVId> (.Map => N1 |-> !Num:Int) ... </ctVId>
        <ctContext> (.Map => !Num:Int |-> P) ... </ctContext>
        <ctType> ... (.Map => !Num:Int |-> X)  ... </ctType>
        <ctStore> ... P |-> (_=> V) ... </ctStore>
        ...
    </contractInstance>
   
//Multi-dimensional array

rule 
    <k> allocate(CI:Int, T:ArrayTypeName [Y:Int], S:Id, X:Id, V:Value) => NewRows(CI,X,T,0,Y,V) ~> ISetSize(CI,X)... </k>
    <vposition> _=>1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctNum>  N:Int => N +Int 1 </ctNum>
        <ctVId> (.Map => N |-> X) ... </ctVId>
        <ctContext> ( .Map => X |-> 1) ... </ctContext>
        <ctType> ( .Map => X |-> T) ... </ctType>
        <ctStore> ... 1 |-> (_=> 0) ... </ctStore>
        <ctLocation> ( .Map => X |-> S) ... </ctLocation>
        <ilength> (.Map => T X |-> Y) ...</ilength>
        <Memory> (.Map => X |-> 1) ... </Memory>
        <idim> _=>1 </idim>
        <ivdim> (.Map => X |-> 1) ... </ivdim>
        (.Bag =>
            <iarray>
            <ianame> X </ianame>
            <idimensions>  1 |-> Y </idimensions>
            ...
            </iarray>)
        ...
    </contractInstance> 

rule 
    <k> T:ArrayTypeName [Y:Int] S:StorageLocations X:Id; => allocate(CI,T[Y],String2Id("Local"),X,0)... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
           
rule 
    <k> NewRows(CI,X,T,N,Y,V) => NewRow(CI,X,T,N,Y,V) ~> NewRows(CI,X,T,N +Int1,Y,V) ... </k> requires N<Int Y

rule 
    <k> NewRows(CI,X,T,Y,Y,V) => . ... </k>
     
rule 
    <k> NewRow(CI,X,T:ElementaryTypeName [Ins],N,Y,V) => IcntLength(CI,X,Ins) ~> NewArrayIndexes(CI,X,0,Ins,V) ~> . ... </k>

rule 
    <k> NewRow(CI,X,T:ArrayTypeName [Ins],N,Y,V) => ICntLength(CI,X,T,Ins) ~> NewRows(CI,X,T,0,Ins,V) ... </k>

rule 
    <k> T:ArrayTypeName[] S:StorageLocations X:Id; => T S X; ... </k>

rule 
    <k> ICntLength(CI,X,T:TypeName,Ins) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <ilength> ... T X |-> (_=>Ins) ... </ilength>
        ...
    </contractInstance>

rule 
    <k> ICntLength(CI,X,T:TypeName,Ins) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <ilength> (.Map=> T X |-> Ins) ... </ilength>
        <idim> N:Int => N +Int 1 </idim>
        <ivdim> ... X |-> ( _ => N +Int 1 )... </ivdim>
        <iarray>
            <ianame> X </ianame>
            <idnum> _=>N +Int 1 </idnum>
            <idimensions> (.Map => N+Int 1 |-> Ins) ... </idimensions>
            ...
        </iarray>
        ...
    </contractInstance>

rule 
    <k> IcntLength(CI,X,Ins) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <ilength> ... X |-> (_=>Ins) ... </ilength>
    ...
    </contractInstance>

rule 
    <k> IcntLength(CI,X,Ins) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <ilength> (.Map=> X |-> Ins) ... </ilength>
        <idim> N:Int => N +Int 1 </idim>
        <ivdim> ... X |-> (_=>N+Int 1)... </ivdim>
        <iarray>
            <ianame> X </ianame>
            <idnum> _=>N +Int 1 </idnum>
            <idimensions> (.Map => N+Int 1 |-> Ins) ... </idimensions>
            ...
        </iarray>
    ...
</contractInstance>

rule pcsStateVariableDeclarations(C:Id,X:Id,.VariableDeclarations,IName:Id) => .
rule pcsStateVariableDeclarations(C:Id,X:Id,(S:VariableDeclaration; Ss:VariableDeclarations),IName:Id) => pcsStateVariableDeclaration(C,X,S,IName) ~> pcsStateVariableDeclarations(C,X,Ss,IName)

rule 
    <k> pcsStateVariableDeclaration(C:Id,X:Id,T:NotBool Y:StorageLocations Z:Id,IName:Id) => allocate(C,T,String2Id("Global"),!D,0) ... </k>
    <Contract>
        <cname> C </cname>
        <structInstance>
            <structName> X </structName>
            <iname> IName </iname>
            <isnum> N1:Int => N1 +Int 1 </isnum>
            <ivariables> (.Map => Z |-> !D:Id)...</ivariables>
            ...
        </structInstance>
        ...
    </Contract>
             
rule 
    <k> pcsStateVariableDeclaration(C:Id,X:Id, T:SBool Y:StorageLocations Z:Id,IName:Id) => allocate(C,T,String2Id("Global"),!D,false) ... </k>
    <Contract>
        <cname> C </cname>
        <structInstance>
            <structName> X </structName>
            <iname> IName </iname>
            <isnum> N1:Int => N1 +Int 1 </isnum>
            <ivariables> (.Map => Z |-> !D:Id)...</ivariables>
            ...
        </structInstance>
    ...
</Contract>

rule <k> allocate(C:Id, T:ArrayTypeName, Y:Id, Z:Id, V:Value) =>   pcsContractPart(C:Id,T:ArrayTypeName .FunQuantifiers Z:Id;)... </k>  

rule 
    <k> pcsStateVariableDeclaration(C:Id,X:Id, T:ArrayTypeName Y:StorageLocations Z:Id,IName:Id) => allocate(C,T,String2Id("Global"),!D,0)... </k>
    <Contract>
        <cname> C </cname>
        <structInstance>
            <structName> X </structName>
            <iname> IName </iname>
            <isnum> N1:Int => N1 +Int 1 </isnum>
            <ivariables> (.Map => Z |-> !D:Id)...</ivariables>
            ...
        </structInstance>
        ...
    </Contract>


rule 
    <k> pcsStateVariableDeclaration(C:Id,X:Id, mapping(E:ElementaryTypeName => T:TypeName) Y:StorageLocations Z:Id,IName:Id) => 
        pcsStateVariableDeclaration(C:Id,X:Id, T[] Y:StorageLocations Z:Id,IName:Id)... </k>   

rule 
    <k> pcsStateVariableDeclaration(C:Id,X:Id, T:UserDefinedTypeName Y:StorageLocations Z:Id,IName:Id) => . ... </k> 

rule 
    <k> pcsStateVariableDeclaration(C:Id,X:Id, T:FunctionTypeName Y:StorageLocations Z:Id,IName:Id) => . ... </k>    

//StructInstance
        
rule 
    <k> allocate(C:Id,X:Id,S:Id,Y:Id,V:Value) => pcsStateVariableDeclarations(C,X,VarD,Y) ~> SetStructSize(C,X,Y) ... </k>
    <Contract>
        <cname> C </cname>
        <vnum>  N:Int => N +Int 1 </vnum>
        <vId> (.Map => N |-> Y )... </vId>
        <variables> ( .Map => Y |-> !Num:Int) ... </variables>
        <typeName> ( .Map => Y |-> "struct") ... </typeName>
        <cstore> (.Map => !Num |-> !Num +Int 1) ... </cstore>
        <Struct>
            <sname> X </sname>
            <vardec> VarD </vardec>
            ...
        </Struct>
        <cntStructInstance> N1:Int => N1 +Int 1 </cntStructInstance>
        (.Bag =>
            <structInstance>
                <structName> X </structName>
                <iId> N1 </iId>
                <iname> Y </iname>
                <isnum> 0 </isnum>
                <ivariables> .Map </ivariables>
                ...
            </structInstance>)
        ...
    </Contract>    

rule  
    <k> pcsContractPart(C:Id, X:Id S:FunQuantifiers Y:Id;) => allocate(C,X,String2Id("Global"),Y,0) ... </k>

rule  
    <k> SetStructSize(C:Id,X:Id,Y:Id) =>  . ... </k>
    <Contract>
        <cname> C </cname>
        <variables> ... Y |-> E ... </variables>
        <cstore> ... E |-> (A:Int=> Num) ... </cstore>
        <structInstance>
            <structName> X </structName>
            <iname> Y </iname>
            <isnum> Num </isnum>
            ...
        </structInstance>
        <baseAddress> (.Map => Y |-> A) ... </baseAddress>
        ...
    </Contract>   

rule <k> pcsContractPart(C:Id, X:Id Y:FunQuantifiers Z:Id;) => pcsContractPart(C:Id, address Y Z;)... </k>

//StructDefinition

rule 
    <k> pcsContractPart(C:Id, struct X:Id {S:VariableDeclarations;}) => . ... </k>
    <Contract>
        <cname> C </cname>
        (.Bag => 
        <Struct>
            <sname> X </sname>
            <vardec> S </vardec>
            ...
        </Struct>)
        ...
    </Contract>

endmodule


