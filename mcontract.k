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
  <k> pcsContractPart(C:Id, X:NotBoolByte Y:FunQuantifiers Z:Id;) => allocate(C,X,String2Id("Global"),Z,0) ... </k>

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
    <Length> (.Map => Z |-> 0) ... </Length>
    ...
  </Contract>
     
rule 
    <k> pcsContractPart(C:Id, X:NotByte Y:FunQuantifiers Z:Id = E;) => allocate(C,X,String2Id("Global"),Z,E) ... </k>

rule <k> pcsContractPart(C:Id, X:Byte Y:FunQuantifiers Z:Id = E;) => pcsContractPart(C:Id, X[S1] Y:FunQuantifiers Z:Id;) ~> BytesAssignG(C,Z,S2,I,0)...</k>
     <byteSize> ... X |-> S1 ... </byteSize>
     <stringSize> ... E |-> S2 ...</stringSize>
     <ASCII> ... E |-> I ... </ASCII>
     requires S1 >=Int S2

rule 
    <k> BytesAssignG(C,Z,S,I,N) => ByteAssignG(C,Z,S,I,N,(I /(100 ** (S - N - 1))) % 100) ~> BytesAssignG(C,Z,S,I,N +Int 1) ... </k>
    requires S >Int N
     
rule 
    <k> ByteAssignG(C,Z,S,I,N,V:Int) => . ... </k>
    <Contract>
        <cname> C </cname>
        <baseAddress> ... Z |-> A ... </baseAddress>
        <cstore> ... (A +Int N |-> _)=> (A +Int N |-> V) ... </cstore>
        ...
    </Contract>

rule 
    <k> BytesAssignG(C,X,S,I,S) => . ... </k>
    
rule 
    <k> pcsContractPart(C:Id, X:SBool Y:FunQuantifiers Z:Id;) => allocate(C,X,String2Id("Global"),Z,false) ... </k>

rule 
    <k> pcsContractPart(C:Id, X:SByte Y:FunQuantifiers Z:Id;) => allocate(C,X[S],String2Id("Global"),Z,0) ... </k>
    <byteSize> ... X |-> S ... </byteSize>

rule 
    <k> pcsContractPart(C:Id, X:Bytes Y:FunQuantifiers Z:Id;) => allocate(C,X[],String2Id("Global"),Z,0) ... </k>
    
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
    requires I >Int 0

rule 
    <k> pcsContractPart(C:Id, T:ElementaryTypeName[I:Int] Y:FunQuantifiers Z:Id;) => allocate(C,T[I],String2Id("Global"),Z,0) ... </k>
           
rule 
    <k> SetSize(C,Z) => CntSize(C,Z,DNum,0) ... </k>
    <Contract>
        <cname> C </cname>
        <variables> ... Z |-> E ... </variables>
        <cstore> ... (E |-> A:Int) => (E |-> 1) ... </cstore>
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
        <cstore> ... (E |-> A) => (E |-> A*Int I) ... </cstore>
        <array>
            <aname> Z </aname>
            <dimensions> ... N+Int 1 |-> I ... </dimensions>
            ...
        </array>
        ...
    </Contract>

rule 
    <k> allocate(C:Id, T:ElementaryTypeName [], Y:Id, Z:Id, V:Value) => . ... </k>    
    <Contract>
        <cname> C </cname>
        <vnum>  N:Int => N +Int 1 </vnum>
        <vId> (.Map => N |-> Z) ... </vId>
        <variables> ( .Map => Z |-> !Num:Int) ... </variables>
        <typeName> ( .Map => Z |-> T) ... </typeName>
        //<dtype> (.Map => Z |-> T) ... </dtype>
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
    requires I >Int 0

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
        <Length> ... (T Z|-> _) => (T Z |-> Ins) ... </Length>
        ...
    </Contract>

rule 
    <k> CntLength(C,Z,T:TypeName,Ins)=> . ... </k>
    <Contract>
        <cname> C </cname>
        <Length> (.Map => T Z|-> Ins) ... </Length>
        <dim> N:Int => N +Int 1 </dim>
        <vdim> ... (Z |-> _) => (Z |-> N+Int 1)... </vdim>
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
        <Length> ...  (Z |-> _) => (Z |-> Ins) ... </Length>
        ...
    </Contract>

