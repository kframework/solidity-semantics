requires "solidity-syntax.k"
requires "configuration.k"

module STATEMENT

imports SOLIDITY-SYNTAX
imports CONFIGURATION

// Member Access

// rule <k> #assign1(#memberAccess(X:Id,Y:Id), I:Value)  => write(#memberAccess(X:Id,Y:Id), I:Value)  ... </k>
rule #assign1(#memberAccess(X:Id,Y:Id), I:Value)  => write(#memberAccess(X:Id,Y:Id), I:Value)

rule 
    <k> write(#memberAccess(X:Id,Y:Id), I:Value)   => 1 ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctContext> ... D |-> E ... </ctContext>
        <ctStore> ... E |-> (_=> I) ... </ctStore>
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

// rule <k> #memberAccess(X:Id, Y:Id)  => read(#memberAccess(X:Id, Y:Id)) ... </k>
rule #memberAccess(X:Id, Y:Id)  => read(#memberAccess(X:Id, Y:Id))

rule 
    <k> read(#memberAccess(X:Id, Y:Id)) => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctContext> ... D |-> E ... </ctContext>
        <ctStore> ... E |-> I ... </ctStore>
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

    // rule <k> #assign1(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  => write(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  ... </k>
    rule #assign1(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  => write(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)

    rule 
        <k> write(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  => 1 ... </k>
        <contractStack> ListItem(CI:Int) ... </contractStack>
        <contractInstance>
            <ctId> CI </ctId>
            <ctName> Name </ctName>
            <ctContext> ... D |-> S ... </ctContext>
            <ctStore> ... S+Int Z+Int 1|-> (_=> I)... </ctStore>
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

// rule <k> #indexAccess(#memberAccess(X:Id, Y:Id), Z:Int)  => read(#indexAccess(#memberAccess(X:Id, Y:Id), Z:Int))  ... </k>
rule #indexAccess(#memberAccess(X:Id, Y:Id), Z:Int)  => read(#indexAccess(#memberAccess(X:Id, Y:Id), Z:Int))

rule
    <k> read(#indexAccess(#memberAccess(X:Id, Y:Id), Z:Int))  => I ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctContext> ... D |-> S ... </ctContext>
        <ctStore> ... S+Int Z +Int 1|-> I... </ctStore>
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
    <k> for (A;B;C) S:OtherStatements => A; while (B) {S C;} ... </k> 

rule 
    <k> for (A;.ExpressionList;C) S:OtherStatements => A; while (true) {S C;} ... </k>

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
    <k> while (B) S:OtherStatements => if (B) {S while (B) S} else {.Statements} ... </k> 

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
    <k> new X:Id (E:ExpressionList) => CallConstructor(X,N,Cst,E) ... </k>
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
        <Length> L </Length>
        <baseAddress> B </baseAddress>
        <constructor> Cst </constructor>
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

//SimpleExpression1

rule ! T => notBool T
rule + I =>  I requires  I>=Int 0
rule + I => (-1) * I requires I<Int 0
rule - I => (-1) * I requires I>=Int 0
rule - I => I requires I<Int 0
       
rule <k> ++X => X = X + 1; ~>X ... </k>
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
    <k> X:Id = I:Value => write(X,I) ...</k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    requires CI>=Int 0
    
rule 
    <k> write(X,I) => writeToAddress(N,I,L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext>... X |-> N...</ctContext>
        <ctLocation> ...  X |-> L ...</ctLocation>
        <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
        ...
    </contractInstance>

rule 
    <k> writeToAddress(N,I,String2Id("Global")) => I ... </k>
    <ctStore> ... (N |-> _) => (N |->I) ...</ctStore>

rule 
    <k> writeToAddress(N,I,String2Id("Local")) => I ... </k>
    <Memory>... (N |-> _) => (N |-> I) ...</Memory>

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
        <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
        ...
    </contractInstance>
    requires CI >=Int 0


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
    <k> ArrayName(X:IndexAccess [Y:Int],Z) => ArrayName(X,Z) ... </k>

rule 
    <k> ArrayName(#indexAccess(X,Y),Z) => IdxAccess(X,Z,1,E) ... </k>
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
    requires N<Int Num 
 
rule 
    <k> IdxAccess(X,X[Y:Int],Num,E) => readIndexAddress(E +Int Y,L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ilength> ... X |-> L ... </ilength>
        ...
    </contractInstance>

rule 
    <k> readIndexAddress(A,0) => I ... </k>
    <idStore> ... A |-> I ...   </idStore>

rule 
    <k> readIndexAddress(A,L) => I ... </k>
    <ctStore> ... A |-> I ...   </ctStore>
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
    requires  N<Int Num

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
    <k> IdxWrite(X,X[Y:Int],Num,E,I) => WriteIndex(E +Int Y,I) ... </k>
    // rule <k> IdxWrite(X,X[Y:Int],Num,E,I) => WriteIndex(E +Int Y,I) ... </k>

// TODO: see rules for "read" - same comments applies here
rule 
    <k> WriteIndex(A,I) => writeIndexToAddress(A,I,L) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Name </ctName>
        <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
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
   
// rule <k> (X:Expression) => X ... </k>   
rule (X:Expression) => X
     
rule X:Id[Y:Int] += E:Expression => X[Y]= X[Y]+ E
rule X:Id[Y:Int] -= E:Expression => X[Y]= X[Y]- E
rule X:Id[Y:Int] %= E:Expression => X[Y]= X[Y]% E


//Msg


rule 
    <k> msg.value => V ... </k>
    <Msg> msginfo(_,_,V,_) </Msg>

rule 
    <k> msg.gas => V ... </k>
    <Msg> msginfo(_,_,_,V) </Msg>

rule 
    <k> msg.sender => V ... </k>
    <Msg> msginfo(V,_,_,_) </Msg>


rule 
    <k> msg.owner => V ... </k>
    <Msg> msginfo(_,V,_,_) </Msg>

rule 
    <k> msg.sender = I:Int => I ... </k>
    <Msg> msginfo((_=> I),_,_,_) </Msg>

rule 
    <k> msg.owner = I:Int => I ... </k>
    <Msg> msginfo(_,(_=> I),_,_) </Msg>

rule 
    <k> msg.value = I:Int => I ... </k>
    <Msg> msginfo(_,_,(_=> I),_) </Msg>

rule 
    <k> msg.gas = I:Int => I ... </k>
    <Msg> msginfo(_,_,_,(_=> I)) </Msg>

rule 
    <k> msg => M ... </k>
    <Msg> M:Msg </Msg>

//Setting length of one-dimensional dynamic array
    
//Local dynamic array

rule    
    <k> X:Id.length = I:Int => ArrayUpdate(1,CI,X,I) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... (E |-> V) => (E |-> I) ... </ctStore>
        <ibaseaddress> ... X |-> (_=>!Num:Int) ... </ibaseaddress>
        <idStore> (.Map => !Num:Int |-> 0) ... </idStore>
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
        <ibaseaddress> (.Map => X |-> !Num:Int) ... </ibaseaddress>
        <idStore> (.Map => !Num:Int |-> 0) ... </idStore>
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

//Push

rule 
    <k> X:Id.push(Y:Int); => . ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <Memory> ... X |-> (E=>E+Int 1) ... </Memory>
        <ctStore> ... (A +Int E |->(_=> Y))... </ctStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> N ...</ilength>
        ...
    </contractInstance>
    requires N>Int 0

rule 
    <k> X:Id.push(Y:Int); => . ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <Memory> ... X |-> (E=>E+Int 1) ... </Memory>
        <ctStore> (.Map => A +Int E |-> Y)... </ctStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> N ...</ilength>
        ...
    </contractInstance>
    requires N >Int 0

rule 
    <k> X:Id.push(Y:Int); => . ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... E |-> (S => S+Int 1) (A +Int S |->(_=> Y))... </ctStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> N ...</ilength>
        ...
    </contractInstance>
    requires N >Int 0

// TODO: lots of duplication in this and other rules. Can we refactor?
rule 
    <k> X:Id.push(Y:Int); => . ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... E |-> (S => S+Int 1) ... </ctStore>
        <idStore> ... (A +Int S |->(_=> Y))  ... </idStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X|-> 0 ...</ilength>
        ...
    </contractInstance>

rule    
    <k> X:Id.push(Y:Int); => . ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... E |-> (S => S+Int 1) ... </ctStore>
        <idStore> ... (.Map => A +Int S |-> Y)  ... </idStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength>... X|-> 0 ...</ilength>
        ...
    </contractInstance>

rule 
    <k> X:Id.push(Y:Int); => . ... </k> 
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> ... X |-> E ... </ctContext>
        <ctStore> ... E |-> (S => S+Int 1) (.Map => A +Int S |-> Y)... </ctStore>
        <ibaseaddress> ... X |-> A ... </ibaseaddress>
        <ilength> ... X |-> N ...</ilength>
        ...
    </contractInstance>
    requires N>Int 0

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

endmodule

