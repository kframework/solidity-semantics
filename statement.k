requires "solidity-syntax.k"
requires "configuration.k"

module STATEMENT

imports SOLIDITY-SYNTAX
imports CONFIGURATION

// Member Access

rule #assign1(#memberAccess(X:Id,Y:Id), I:Value)  => write(#memberAccess(X:Id,Y:Id), I:Value)

rule 
    <k> write(#memberAccess(X:Id,Y:Id), I:Value)   => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctContext> ... D |-> E ... </ctContext>
        <ctLocation> ... D |-> String2Id("Global") ... </ctLocation>
        <ctStore> ... (E |-> _) => (E |-> I) ... </ctStore>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <structInstance>
            <iname> X </iname>
            <ivariables> ... Y |-> D ... </ivariables>
            ... 
        </structInstance>
        ...
    </Contract> 

rule 
    <k> write(#memberAccess(X:Id,Y:Id), I:Value)   => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... D |-> E ... </ctContext>
        <ctLocation> ... D |-> String2Id("Local") ... </ctLocation>
        <Memory> ... (E |-> _) => (E |-> I) ... </Memory>
        <istructInstance>
            <iiname> X </iiname>
            <iivariables> ... Y |-> D ... </iivariables>
            ... 
        </istructInstance>
        ...
    </contractInstance>

rule #memberAccess(X:Id, Y:Id)  => read(#memberAccess(X:Id, Y:Id))

rule 
    <k> read(#memberAccess(X:Id, Y:Id)) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctContext> ... D |-> E ... </ctContext>
        <ctStore> ... E |-> I ... </ctStore>
        <ctLocation> ... D |-> String2Id("Global") ... </ctLocation>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <structInstance>
            <iname> X </iname>
            <ivariables> ... Y |-> D ... </ivariables>
            ... 
        </structInstance>
        ...
    </Contract>

rule 
    <k> read(#memberAccess(X:Id, Y:Id)) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... D |-> E ... </ctContext>
        <Memory> ... E |-> I ... </Memory>
        <ctLocation> ... D |-> String2Id("Local") ... </ctLocation>
        <istructInstance>
            <iiname> X </iiname>
            <iivariables> ... Y |-> D ... </iivariables>
            ... 
        </istructInstance>
        ...
    </contractInstance>

//Read and write for dynamic struct instance

rule #assign1(#memberAccess(#indexAccess(X:Id,Y:Int),Z:Id), I:Value)  => write(#memberAccess(#indexAccess(X:Id,Y:Int),Z:Id), I:Value)

rule
    <k> write(#memberAccess(#indexAccess(X:Id,Y:Int),Z:Id), I:Value) => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... A2 |-> E ... </ctContext>
        <ctStore> ... (E |-> _) => (E |-> I) ... </ctStore>
        <ctLocation> ... A2 |-> String2Id("Global") ... </ctLocation>
        <istructInstance>
            <iiname> X </iiname>
            <iivariables> ... Y |-> A1 ... </iivariables>
            ... 
        </istructInstance>
        <istructInstance>
            <iiname> A1 </iiname>
            <iivariables> ... Z |-> A2 ... </iivariables>
            ... 
        </istructInstance>
        ...
    </contractInstance>

rule
    <k> write(#memberAccess(#indexAccess(X:Id,Y:Int),Z:Id), I:Value) => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
            <ctId> CI </ctId>
            <ctContext> ... A2 |-> E ... </ctContext>
            <Memory> ... (E |-> _) => (E |-> I) ... </Memory>
            <ctLocation> ... A2 |-> String2Id("Local") ... </ctLocation>
            <istructInstance>
                <iiname> X </iiname>
                <iivariables> ... Y |-> A1 ... </iivariables>
                ... 
            </istructInstance>
            <istructInstance>
                <iiname> A1 </iiname>
                <iivariables> ... Z |-> A2 ... </iivariables>
                ... 
            </istructInstance>
            ...
         </contractInstance>

rule 
    <k> #memberAccess(#indexAccess(X:Id,Y:Int),Z:Id) => read(#memberAccess(#indexAccess(X:Id,Y:Int),Z:Id)) ... </k>

rule 
    <k> read(#memberAccess(#indexAccess(X:Id,Y:Int),Z:Id)) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
            <ctId> CI </ctId>
            <ctContext> ... A2 |-> E ... </ctContext>
            <ctStore> ... E |-> I ... </ctStore>
            <ctLocation> ... A2 |-> String2Id("Global") ... </ctLocation>
            <istructInstance>
                <iiname> X </iiname>
                <iivariables> ... Y |-> A1 ... </iivariables>
                ... 
            </istructInstance>
            <istructInstance>
                <iiname> A1 </iiname>
                <iivariables> ... Z |-> A2 ... </iivariables>
                ... 
            </istructInstance>
            ...
         </contractInstance>

rule 
    <k> read(#memberAccess(#indexAccess(X:Id,Y:Int),Z:Id)) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
            <ctId> CI </ctId>
            <ctContext> ... A2 |-> E ... </ctContext>
            <Memory> ... E |-> I ... </Memory>
            <ctLocation> ... A2 |-> String2Id("Local") ... </ctLocation>
            <istructInstance>
                <iiname> X </iiname>
                <iivariables> ... Y |-> A1 ... </iivariables>
                ... 
            </istructInstance>
            <istructInstance>
                <iiname> A1 </iiname>
                <iivariables> ... Z |-> A2 ... </iivariables>
                ... 
            </istructInstance>
            ...
         </contractInstance>


rule #assign1(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  => write(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)

rule 
    <k> write(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctContext> ... D |-> S ... </ctContext>
        <ctStore> ... (S +Int Z +Int 1|-> _) => (S +Int Z +Int 1|-> I)... </ctStore>
        <ctLocation> ... D |-> String2Id("Global") ... </ctLocation>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <structInstance>
            <iname> X </iname>
            <ivariables> ... Y |-> D ... </ivariables>
            ... 
        </structInstance>
        ...
    </Contract> 

rule 
    <k> write(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... D |-> S ... </ctContext>
        <Memory> ... (S +Int Z +Int 1|-> _) => (S +Int Z +Int 1|-> I)... </Memory>
        <ctLocation> ... D |-> String2Id("Local") ... </ctLocation>
        <istructInstance>
            <iiname> X </iiname>
            <iivariables> ... Y |-> D ... </iivariables>
            ... 
        </istructInstance>
        ...
    </contractInstance>

rule #indexAccess(#memberAccess(X:Id, Y:Id), Z:Int)  => read(#indexAccess(#memberAccess(X:Id, Y:Id), Z:Int))

rule
    <k> read(#indexAccess(#memberAccess(X:Id, Y:Id), Z:Int))  => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctContext> ... D |-> S ... </ctContext>
        <ctStore> ... S +Int Z +Int 1|-> I... </ctStore>
        <ctLocation> ... D |-> String2Id("Global") ... </ctLocation>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <structInstance>
            <iname> X </iname>
            <ivariables> ... Y |-> D ... </ivariables>
            ... 
        </structInstance>
        ...
    </Contract>

rule
    <k> read(#indexAccess(#memberAccess(X:Id, Y:Id), Z:Int))  => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... D |-> S ... </ctContext>
        <Memory> ... S +Int Z +Int 1|-> I... </Memory>
        <ctLocation> ... D |-> String2Id("Local") ... </ctLocation>
        <istructInstance>
            <iiname> X </iiname>
            <iivariables> ... Y |-> D ... </iivariables>
            ... 
        </istructInstance>
        ...
    </contractInstance>

//Block

rule 
    <k> {Ss:Statements} => Ss ~> Rho ...</k> 
    <env> Rho </env>  
    [structural]

rule 
    <k> Rho:Map => . ...</k> 
    <env> _ => Rho </env>    
    [structural]        
   
//Statements

rule .Statements => .
rule S:Statement Ss:Statements => S ~> Ss

// if

rule if (true)  S => S
rule if (false) S:Statement => .
rule if (true)  S else S1:Statement => S
rule if (false) S1:Statement else S => S
         
//Loops

rule 
    <k> for (A;B:Expression;C) {S} => InitStmts(A) if (B) {ExeWhile(S) ExeCounters(C) for (A;B;C) {S}} else {EndLoop(.Statements)} ... </k>
    <loopCon> true </loopCon>
    <Continue> _=>false </Continue>
    <exeCon> true </exeCon>
         
rule 
    <k> for (A;.ExpressionList;C) {S} => InitStmts(A) ExeWhile(S) ExeCounters(C) for (A;.ExpressionList;C) {S} ... </k>
    <loopCon> true </loopCon>
    <Continue> _=>false </Continue>
    <exeCon> true </exeCon>

rule 
    <k> for (A;B;C) {S} => Reset(1) ... </k> 
    <loopCon> false </loopCon>

rule 
    <k> for (A;B;C) {S} => . ... </k> 
    <exeCon> false </exeCon>

rule 
    <k> for (A;B;C) S:NotBlock => A; while (B) {S C;} ... </k> 

rule 
    <k> for (A;.ExpressionList;C) S:NotBlock => A; while (true) {S C;} ... </k>

rule 
    <k> EndLoop(.Statements) => . ... </k>
    <forInit> _=>true </forInit>

rule 
    <k> InitStmts(S:SimpleStatement Ss:SimpleStatements) => InitStmt(S) ~> InitStmts(Ss) ... </k>

rule 
    <k> InitStmt(S) => S; ... </k>
    <forInit> true=>false </forInit>

rule 
    <k> InitStmt(S) => . ... </k>
    <forInit> false </forInit>

rule 
    <k> InitStmts(.SimpleStatements) => . ... </k>

rule 
    <k> do {S} while (B); =>  ExeWhile(S) if(B) {do {S} while (B);} else {.Statements} ... </k> 
    <loopCon> true </loopCon>
    <Continue> _=>false </Continue>
    <exeCon> true </exeCon>

rule 
    <k> do {S} while (B); => Reset(1) ... </k> 
    <loopCon> false </loopCon>

rule 
    <k> do {S} while (B); => . ... </k> 
    <exeCon> false </exeCon>

rule 
    <k> while (B) {S} => if (B) {ExeWhile(S) while (B) {S}} else {.Statements} ... </k> 
    <loopCon> true </loopCon>
    <Continue> _=>false </Continue>
    <exeCon> true </exeCon>

rule 
    <k> while (B) S:NotBlock => if (B) {S while (B) S} else {.Statements} ... </k> 

rule 
    <k> while (B) S => . ... </k>
    <exeCon> false </exeCon>

rule 
    <k> while (B) S => Reset(1) ... </k> 
    <loopCon> false </loopCon>
              
rule 
    <k> ExeWhile(S:Statement Ss:Statements) => ExeWhileStmt(S) ~>  ExeWhile(Ss) ... </k>

rule 
    <k> ExeWhile(.Statements) => . ... </k>

rule 
    <k> ExeWhileStmt(S) => S ... </k>
    <exeCon> true </exeCon>
    <Continue> false </Continue>
    <loopCon> true </loopCon>

rule 
    <k> ExeWhileStmt(S) => . ... </k>
    <exeCon> false </exeCon>

rule 
    <k> ExeWhileStmt(S) => . ... </k>
    <Continue> true </Continue>

rule 
    <k> ExeWhileStmt(S) => . ... </k>
    <loopCon> false </loopCon>
    
rule 
    <k> ExeCounters(S:SimpleStatement Ss:SimpleStatements) => ExeCounter(S) ~> ExeCounters(Ss) ... </k>

rule 
    <k> ExeCounters(.SimpleStatements) => . ... </k>

rule 
    <k> ExeCounter(S) => S; ... </k>
    <loopCon> true </loopCon>
    <exeCon> true </exeCon>

rule 
    <k> ExeCounter(S) => . ... </k>
    <loopCon> false </loopCon>

rule 
    <k> ExeCounter(S) => . ... </k>
    <exeCon> false </exeCon>

rule 
    <k> Reset(1) => . ... </k>
    <loopCon> _=>true </loopCon>
    <forInit> _=> true </forInit>
    
rule    
    <k> break; => . ... </k>
    <loopCon> _=>false </loopCon>

rule 
    <k> continue; => . ... </k> 
    <Continue> _=> true </Continue>

rule 
    <k> revert(.ExpressionList); => throw; ... </k>

//Expression
        
//NewExpression

rule 
    <k> new X:Id (E:ExpressionList) => CopyGlobalStructIns(X,N,SN,0) ~> CallConstructor(X,N,Cst,E) ... </k>
    <Contract>
        <cname> X </cname>
        <vnum> Num </vnum>
        <vId> V </vId>
        <variables> Rho </variables>
        <typeName> Type </typeName>
        <cstore> S </cstore>
        <cLocation> CL </cLocation>
        <dtype> Dt </dtype>
        <dstore> Ds </dstore>
        <insValue> IV </insValue>
        <Length> L </Length>
        <baseAddress> B </baseAddress>
        <constructor> Cst </constructor>
        <cntStructInstance> SN </cntStructInstance>
        ...
    </Contract> 
    <cntContracts> N:Int => N +Int 1 </cntContracts>
    (.Bag => 
        <contractInstance>
            <ctId> N </ctId>
            <ctName> X </ctName>
            <ctNum> Num </ctNum>
            <ctVId> V </ctVId>
            <ctContext> Rho </ctContext>
            <ctType> Type </ctType>
            <ctStore> S </ctStore>
            <ctLocation> CL </ctLocation>
            <idType> Dt </idType>
            <idStore> Ds </idStore>
            <Memory> .Map </Memory>
            <iinsValue> IV </iinsValue>
            <ilength> L </ilength>
            <ibaseaddress> B </ibaseaddress>
            ...
        </contractInstance> )
    <cnttran> K:Int => K +Int 1 </cnttran>
    <tranComputation> (.Map => K |-> "new contract") ... </tranComputation>
    <newStack> (.List => ListItem(X)) ... </newStack>

// TODO: this should probably not be here
rule <k> _:AllValues; => . ... </k>
       
rule  
    <k> CallConstructor(C,N,0,E) => N ... </k>
    <newStack>  ListItem(C) => .List ... </newStack>

rule  
    <k> CallConstructor(C,N,1,E) => functionCall(-1;N;C;E;msginfo(-1,N,0,0))  ... </k> 
       
rule  
    <k> C:Id(I:Int)=> I ... </k>
    <Contract>
        <cname> C </cname>
        ...
    </Contract>

rule 
    <k> CopyGlobalStructIns(X,CI,SN,N) => CopyGlobalStructIns(X,CI,SN,N +Int 1) ...</k>
    <Contract>
        <cname> X </cname>
        <structInstance>
            <structName> SName </structName>
            <iname> IName </iname>
            <iId> N </iId>
            <isnum> SNum </isnum>
            <ivariables> IV </ivariables>
            <ivariablesId> IVId </ivariablesId>
        </structInstance>
        ...
    </Contract>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> X </ctName>
        <icntStructInstance> N1:Int => N1 +Int 1 </icntStructInstance>
        (.Bag=>
            <istructInstance>
                <istructName> SName </istructName>
                <iiname> IName </iiname>
                <iiId> N </iiId>
                <iisnum> SNum </iisnum>
                <iivariables> IV </iivariables>
                <iivariablesId> IVId </iivariablesId>
            </istructInstance>)
         ...
    </contractInstance>
    requires SN >Int N

rule 
    <k> CopyGlobalStructIns(X,CI,SN,SN) => . ... </k>

//SimpleExpression1

rule ! T => notBool T
rule + I =>  I requires  I>=Int 0
rule + I => (-1) * I requires I<Int 0
rule - I => (-1) * I requires I>=Int 0
rule - I => I requires I<Int 0
       
rule <k> ++X => X = X + 1; ~> X ... </k>
rule <k> X++ => X = X + 1; ~> X - 1 ... </k>
    
rule <k> --X => X = X - 1; ~> X ... </k>
rule <k> X-- => X = X - 1; ~> X + 1 ... </k>

//SimpleExpression2

rule I1 < I2 => I1 <Int I2
rule I1 > I2 => I1 >Int I2
rule I1 <= I2 => I1 <=Int I2
rule I1 >= I2 => I1 >=Int I2

//SimpleExpression3
    
rule 
    <k> X:Id = I:Value => I ...</k>
    <contractStack> ListItem(-1) ... </contractStack>
    <env>... X |-> N ...</env>
    <store>... (N |-> V) => (N |->I) ...</store>  [assignment] 

rule 
    <k> X:Id = I => write(X,I) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0

rule 
    <k> write(X,I:String) => writeToAddress(N,String2Id(I),L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext>... X |-> N ...</ctContext>
        <ctType> ... X |-> string ... </ctType> 
        <ctLocation> ...  X |-> L ... </ctLocation>
        ...
    </contractInstance>

rule 
    <k> write(X,S:String) => writeToAddress(N,I,L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext>... X |-> N ...</ctContext>
        <ctType> ... X |-> T:Integer ... </ctType> 
        <ctLocation> ...  X |-> L ... </ctLocation>
        ...
    </contractInstance>
    <ASCII> ... S |-> I ... </ASCII>

rule 
    <k> write(X,S:String) => BytesAssign(X,Size,I,0) ~> 1 ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:Byte ... </ctType> 
        ...
    </contractInstance>
    <ASCII> ... S |-> I ... </ASCII>
    <stringSize> ... S |-> Size ... </stringSize>

rule 
    <k> write(X,I:Int) =>  X.length = CountByteLength(I,0); ~> BytesAssign(X,CountByteLength(I,0),I,0) ~> 1 ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:Bytes ... </ctType>
        ...
    </contractInstance>
    
rule 
    <k> write(X,I:Value) => /*writeToAddress(N,I,String2Id("Local"))*/ 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext>... X |-> N...</ctContext>
        <ctLocation> ...  X |-> String2Id("Local") ...</ctLocation>
        <ctType> ... X |-> T:NotByte ... </ctType>
        <Memory> ... (N |-> _) => (N |-> I) ...</Memory>
        ...
    </contractInstance>

rule 
    <k> write(X,I:Value) => /*writeToAddress(N,I,String2Id("Global"))*/ 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext>... X |-> N...</ctContext>
        <ctLocation> ...  X |-> String2Id("Global") ...</ctLocation>
        <ctType> ... X |-> T:NotByte ... </ctType> 
        <ctStore> ... (N |-> _) => (N |-> I) ...</ctStore>       
        ...
    </contractInstance>

rule 
    <k> writeToAddress(N,I,String2Id("Global")) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctStore> ... (N |-> _) => (N |-> I) ...</ctStore>
        ...
    </contractInstance>

rule 
    <k> writeToAddress(N,I,String2Id("Local")) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <Memory> ... (N |-> _) => (N |-> I) ...</Memory>
         ...
    </contractInstance>

rule X:Expression += Y:Expression => X=X + Y 
rule X:Expression -= Y:Expression => X=X - Y 
rule X:Expression *= Y:Expression => X=X * Y 
rule X:Expression /= Y:Expression => X=X / Y 
rule X:Expression %= Y:Expression => X=X % Y
rule X <<= Y => X= X *2^Int Y
rule X >>= Y => X= X /2^Int Y

// rule <k> X:Id => read(X) ...</k>
rule X:Id => read(X)
     
rule 
    <k> read(X:Id) => I ... </k>
    <contractStack> ListItem(-1) ... </contractStack>
    <env>... X |-> N ...</env>
    <store>... N |-> I ...</store>  [lookup] 

// TODO: this and the following rule looks exactly the same 
// (except for the "Global" and "Local" string). Do we need 
// to keep them? Why not using a single rule with a side contition?
// Or, if "Global" and "Local" represent all possibilities, why not 
// avoiding to match <ctLocation> altogether?
rule 
    <k> readAddress(N,String2Id("Global")) => I ... </k>
    <ctStore>... N |-> I ...</ctStore>

rule 
    <k> readAddress(N,String2Id("Local")) => I ... </k>
    <Memory>... N |-> I ...</Memory>

rule 
    <k> read(X:Id) => readAddress(N,L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext>... X |-> N ...</ctContext>
        <ctLocation> ...  X |-> L ...</ctLocation>
        <ctType> ... X |-> T:NotByte ... </ctType>
        ...
    </contractInstance>
    requires CI >=Int 0
/*
rule 
    <k> read(X:Id) => GetBytesValue(X,S,0,0) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:Byte </ctType>
        ...
    </contractInstance>
    <byteSize> ... T |-> S ... </byteSize>
    requires CI >=Int 0*/

rule 
    <k> read(X:Id) => GetBytesValue(X,I,0,0) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext>... X |-> N ...</ctContext>
        <ctStore>... N |-> I ...</ctStore>  
        <ctType> ... X |-> T:Byte </ctType>
        ...
    </contractInstance>
    requires CI >=Int 0

rule 
    <k> GetBytesValue(X,S,N,I) => GetBytesValue(X,S,N +Int 1,GetByteValue(X,S,N,I)) ... </k>
    requires S >Int N

rule 
    <k> GetBytesValue(X,S,S,I) => I ...</k>

rule 
    <k> GetByteValue(X,S,N,I) => I + X[N] * (100**(S- 1- N)) ... </k>

rule I1 * I2 => I1 *Int I2
rule I1 ** I2 => I1^Int I2
rule I1 % I2 => I1 %Int I2
rule I1 / I2 => I1 /Int I2  requires I2 =/=Int 0
rule I1 + I2 => I1 +Int I2
rule I1 - I2 => I1 -Int I2
rule Str1 + Str2 => Str1 +String Str2
rule  B << N => B *2^Int N
rule  B >> N => B /2^Int N  

rule I1 == I2 => I1 ==Int I2
rule B1 == B2 => B1 ==Bool B2
rule Str1 == Str2 => Str1 ==String Str2
rule I1 != I2 => notBool (I1 ==Int I2)
rule Str1 != Str2 => notBool(Str1 ==String Str2)
rule true && B => B
rule false && _ => false
rule B && true => B
rule B:Bool && false => false
rule true || B:Bool => true
rule false || B => B
rule B:Bool || true => true
rule B || false => B
rule true ? B:Expression : C:Expression => B  
rule false ? B:Expression : C:Expression => C    

//IndexAccess

rule 
    <k> X:IndexAccess => read(X) ... </k>

rule 
    <k> read(X:IndexAccess) => ArrayName(X,X) ... </k>

rule 
    <k> ArrayName(#indexAccess(X:IndexAccess,Y:Int),Z) => ArrayName(X,Z) ... </k>

rule 
    <k> ArrayName(#indexAccess(X:Id,Y),Z) => IdxAccess(X,Z,1,E) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ibaseaddress> ... X  |-> E ... </ibaseaddress>
        ...
    </contractInstance>
    
rule 
    <k> IdxAccess(X,A[Y:Int],N:Int,E) => IdxAccess(X,A,N +Int 1,BaseAddress(X,N,E,Y)) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
            <ctId> CI </ctId>
            <ctName> Name </ctName>
            <ctLocation> ... X  |-> String2Id("Local") ... </ctLocation>
            <iarray>
                <ianame> X </ianame>
                <idnum> Num </idnum>
                ...
            </iarray>
            ...
        </contractInstance> 
        requires N <Int Num 

rule 
    <k> IdxAccess(X,A[Y:Int],N:Int,E) => IdxAccess(X,A,N +Int 1,BaseAddress(X,N,E,Y)) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
        ...
    </contractInstance>     
    <Contract>
        <cname> Name </cname>
        <array>
            <aname> X </aname>
            <dnum> Num </dnum>
            ...
        </array>
        ...
    </Contract>
    requires N <Int Num 

rule 
    <k> IdxAccess(X,X[Y:Int],Num,E) => readIndexAddress(E +Int Y,L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ilength> ... X |-> L ... </ilength>
        ...
    </contractInstance>

rule 
    <k> readIndexAddress(A,0) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <idStore> ... A |-> I ...   </idStore>
         ...
    </contractInstance>

rule 
    <k> readIndexAddress(A,L) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctStore> ... A |-> I ...   </ctStore>
          ...
    </contractInstance>
    requires L >Int 0
   
rule 
    <k> BaseAddress(X,N,E,Y) => CntBaseSize(X,N,Y) + E ... </k>

rule 
    <k> CntBaseSize(X,N,S) => CntBaseSize(X,N +Int 1,S *Int Size) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctLocation> ... X  |-> String2Id("Local") ... </ctLocation>
        <iarray>
            <ianame> X </ianame>
            <idnum> Num </idnum>
            <idimensions> ... N +Int 1 |-> Size ... </idimensions>
            ...
        </iarray>
        ...
    </contractInstance>
    requires  N<Int Num

rule 
    <k> CntBaseSize(X,N,S) => CntBaseSize(X,N +Int 1,S *Int Size) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <array>
            <aname> X </aname>
            <dnum> Num </dnum>
            <dimensions> ... N +Int 1 |-> Size ... </dimensions>
            ...
        </array>
        ...
    </Contract>
    requires N <Int Num

rule 
    <k> CntBaseSize(X,Num,S) => S ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctLocation> ... X  |-> String2Id("Local") ... </ctLocation>
        <iarray>
            <ianame> X </ianame>
            <idnum> Num </idnum>
            ...
        </iarray>
        ...
    </contractInstance>

rule 
    <k> CntBaseSize(X,Num,S) => S ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
        ...
    </contractInstance>
    <Contract>
        <cname> Name </cname>
        <array>
            <aname> X </aname>
            <dnum> Num </dnum>
            ...
        </array>
        ...
    </Contract>

rule 
    <k> X:Id [Y:Expression] = I:Value => write(X[Y],I) ... </k>

rule 
    <k> write(X:IndexAccess,I) => ArrayNameW(X,X,I) ... </k>

rule 
    <k> ArrayNameW(X:IndexAccess [Y:Int],Z,I) => ArrayNameW(X,Z,I) ... </k>

rule 
    <k> ArrayNameW(X:Id [Y:Int],Z,I) => IdxWrite(X,Z,1,E,I) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
            <ctId> CI </ctId>
            <ctName> Name </ctName>
            <ibaseaddress> ... X  |-> E ... </ibaseaddress>
            ...
        </contractInstance>

rule 
    <k> IdxWrite(X,A[Y:Int],N:Int,E,I) => IdxWrite(X,A:IndexAccess,N +Int 1,BaseAddress(X,N,E,Y),I) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
            <ctId> CI </ctId>
            <ctName> Name </ctName>
            // <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
            ...
    </contractInstance>     
    
rule 
    <k> IdxWrite(X,X[Y:Int],Num,E,I) => WriteIndex(X,E +Int Y,I) ... </k>
    // rule <k> IdxWrite(X,X[Y:Int],Num,E,I) => WriteIndex(E +Int Y,I) ... </k>

// TODO: see rules for "read" - same comments applies here
rule 
    <k> WriteIndex(X,A,I) => writeIndexToAddress(A,I,L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ilength> ... X |-> L ... </ilength>
        ... 
    </contractInstance>

rule 
    <k> writeIndexToAddress(A,I,0) => I ... </k> 
    <idStore> ... (A |-> V) => (A |-> I) ...   </idStore>  

rule 
    <k> writeIndexToAddress(A,I,L) => I ... </k> 
    <ctStore> ... (A |-> V) => (A |-> I) ...   </ctStore> 
    requires L >Int 0
   
rule (X:Expression) => X
     
rule X:Id[Y:Int] += E:Expression => X[Y]= X[Y]+ E
rule X:Id[Y:Int] -= E:Expression => X[Y]= X[Y]- E
rule X:Id[Y:Int] %= E:Expression => X[Y]= X[Y]% E

//Msg

rule 
    <k> msg => M ... </k>
    <Msg> M:Msg </Msg>

rule 
    <k> msg.value => V ... </k>
    <Msg> msginfo(_,_,V,_) </Msg>

rule 
    <k> msg.value = I:Int => I ... </k>
    <Msg> msginfo(_,_,(_=> I),_) </Msg>

rule 
    <k> msg.gas => V ... </k>
    <Msg> msginfo(_,_,_,V) </Msg>

rule 
    <k> msg.gas = I:Int => I ... </k>
    <Msg> msginfo(_,_,_,(_=> I)) </Msg>

rule 
    <k> msg.sender => V ... </k>
    <Msg> msginfo(V,_,_,_) </Msg>

rule 
    <k> msg.sender = I:Int => I ... </k>
    <Msg> msginfo((_=> I),_,_,_) </Msg>

rule 
    <k> msg.owner => V ... </k>
    <Msg> msginfo(_,V,_,_) </Msg>

rule 
    <k> msg.owner = I:Int => I ... </k>
    <Msg> msginfo(_,(_=> I),_,_) </Msg>


//Setting length of one-dimensional dynamic array
    
//Local dynamic array

rule    
    <k> X:Id.length = I:Int => ArrayUpdate(1,CI,X,I) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... (E |-> V) => (E |-> I) ... </ctStore>
        <ibaseaddress> ... (X |-> _) => (X |-> !Num:Int) ... </ibaseaddress>
        <idStore> (.Map => !Num:Int |-> 0) ... </idStore>
        <ctLocation> ... X  |-> String2Id("Local") ... </ctLocation>
        <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
        ...
    </contractInstance>

rule    
    <k> X:Id.length => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <Memory> ... X |-> I ... </Memory>
        <ctLocation> ... X  |-> String2Id("Local") ... </ctLocation>
        ...
    </contractInstance>

//Global dynamic array

rule 
    <k> X:Id.length = I:Int => DArrayUpdate(1,CI,X,I) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... (E |-> V) => (E |-> I) ... </ctStore>
        <ibaseaddress> .Map => (X |-> !Num:Int) ... </ibaseaddress>
        <idStore> (.Map => !Num:Int |-> 0) ... </idStore>
        <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
        <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
        ...
    </contractInstance>

rule    
    <k> X:Id.length => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... E |-> I ... </ctStore>
        <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
        ...
    </contractInstance>

rule 
    <k> ArrayUpdate(Ins,CI,X,I) => InstanceUpdate(Ins,CI,X,I) ~> ArrayUpdate(Ins+Int 1,CI,X,I) ... </k>
    requires Ins<Int I

rule 
    <k> ArrayUpdate(I,CI,X,I) => 1 ... </k>

rule 
    <k> InstanceUpdate(Ins,CI,X,I) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <idStore> (.Map => !Num:Int |-> 0)... </idStore>
        ...
    </contractInstance> 
    requires Ins>Int 0 

rule
    <k> DArrayUpdate(Ins,CI,X,I) => DInstanceUpdate(Ins,CI,X,I) ~> DArrayUpdate(Ins+Int 1,CI,X,I) ... </k>
    requires Ins<Int I

rule 
    <k> DArrayUpdate(I,CI,X,I) => 1 ... </k>

rule 
    <k> DInstanceUpdate(Ins,CI,X,I) => . ... </k>
    <contractInstance>
        <ctId> CI </ctId>
        <idStore> (.Map => !Num:Int |-> 0)... </idStore>
        ...
    </contractInstance> 
    requires Ins>Int 0 

//Dynamic struct instance

rule 
    <k> X:Id.length = I:Int => CreateStructInstance(X,I,0) ~> ResetStructSize(X,I) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> C </ctName>
        <ctType> ... X |-> "struct" ... </ctType>
        ...
    </contractInstance>
    
rule 
    <k> ResetStructSize(X,I) => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... (E |->_) => (E |-> I) ... </ctStore>
        <ctLocation> ... X |-> String2Id("Global") ... </ctLocation>
        ...
    </contractInstance>

rule 
    <k> ResetStructSize(X,I) => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <Memory> ... (E |->_) => (E |-> I) ... </Memory>
        <ctLocation> ... X |-> String2Id("Local") ... </ctLocation>
        ...
    </contractInstance>

rule 
    <k> CreateStructInstance(X,I,N) => Y:Id .StorageLocations !D:Id; ~> CreateStructInstance(X,I,N +Int 1) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <istructInstance>
            <istructName> Y </istructName>
            <iiname> X </iiname>
            <iivariables> (.Map => N |-> !D)... </iivariables>
            ...
        </istructInstance>
        ...
    </contractInstance>
    requires I >Int N
      
rule 
    <k> CreateStructInstance(X,I,I) => . ... </k>

//Push

rule [push-memory-existing]: 
    <k> X:Id.push(Y:Int) => E +Int 1 ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <Memory> ... (X |-> E) => (X |-> E +Int 1) ... </Memory>
        <ctStore> ... (A +Int E |-> _) => (A +Int E |->Y)... </ctStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> N ...</ilength>
        ...
    </contractInstance>
    requires N >Int 0

rule [push-memory-new]:
    <k> X:Id.push(Y:Int) => E +Int 1 ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <Memory> ... (X |-> E) => (X |-> E +Int 1) ... </Memory>
        <ctStore> (.Map => A +Int E |-> Y) Rho:Map </ctStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> N ...</ilength>
        ...
    </contractInstance>
    requires (N >Int 0) andBool (notBool ((A +Int E) in keys(Rho)))

// ***

rule [push-store-N-existing]: 
    <k> X:Id.push(Y:Int) => S+Int 1 ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... ((E |-> S) => (E |-> S+Int 1)) ((A +Int S |-> _) => (A +Int S |-> Y)) ... </ctStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> N ...</ilength>
        ...
    </contractInstance>
    requires N >Int 0

rule [push-store-N-new]:
    <k> X:Id.push(Y:Int) => S+Int 1 ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ((E |-> S) => (E |-> S +Int 1)) (.Map => A +Int S |-> Y) Rho:Map </ctStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> N ...</ilength>
        ...
    </contractInstance>
    requires (N >Int 0) andBool (notBool ((A +Int S) in keys(Rho)))

// ***

rule [push-store-N0-existing]:
    <k> X:Id.push(Y:Int) => S+Int 1 ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... (E |-> S) => (E |-> S +Int 1) ... </ctStore> 
        <idStore> ... (A +Int S |-> _) => (A +Int S |-> Y) ... </idStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X|-> 0 ... </ilength>
        ...
    </contractInstance>

rule [push-store-N0-new]:
    <k> X:Id.push(Y:Int) => S+Int 1 ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... (E |-> S) => (E |-> S +Int 1) ... </ctStore>
        <idStore> (.Map => A +Int S |-> Y) Rho:Map </idStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X|-> 0 ... </ilength>
        ...
    </contractInstance>
    requires notBool ((A +Int S) in keys(Rho))

rule [push-store-N0-new-dynamic]:
    <k> X:Id.push(Y:Int) => S+Int 1 ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... (E |-> S) => (E |-> S +Int 1) ... </ctStore>
        <idStore> (.Map => !N:Int |-> Y) Rho:Map </idStore>
        <ibaseaddress> (.Map => X |-> !N) Rho1:Map </ibaseaddress>
        <ilength> ... X|-> 0 ... </ilength>
        ...
    </contractInstance>
    requires notBool ((!N in keys(Rho)) andBool (X in keys(Rho1)))

//Bitwise operations

rule 
    <k> X & Y => BinaryConvert(X,X) ~> BinaryConvert(Y,Y) ~> BitAnd(Max(X,Y),Min(X,Y)) ... </k>
    (.Bag => 
        <binaryConversion>
            <decimal> X </decimal>
            ...
        </binaryConversion>)
    (.Bag => 
        <binaryConversion>
            <decimal> Y </decimal>
            ...
       </binaryConversion>)

rule 
    <k> X | Y => BinaryConvert(X,X) ~> BinaryConvert(Y,Y) ~> BitOr(Max(X,Y),Min(X,Y))... </k>
    (.Bag => 
        <binaryConversion>
            <decimal> X </decimal>
            ...
        </binaryConversion>)
    (.Bag => 
        <binaryConversion>
            <decimal> Y </decimal>
            ...
        </binaryConversion>)

rule 
    <k> X ^ Y => BinaryConvert(X,X) ~> BinaryConvert(Y,Y) ~> BitExOr(Max(X,Y),Min(X,Y))... </k>
    (.Bag => 
        <binaryConversion>
            <decimal> X </decimal>
            ...
            </binaryConversion>)
    (.Bag => 
        <binaryConversion>
            <decimal> Y </decimal>
            ...
        </binaryConversion>)

rule 
    <k> ~ X => (2**S) - X - 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> Y:Uint ... </ctType>
        ...
    </contractInstance>
    <uintSize> ... Y |-> S ... </uintSize>

rule 
    <k> ~ X:Id =>  (-1)* X - 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:SInt ... </ctType>
        ...
    </contractInstance>

rule 
    <k> ~ X:Int =>  (-1)* X - 1 ... </k>
    
rule 
    <k> BitAnd(X,Y) => BitAndSteps(X,Y,N -Int 1) ... </k>
    <binaryConversion>
        <decimal> Y </decimal>
        <digitNum> N </digitNum>
        ...
    </binaryConversion>
            
rule 
    <k> BitAndSteps(X,Y,N) => BitAndStep(X,Y,N) ~> BitAndSteps(X,Y,N -Int 1) ... </k>
    requires N >=Int 0

rule 
    <k> BitAndSteps(X,Y,-1) => DecimalConversions(Y,0) ~> GetValue(Y)... </k>

rule 
    <k> BitOr(X,Y) => BitOrSteps(X,Y,N -Int 1) ... </k>
    <binaryConversion>
        <decimal> Y </decimal>
        <digitNum> N </digitNum>
        ...
    </binaryConversion>

rule 
    <k> BitOrSteps(X,Y,N) => BitOrStep(X,Y,N) ~> BitOrSteps(X,Y,N -Int 1) ... </k>
    requires N >=Int 0

rule 
    <k> BitOrSteps(X,Y,-1) => DecimalConversions(X,0) ~> GetValue(X)... </k>

rule 
    <k> BitExOr(X,Y) => BitExOrSteps(X,Y,N -Int 1) ... </k>
    <binaryConversion>
        <decimal> Y </decimal>
        <digitNum> N </digitNum>
        ...
    </binaryConversion>

rule 
    <k> BitExOrSteps(X,Y,N) => BitExOrStep(X,Y,N) ~> BitExOrSteps(X,Y,N -Int 1) ... </k>
    requires N >=Int 0

rule 
    <k> BitExOrSteps(X,Y,-1) => DecimalConversions(X,0) ~> GetValue(X)... </k>

rule 
    <k> GetValue(Y) => I ... </k>
    <binaryConversion>
        <decimal> Y </decimal>
        <binary> I </binary>
        ...
    </binaryConversion>

rule 
    <k> DecimalConversions(Y,N) => DecimalConversion(Y,N) ~> DecimalConversions(Y,N +Int 1)... </k>
    <binaryConversion>
        <decimal> Y </decimal>
        <digitNum> Num </digitNum>
        ...
    </binaryConversion>
    requires N <Int Num

rule 
    <k> DecimalConversions(Y,Num) => . ... </k>
    <binaryConversion>
        <decimal> Y </decimal>
        <digitNum> Num </digitNum>
        ...
    </binaryConversion>
       
rule 
    <k> DecimalConversion(Y,N) => BinaryValue(Y,B+I*(2**N)) ... </k>
    <binaryConversion>
        <decimal> Y </decimal>
        <digits> ... N  |-> I ... </digits>
        <binary> B </binary>
        ...
    </binaryConversion>

rule 
    <k> BinaryValue(Y,I) => . ... </k>
    <binaryConversion>
        <decimal> Y </decimal>
        <binary> _=>I </binary>
        ...
    </binaryConversion>

rule 
    <k> BitAndStep(X,Y,N) => . ... </k>
    <binaryConversion>
        <decimal> X </decimal>
        <digits> ...N |-> Bx ... </digits>
        ...
    </binaryConversion>
    <binaryConversion>
        <decimal> Y </decimal>
        <digits> ...(N |-> By) => (N |-> 1) ... </digits>
        ...
    </binaryConversion>
    requires Bx ==Int 1 andBool By ==Int 1

rule 
    <k> BitAndStep(X,Y,N) => . ... </k>
    <binaryConversion>
        <decimal> X </decimal>
        <digits> ...N |-> Bx  ... </digits>
        ...
    </binaryConversion>
    <binaryConversion>
        <decimal> Y </decimal>
        <digits> ...(N |-> By) => (N |-> 0) ... </digits>
        ...
    </binaryConversion>
    requires notBool (Bx ==Int 1 andBool By ==Int 1)
       
rule 
    <k> BitOrStep(X,Y,N) => . ... </k>
    <binaryConversion>
        <decimal> X </decimal>
        <digits> ...(N |-> Bx) => (N |-> 1) ... </digits>
        ...
    </binaryConversion>
    <binaryConversion>
        <decimal> Y </decimal>
        <digits> ...N |-> By ... </digits>
        ...
    </binaryConversion>
    requires Bx ==Int 1 orBool By ==Int 1

rule 
    <k> BitOrStep(X,Y,N) => . ... </k>
    <binaryConversion>
        <decimal> X </decimal>
        <digits> ...(N |-> Bx) =>(N |-> 0)  ... </digits>
        ...
    </binaryConversion>
    <binaryConversion>
        <decimal> Y </decimal>
        <digits> ...N |-> By  ... </digits>
        ...
    </binaryConversion>
    requires notBool (Bx ==Int 1 orBool By ==Int 1)

rule 
    <k> BitExOrStep(X,Y,N) => . ... </k>
    <binaryConversion>
        <decimal> X </decimal>
        <digits> ...(N |-> Bx) => (N |-> 1) ... </digits>
        ...
    </binaryConversion>
    <binaryConversion>
        <decimal> Y </decimal>
        <digits> ...N |-> By ... </digits>
       ...
    </binaryConversion>
    requires notBool (Bx ==Int By)

rule 
    <k> BitExOrStep(X,Y,N) => . ... </k>
    <binaryConversion>
        <decimal> X </decimal>
        <digits> ...(N |-> Bx) =>(N |-> 0)  ... </digits>
        ...
    </binaryConversion>
    <binaryConversion>
        <decimal> Y </decimal>
        <digits> ...N |-> By  ... </digits>
        ...
    </binaryConversion>
    requires Bx ==Int By

rule 
    <k> BinaryConvert(Y,X:Int)=> ModValue(Y,X%2) ~> BinaryConvert(Y,X/2) ... </k>
    requires X >Int 0

rule 
    <k> BinaryConvert(X,0) => . ... </k>

rule 
    <k> ModValue(X:Int,Y:Int) => . ... </k>
    <binaryConversion>
        <decimal> X </decimal>
        <digitNum> N:Int => N +Int 1 </digitNum>
        <digits> (.Map => N |-> Y) ... </digits>
        ...
    </binaryConversion>

rule [max-first]:
    <k> Max(X,Y) => X ... </k> 
    requires X >=Int Y

rule [max-second]:
    <k> Max(X,Y) => Y ... </k>
    requires X <Int Y

rule [min-second]:
    <k> Min(X,Y) => Y ... </k> 
    requires X >=Int Y

rule [min-first]:
    <k> Min(X,Y) => X ... </k>
    requires X <Int Y

rule 
    <k> T:ElementaryTypeName (I:Int) => I ...</k>

rule 
    <k> T:ElementaryTypeName (I:Int,.Values) => T(I) ... </k>

//delete

//delete elementary type name

rule 
    <k> delete X => write(X,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:NotBoolByte ... </ctType>
        <ilength> Rho </ilength>
        ...
    </contractInstance>
    requires notBool(X in keys(Rho))

rule 
    <k> delete X => write(X,false) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:SBool ... </ctType>
        <ilength> Rho </ilength>
        ...
    </contractInstance>
    requires notBool(X in keys(Rho))

//delete index access

rule 
    <k> delete X:IndexAccess => CheckIndexType(X,X,0) ... </k>

rule 
    <k> CheckIndexType(#indexAccess(X:IndexAccess,Y),Z,E) => CheckIndexType(X,Z,E) ...</k>

rule
    <k> CheckIndexType(#indexAccess(X:Id,Y),Z,E) => write(Z,0) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:NotBoolByte ... </ctType>
        ...
    </contractInstance>

rule
    <k> CheckIndexType(#indexAccess(X:Id,Y),Z,E) => write(Z,false) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:SBool ... </ctType>
        ...
    </contractInstance>

rule
    <k> CheckIndexType(#indexAccess(X:Id,Y),Z,E) => write(Z,0) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... (X |-> "struct")(A |-> T:NotBoolByte) ... </ctType>
        <iivariables> ... E |-> A ... </iivariables>
        ...
    </contractInstance>

rule
    <k> CheckIndexType(#indexAccess(X:Id,Y),Z,E) => write(Z,false) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... (X |-> "struct")(A |-> T:SBool) ... </ctType>
        <iivariables> ... E |-> A ... </iivariables>
        ...
    </contractInstance>

//delete member access

rule 
    <k> delete X:MemberAccess => CheckMemberType(X,X) ... </k>

rule 
    <k> CheckMemberType(#memberAccess(X:MemberAccess,Y),Z) => CheckMemberType(X,Z) ...</k>

rule 
    <k> CheckMemberType(#memberAccess(X:IndexAccess,Y),Z) => CheckIndexType(X,Z,Y) ...</k>

rule
    <k> CheckMemberType(#memberAccess(X:Id,Y),Z) => write(Z,0) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:NotBoolByte ... </ctType>
        ...
    </contractInstance>

rule
    <k> CheckMemberType(#memberAccess(X:Id,Y),Z) => write(Z,false) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:SBool ... </ctType>
        ...
    </contractInstance>

//delete fixed size array

rule 
    <k> delete X => ArrayReset(X,I) ~> 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> N ... </ctContext>
        <ctStore> ... N |-> I ... </ctStore>
        <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> Len ... </ilength>
        ...
    </contractInstance>
    requires Len >Int 0

//delete dynamic array

rule 
    <k> delete X => DeleteIndexes(X,I,0) ~> 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> N ... </ctContext>
        <ctStore> ... N |-> I ... </ctStore>
        <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
        <ilength> ... X |-> 0 ... </ilength>
        ...
    </contractInstance>

rule 
    <k> DeleteIndexes(X,I,N) => DeleteIndex(X,I,N) ~> DeleteIndexes(X,I,N +Int 1) ...</k>
    requires I >Int N
  
rule
    <k> DeleteIndex(X,I,N) => . ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <idStore> ... (A +Int N |-> V) => .Map ... </idStore>
        ...
    </contractInstance>

rule 
    <k> DeleteIndexes(X,I,I) => . ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ibaseaddress> ... (X |-> A) => .Map ... </ibaseaddress>
        ...
    </contractInstance>
    requires I >Int 0

rule 
    <k> DeleteIndexes(X,0,0) => . ... </k>

rule 
    <k> ArrayReset(X,N)=> IndexReset(X,N -Int 1) ~> ArrayReset(X,N -Int 1) ... </k>
    requires N >=Int 1

rule 
    <k> ArrayReset(X,0) => . ... </k>

rule 
    <k> IndexReset(X,N) => X[N]=0; ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:NotBoolByte ... </ctType>
        ...
    </contractInstance>

rule 
    <k> IndexReset(X,N) => X[N]=false; ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:SBool ... </ctType>
        ...
    </contractInstance>

rule 
    <k> IndexReset(X,N) => X[N]=0; ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctType> ... X |-> T:Byte ... </ctType>
        ...
    </contractInstance>

//Delete struct instance

//delete fixed size one dimensional struct instance

rule 
    <k> delete X => DeleteFixedStruct(X,I,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> N ... </ctContext>
        <ctStore> ... N |-> I ... </ctStore>
        <ctType> ... X |-> "struct" ... </ctType>
        <ctLocation> ... X |-> String2Id("Global") ... </ctLocation>
        <ilength> ... X |-> 1 ... </ilength>
        ...
    </contractInstance>

rule 
    <k> DeleteFixedStruct(X,I,N) => delete Ins; ~> DeleteFixedStruct(X,I,N +Int 1) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <istructInstance>
            <iiname> X </iiname>
            <iivariables> ... Var |-> Ins ... </iivariables>
            <iivariablesId> ... N |-> Var ... </iivariablesId>
            ...
        </istructInstance>
        ...
    </contractInstance>
    requires I >Int N

rule 
    <k> DeleteFixedStruct(X,I,I) => 1 ...</k>

//delete fixed size multi-dimensional struct instance

rule 
    <k> delete X => DeleteFixedMulDStruct(X,I,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> N ... </ctContext>
        <ctStore> ... N |-> I ... </ctStore>
        <ctType> ... X |-> "struct" ... </ctType>
        <ctLocation> ... X |-> String2Id("Global") ... </ctLocation>
        <ilength> ... X |-> Len ... </ilength>
        ...
     </contractInstance>
     requires Len >Int 1

rule
    <k> DeleteFixedMulDStruct(X,I,N) => DeleteFixedMulDStructIns(Ins,Num,0) ~> DeleteFixedMulDStruct(X,I,N +Int 1) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... Ins |-> A ...</ctContext>
        <ctStore> ... A |-> Num... </ctStore>
        //<ctvId> ... (_ |-> Ins) => .Map ... </ctvId>
        <ctType> ... Ins |-> "struct" ... </ctType>
        <ctLocation> ... Ins |-> String2Id("Global") ... </ctLocation>
        <istructInstance>
            <iiname> X </iiname>
            <iivariables> ... N |-> Ins ... </iivariables>
            ...
        </istructInstance>
        ...
     </contractInstance> 
     requires I >Int N

rule
    <k> DeleteFixedMulDStruct(X,I,I) => 1 ... </k>

rule
    <k> DeleteFixedMulDStructIns(Ins,Num,N) => delete InsId; ~> DeleteFixedMulDStructIns(Ins,Num,N +Int 1) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <istructInstance>
            <iiname> Ins </iiname>
            <iivariablesId> ... N |-> Var ... </iivariablesId>
            <iivariables> ... Var |-> InsId ... </iivariables>
            ...
        </istructInstance>
        ...
    </contractInstance>
    requires Num >Int N

rule
    <k> DeleteFixedMulDStructIns(Ins,Num,Num) => . ...</k>
     
//delete dynamic struct instance      

rule <k> delete X => DeleteDynamicStruct(X,I,0) ... </k>
     <contractStack> ListItem(CI:Int) ... </contractStack>
     <contractInstance>
         <ctId> CI </ctId>
         <ctContext> ... X |-> N ... </ctContext>
         <ctStore> ... (N |-> I) => (N |-> 0)... </ctStore>
         <ctType> ... X |-> "struct" ... </ctType>
         <ctLocation> ... X |-> String2Id("Global") ... </ctLocation>
         <ilength> ... X |-> 0 ... </ilength>
         ...
     </contractInstance>

rule 
    <k> DeleteDynamicStruct(X,I,N) => DeleteDynamicStructStep(X,I,N) ~> DeleteDynamicStruct(X,I,N +Int 1) ... </k>
    requires I >Int N

rule 
    <k> DeleteDynamicStructStep(X,I,N) => DeleteDynamicStructIns(Ins,Num,0) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... (Ins |-> A) => .Map ...</ctContext>
        <ctStore> ... (A |-> Num)=> .Map ... </ctStore>
      //<ctvId> ... (_ |-> Ins) => .Map ... </ctvId>
        <ctType> ... (Ins |-> "struct") => .Map ... </ctType>
        <ctLocation> ... (Ins |-> String2Id("Global")) => .Map ... </ctLocation>
        <istructInstance>
            <iiname> X </iiname>
            <iivariables> ... (N |-> Ins) => .Map ... </iivariables>
            ...
        </istructInstance>
        ...
    </contractInstance> 

rule <k> DeleteDynamicStructStep(X,I,N) => DeleteDynamicStructIns(Ins,Num,0) ... </k>
     <contractStack> ListItem(CI:Int) ... </contractStack>
     <contractInstance>
         <ctId> CI </ctId>
         <ctContext> ... (Ins |-> A) => .Map ...</ctContext>
         <Memory> ... (A |-> Num)=> .Map ... </Memory>
         //<ctvId> ... (_ |-> Ins) => .Map ... </ctvId>
         <ctType> ... (Ins |-> "struct") => .Map ... </ctType>
         <ctLocation> ... (Ins |-> String2Id("Local")) => .Map ... </ctLocation>
         <istructInstance>
             <iiname> X </iiname>
             <iivariables> ... (N |-> Ins) => .Map ... </iivariables>
             ...
         </istructInstance>
         ...
     </contractInstance>

rule 
    <k> DeleteDynamicStruct(X,I,I) => 1 ... </k>
     
rule 
    <k> DeleteDynamicStructIns(Ins,Num,N)=> DeleteDynamicStructInsStep(Ins,Num,N) ~> DeleteDynamicStructIns(Ins,Num,N +Int 1) ...</k>
    requires Num >Int N

//delete elementary type member in struct instance

rule 
    <k> DeleteDynamicStructInsStep(Ins,Num,N) => . ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ...(InsId |-> A) => .Map ... </ctContext>
        <Memory> ...(A |-> V)=> .Map ... </Memory>
        // <ctvId> ... (Id |-> InsId) => .Map ... </ctvId>
        <ctType> ... (InsId |-> T) => .Map ... </ctType>
        <ctLocation> ... (InsId |-> String2Id("Local")) => .Map ... </ctLocation>
        <istructInstance>
            <iiname> Ins </iiname>
            <iivariablesId> ... (N |-> Var) => .Map ... </iivariablesId>
            <iivariables> ... (Var |-> InsId) => .Map ... </iivariables>
            ...
        </istructInstance>
        <ilength> Rho </ilength>
        ...
    </contractInstance> 
    requires notBool(InsId in keys(Rho))

//delete dynamic array member in struct instance

rule 
    <k> DeleteDynamicStructInsStep(Ins,Num,N) => . ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ...(InsId |-> A) => .Map ... </ctContext>
        <ctStore> ...(A |-> V) => (A |-> 0)... </ctStore>
        // <ctvId> ... (Id |-> InsId) => .Map ... </ctvId>
        <ctType> ... (InsId |-> T) => .Map ... </ctType>
        <ctLocation> ... (InsId |-> String2Id("Local")) => .Map ... </ctLocation>
        <istructInstance>
            <iiname> Ins </iiname>
            <iivariablesId> ... (N |-> Var) => .Map ... </iivariablesId>
            <iivariables> ... (Var |-> InsId) => .Map ... </iivariables>
            ...
        </istructInstance>
        <ibaseaddress> ... (InsId |-> Add) => .Map ... </ibaseaddress>
        <ilength> ... (InsId |-> 0) => .Map ...</ilength>
        <ivdim> ...(InsId |-> Dim) => .Map ... </ivdim>
        ...
    </contractInstance> 

//delete fixed size array member in struct instance

rule 
    <k> DeleteDynamicStructInsStep(Ins,Num,N) => . ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ...(InsId |-> A) => .Map ... </ctContext>
        <Memory> ...(A |-> V)=> .Map ... </Memory>
        // <ctvId> ... (Id |-> InsId) => .Map ... </ctvId>
        <ctType> ... (InsId |-> T) => .Map ... </ctType>
        <ctLocation> ... (InsId |-> String2Id("Local")) => .Map ... </ctLocation>
        <istructInstance>
            <iiname> Ins </iiname>
            <iivariablesId> ... (N |-> Var) => .Map ... </iivariablesId>
            <iivariables> ... (Var |-> InsId) => .Map ... </iivariables>
            ...
        </istructInstance>
        <ilength> ... (InsId |-> Len) => .Map ...</ilength>
        <ibaseaddress> ... (InsId |-> Add) => .Map ... </ibaseaddress>
        <ivdim> ...(InsId |-> Dim) => .Map ... </ivdim>
        ...
    </contractInstance> 
    requires Len >Int 0

rule 
    <k> DeleteDynamicStructIns(Ins,Num,Num) => ReduceStructInsNum(CI) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>  
        <ctId> CI </ctId>
        <ilength> ... (Ins |-> L) => .Map ... </ilength>
        <istructinstances>
            (<istructInstance>
                <iiname> Ins </iiname>
                ...
            </istructInstance>) => .Bag
            ...
        </istructinstances>
        ...
    </contractInstance> 

rule 
    <k> ReduceStructInsNum(CI) => . ... </k>
    <contractInstance>  
        <ctId> CI </ctId>
        <icntStructInstance> N1:Int => N1 -Int 1 </icntStructInstance>
        ...
    </contractInstance> 

rule 
    <k> CountByteLength(I,N) => CountByteLength(I /Int 100,N +Int 1) ... </k>
    requires I >Int 0

rule 
    <k> CountByteLength(0,N) => N ... </k>

       

endmodule