rule 
    <k> cntLength(C,Z,Ins)=> . ... </k>
    <Contract>
        <cname> C </cname>
        <Length> (.Map =>  Z |-> Ins) ... </Length>
        <dim> N:Int => N +Int 1 </dim>
        <vdim> ... (Z |-> _) => (Z |-> N+Int 1)... </vdim>
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

rule 
    <k> pcsContractPart(C:Id, X:Id Y:FunQuantifiers Z:Id = X (V:Values);) => new X (.ExpressionList); ... </k>

rule 
    <k> pcsContractPart(C:Id, X:Id Y:FunQuantifiers Z:Id = new X (V:Values);) => new X (V);  ... </k>
     
rule 
    <k> pcsContractPart(C:Id,X:UsingForDeclaration) => . ... </k>  

//Enum

rule 
    <k> pcsContractPart(C:Id, enum X:Id { Y:Identifiers } ) => . ... </k>
    <Contract> 
        <cname> C </cname>
        (.Bag =>
            <Enum>
                <enumname> X </enumname>
                <enumlist> Y </enumlist>
            </Enum>)
        ...
    </Contract>

rule 
    <k> pcsContractPart(C:Id, X:Id Y:FunQuantifiers Z:Id; ) => GetItem(C,Z,X,L,0) ... </k>
    <Contract> 
        <cname> C </cname>
        <Enum>
            <enumname> X </enumname>
            <enumlist> L </enumlist>
        </Enum>
        (.Bag =>
            <EnumIns> 
                <insId> Z </insId>
                <enumInsname> X </enumInsname>
                <enumInslist> L </enumInslist>
                ...
            </EnumIns>)
        <insValue> (.Map => Z |-> 0) ... </insValue>
        ...
    </Contract>

rule 
    <k> GetItem(C,Z,X,L,I) => Items(C,Z,X,L,I,0) ... </k>

rule 
    <k> Items(C,Z,X,(E:Id,L),I,N) => Items(C,Z,X,L,I,N +Int 1) ... </k>
    requires I >Int N

rule 
    <k> Items(C,Z,X,(E:Id,L),I,I) => . ... </k>
    <Contract> 
        <cname> C </cname>
        <insValue> ... (Z |-> _) => (Z |-> E) ... </insValue>
        ...
    </Contract>
      
rule 
    <k> X:Id(Y:Int) => FindEnum(C,Z,X,L,Y,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> C </ctName>
        ...
    </contractInstance>
    <Contract> 
        <cname> C </cname>
        <Enum>
            <enumname> X </enumname>
            <enumlist> L </enumlist>
        </Enum>
        <EnumIns> 
            <insId> Z </insId>
            <enumInsname> X </enumInsname>
            <enumInslist> L </enumInslist>
            ...
        </EnumIns>
        ...
    </Contract>
    requires Y >=Int 0

rule <k> X:Id(Y:Int) => Id2String(E) ... </k>
     <contractStack> ListItem(CI:Int) ... </contractStack>
     <contractInstance>
         <ctId> CI </ctId>
         <ctName> C </ctName>
         <iinsValue> ... Z |-> E ... </iinsValue>
         ...
     </contractInstance>
     <Contract> 
         <cname> C </cname>
         <Enum>
             <enumname> X </enumname>
             ...
         </Enum>
         <EnumIns> 
             <insId> Z </insId>
             <enumInsname> X </enumInsname>
             ...
         </EnumIns>
         ...
     </Contract>
     <Throw> _ => true </Throw>
     requires Y <Int 0

rule 
    <k> X:Id(Y:Int,.ExpressionList) => X(Y) ... </k>

rule 
    <k> FindEnum(C,Z,X,(E:Id,L),I,N) => FindEnum(C,Z,X,L,I,N +Int 1) ... </k>
    requires I >Int N

rule 
    <k> FindEnum(C,Z,X,(E:Id,L),I,I) => Id2String(E) ... </k>

rule 
    <k> FindEnum(C,Z,X,.Identifiers,I,N) => Id2String(E) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> C </ctName>
        <iinsValue> ... Z |-> E ... </iinsValue>
        ...
    </contractInstance>
    <Throw> _ => true </Throw>

rule 
    <k> (T:ElementaryTypeName (X:String)):FunctionCall => 0 ... </k>

rule 
    <k> X,.ExpressionList => X ... </k>
            
rule 
    <k> (X:Id.Y:Id):MemberAccess => enumIns(X,Y,L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <Enum>
            <enumname> X </enumname>
            <enumlist> L </enumlist>
            ...
        </Enum>
        ...
    </Contract> 
         
rule 
    <k> enumIns(X,Y,L) => enumCheck(X,Y,L) ... </k>  

rule 
    <k> enumCheck(X,Y,(Y,Lr)) => Id2String(Y) ... </k>
         
rule 
    <k> enumCheck(X,Y,(Z,Lr)) => enumCheck(X,Y,Lr) ... </k>
    requires Id2String(Z) =/=String Id2String(Y)

rule 
    <k> enumCheck(X,Y,.Identifiers) => 0 ... </k>

rule 
    <k> X:Id = Y:String => write(X,Y) ... </k>

rule 
    <k> write(X:Id,Y:String) => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <iinsValue> ... (X |-> _) => (X |-> String2Id(Y)) ... </iinsValue>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <EnumIns>
            <insId> X </insId>
            ...
        </EnumIns>
        ...
    </Contract> 

rule 
    <k> read(X:Id) => Id2String(I) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <iinsValue> ...X |-> I ...</iinsValue>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <EnumIns>
            <insId> X </insId>
            ...
        </EnumIns>
        ...
    </Contract> 

//For elementary type names in the main contract
     
rule 
    <k> T:NotBoolByte Y:StorageLocations X:Id => 1 ...</k>
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
    <k> T:NotBoolByte Y:StorageLocations X:Id =>  allocate(CI,T,String2Id("Local"),X,0) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0

rule 
    <k> T:SBool Y:StorageLocations X:Id =>  allocate(CI,T,String2Id("Local"),X,false) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0

rule 
    <k> T:NotByte Y:StorageLocations X:Id = E => allocate(CI,T,String2Id("Local"),X,E) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0

rule 
    <k> T:SByte Y:StorageLocations X:Id = E => T [S1] Y:StorageLocations X:Id; ~> BytesAssign(X,S2,I,0) ~> 1 ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <byteSize> ... T |-> S1 ... </byteSize>
    <stringSize> ... E |-> S2 ...</stringSize>
    <ASCII> ... E |-> I ... </ASCII>
    requires S1 >=Int S2 andBool CI>=Int 0
   
rule 
    <k> BytesAssign(X,S,I,N) => ByteAssign(X,S,I,N) ~> BytesAssign(X,S,I,N +Int 1) ... </k>
    requires S >Int N

rule 
    <k> BytesAssign(X,S,I,S) => . ... </k>

rule 
    <k> ByteAssign(X,S,I,N) => X[S -Int N -Int 1]= (I /(100 ** N)) % 100 ; ... </k>
    
rule 
    <k> T:SByte Y:StorageLocations X:Id => allocate(CI,T[S],String2Id("Local"),X,0) ... </k>
    <byteSize> ... T |-> S ... </byteSize>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0

rule 
    <k> T:Bytes Y:StorageLocations X:Id => allocate(CI,T[],String2Id("Local"),X,0) ... </k>
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
    <k> allocate(CI:Int, T:NotByte [Y:Int], S:Id, X:Id, V:Value) =>  NewArrayIndexes(CI,X,0,Y,V,T) ~> ISetSize(CI,X) ~> 1 ... </k>
    <vposition> Pos:Int => 1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N:Int => N +Int 1 </ctNum>
        <ctVId> (.Map => N |-> X) ... </ctVId>
        <ctContext> ( .Map => X |-> 1) ... </ctContext>
        <ctType> ( .Map => X |-> T) ... </ctType>
        <ctStore> ... (1 |-> _) => (1 |-> V) ... </ctStore>
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
    <k> allocate(CI:Int, T:NotByte [Y:Int], S:Id, X:Id, V:Value) =>  NewArrayIndexes(CI,X,0,Y,V,T) ~> ISetSize(CI,X) ~> 1 ... </k>
    <vposition> Pos:Int => 1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N:Int => N +Int 1 </ctNum>
        <ctVId> (.Map => N |-> X) ... </ctVId>
        <ctContext> ( .Map => X |-> 1) ... </ctContext>
        <ctType> ( .Map => X |-> T) ... </ctType>
        <ctStore> (.Map => (1 |-> V)) Rho:Map </ctStore>
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
    requires notBool (1 in keys(Rho))

rule 
    <k> allocate(CI:Int, T:Byte [Y:Int], S:Id, X:Id, V:Value) =>  NewArrayIndexes(CI,X,0,Y,V,T) ~> ISetSize(CI,X) ~> 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N:Int => N +Int 1 </ctNum>
        <ctVId> (.Map => N |-> X) ... </ctVId>
        <ctContext> ( .Map => X |-> !Num:Int) ... </ctContext>
        <ctType> ( .Map => X |-> T) ... </ctType>
        <ctStore> ... (.Map =>!Num |->  Y) ... </ctStore>
        <ctLocation> (.Map => X |-> String2Id("Local")) ... </ctLocation>
        <ilength> (.Map => X |-> Y) ...</ilength>
        <Memory> (.Map => X |-> !Num +Int 1) ... </Memory>
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
    <k> T:ElementaryTypeName [Y:Int] S:StorageLocations X:Id => allocate(CI,T[Y],String2Id("Local"),X,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>

rule 
    <k> allocate(CI:Int, T:NotByte[], S:Id, X:Id, V:Value) => 1 ...</k>
    <vposition> Pos=>1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N:Int => N +Int 1 </ctNum>
        <ctVId> (.Map => N |-> X) ... </ctVId>
        <ctContext> ( .Map => X |-> 1) ... </ctContext>
        <ctType> ( .Map => X |-> T) ... </ctType>
        <ctStore> ... (1 |-> _) => (1 |-> 0) ... </ctStore>
        <ctLocation> ( .Map => X |-> S) ... </ctLocation>
        <ilength> (.Map => X |-> 0) ... </ilength>
        <ivdim> (.Map => X |-> 0) ... </ivdim>
        <ibaseaddress> (.Map => X |-> 1) ... </ibaseaddress>
        ...
    </contractInstance>

rule 
    <k> allocate(CI:Int, T:Byte[], S:Id, X:Id, V:Value) => 1 ...</k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N:Int => N +Int 1 </ctNum>
        <ctVId> (.Map => N |-> X) ... </ctVId>
        <ctContext> ( .Map => X |-> !Num:Int) ... </ctContext>
        <ctType> ( .Map => X |-> T) ... </ctType>
        <ctStore> ... (.Map => !Num |-> 0) ... </ctStore>
        <ctLocation> (.Map => X |-> String2Id("Local")) ... </ctLocation>
        <ilength> (.Map => X |-> 0) ...</ilength>
        <ivdim> (.Map => X |-> 0) ... </ivdim>
        <ibaseaddress> (.Map => X |-> !Num) ... </ibaseaddress>
        ...
    </contractInstance> 

rule 
    <k> T:ElementaryTypeName[] S:StorageLocations X:Id => allocate(CI,T[],String2Id("Local"),X,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
            
rule 
    <k> ISetSize(CI,X) =>  ICntSize(CI,X,DNum,0)... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack> 
    <contractInstance>
        <ctId> CI </ctId>   
        //<ctContext> ... X |-> E ... </ctContext>   
        <Memory> ... (X |-> A) =>(X |-> 1) ... </Memory> 
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
        <Memory> ... (X |-> A) => (X |-> A*Int I) ... </Memory>
        <iarray>
            <ianame> X </ianame>
            <idimensions> ... N+Int 1 |-> I ... </idimensions>
            ...
        </iarray>
        ...
    </contractInstance>
  
rule 
    <k> NewArrayIndexes(CI,X,N,Y,V,T) => NewArrayIndex(CI,X,N,Y,V,T) ~> NewArrayIndexes(CI,X,N+Int 1,Y,V,T) ... </k> requires N<Int Y
rule 
    <k> NewArrayIndexes(CI,X,Y,Y,V,T) => . ... </k>

rule 
    <k> NewArrayIndex(CI,X,N,Y,V,T:NotByte) => . ... </k>
    <vposition> P:Int => P +Int 1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N1:Int => N1 +Int 1 </ctNum>
        <ctVId> (.Map => N1 |-> !Num:Int) ... </ctVId>
        <ctContext> (.Map => !Num:Int |-> P) ... </ctContext>
        <ctType> ... (.Map => !Num:Int |-> X)  ... </ctType>
        <ctStore> ... (P |-> _) =>(P |-> V) ... </ctStore>
        ...
    </contractInstance>

rule 
    <k> NewArrayIndex(CI,X,N,Y,V,T:NotByte) => . ... </k>
    <vposition> P:Int => P +Int 1 </vposition>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N1:Int => N1 +Int 1 </ctNum>
        <ctVId> (.Map => N1 |-> !Num:Int) ... </ctVId>
        <ctContext> (.Map => !Num:Int |-> P) ... </ctContext>
        <ctType> ... (.Map => !Num:Int |-> X)  ... </ctType>
        <ctStore> ... (.Map => P |-> V) ... </ctStore>
        ...
    </contractInstance>

rule 
    <k> NewArrayIndex(CI,X,N,Y,V,T:Byte) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <ctNum>  N1:Int => N1 +Int 1 </ctNum>
        <ctVId> (.Map => N1 |-> !Num:Int) ... </ctVId>
        <ctContext> (.Map => !Num:Int |-> !Num) ... </ctContext>
        <ctType> ... (.Map => !Num:Int |-> X)  ... </ctType>
        <ctStore> ... (.Map =>!Num |-> V) ... </ctStore>
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
        <ctStore> ... (1 |-> _) => (1 |-> 0) ... </ctStore>
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
    <k> NewRow(CI,X,T:ElementaryTypeName [Ins],N,Y,V) => IcntLength(CI,X,Ins) ~> NewArrayIndexes(CI,X,0,Ins,V,T) ~> . ... </k>

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
        <ivdim> ... (X |-> _) =>(X |-> N +Int 1 )... </ivdim>
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
        <ilength> ... (X |-> _) => (X |-> Ins) ... </ilength>
    ...
    </contractInstance>

rule 
    <k> IcntLength(CI,X,Ins) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <ilength> (.Map=> X |-> Ins) ... </ilength>
        <idim> N:Int => N +Int 1 </idim>
        <ivdim> ... (X |-> _) => (X |-> N+Int 1)... </ivdim>
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
    <k> pcsStateVariableDeclaration(C:Id,X:Id,T:NotBoolByte Y:StorageLocations Z:Id,IName:Id) => allocate(C,T,String2Id("Global"),!D,0) ... </k>
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

rule 
    <k> pcsStateVariableDeclaration(C:Id,X:Id,T:Byte Y:StorageLocations Z:Id,IName:Id) => allocate(C,T,String2Id("Global"),!D,0)... </k>
 
rule 
    <k> pcsStateVariableDeclaration(C:Id,X:Id, T:ArrayTypeName Y:StorageLocations Z:Id,IName:Id) => pcsContractPart(C:Id,T:ArrayTypeName .FunQuantifiers !D:Id;)... </k>
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

//rule  
    //<k> pcsContractPart(C:Id, X:Id S:FunQuantifiers Y:Id;) => allocate(C,X,String2Id("Global"),Y,0) ... </k>

rule  
    <k> SetStructSize(C:Id,X:Id,Y:Id) =>  . ... </k>
    <Contract>
        <cname> C </cname>
        <variables> ... Y |-> E ... </variables>
        <cstore> ... (E |-> A:Int) => (E |-> Num) ... </cstore>
        <structInstance>
            <structName> X </structName>
            <iname> Y </iname>
            <isnum> Num </isnum>
            ...
        </structInstance>
        <baseAddress> (.Map => Y |-> A) ... </baseAddress>
        ...
    </Contract>   

//rule <k> pcsContractPart(C:Id, X:Id Y:FunQuantifiers Z:Id;) => pcsContractPart(C:Id, address Y Z;)... </k>

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


