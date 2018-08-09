
requires "solidity-syntax.k"
requires "configuration.k"


module STATEMENT

imports SOLIDITY-SYNTAX
imports CONFIGURATION

// Member Access

    rule <k> #assign1(#memberAccess(X:Id,Y:Id), I:Value)  => write(#memberAccess(X:Id,Y:Id), I:Value)  ... </k>
       

     rule <k> write(#memberAccess(X:Id,Y:Id), I:Value)   => 1 ... </k>
         
         <contractStack> ListItem(CI:Int) ... </contractStack>
          <contractInstance>
            <ctId> CI </ctId>
            <ctname> Name </ctname>
            <ctContext> ... D |-> E ... </ctContext>
            <ctstore> ... E |-> (_=> I) ... </ctstore>
            ...
         </contractInstance>
         <Contract>
            <cname> Name </cname>
            <structinstance>
                <iname> X </iname>
                <ivariables> ... Y |-> D ... </ivariables>
                ... 
            </structinstance>
           ...
         </Contract> 

     rule <k> #memberAccess(X:Id, Y:Id)  => read(#memberAccess(X:Id, Y:Id)) ... </k>
      

    rule <k> read(#memberAccess(X:Id, Y:Id)) => I ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
         <contractInstance>
            <ctId> CI </ctId>
            <ctname> Name </ctname>
            <ctContext> ... D |-> E ... </ctContext>
            <ctstore> ... E |-> I ... </ctstore>
            ...
         </contractInstance>
         <Contract>
            <cname> Name </cname>
            <structinstance>
                <iname> X </iname>
                <ivariables> ... Y |-> D ... </ivariables>
                ... 
            </structinstance>
         ...
         </Contract>


    rule <k> #assign1(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  => write(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  ... </k>
         
     

     rule <k> write(#indexAccess(#memberAccess(X:Id,Y:Id), Z:Int), I:Value)  => 1 ... </k>
         
         <contractStack> ListItem(CI:Int) ... </contractStack>
          <contractInstance>
            <ctId> CI </ctId>
            <ctname> Name </ctname>
            <ctContext> ... D |-> S ... </ctContext>
            <ctstore> ... S+Int Z+Int 1|-> (_=> I)... </ctstore>
            ...
         </contractInstance>
         <Contract>
            <cname> Name </cname>
            <structinstance>
                <iname> X </iname>
                <ivariables> ... Y |-> D ... </ivariables>
                ... 
            </structinstance>
           ...
         </Contract> 


     rule <k> #indexAccess(#memberAccess(X:Id, Y:Id), Z:Int)  => read(#indexAccess(#memberAccess(X:Id, Y:Id), Z:Int))  ... </k>
       

     rule <k> read(#indexAccess(#memberAccess(X:Id, Y:Id), Z:Int))  => I ... </k>
         <contractStack> ListItem(CI:Int) ... </contractStack>
         <contractInstance>
            <ctId> CI </ctId>
            <ctname> Name </ctname>
            <ctContext> ... D |-> S ... </ctContext>
            <ctstore> ... S+Int Z +Int 1|-> I... </ctstore>
            ...
         </contractInstance>
         <Contract>
            <cname> Name </cname>
            <structinstance>
                <iname> X </iname>
                <ivariables> ... Y |-> D ... </ivariables>
                ... 
            </structinstance>
         ...
         </Contract>



//Block

         rule <k> {Ss:Statements} => Ss ~> Rho ...</k> <env> Rho </env>  [structural]
         rule <k> Rho:Map => . ...</k> <env> _ => Rho </env>    [structural]        
   
//Statements
         rule .Statements => .
         rule S:Statement Ss:Statements => S ~> Ss



         rule if (true)  S => S
         rule if (false) S:Statement => .
         rule if (true)  S else S1:Statement => S
         rule if (false) S1:Statement else S => S
         
//Loops

         rule <k> for (A;B:Expression;C) {S} => InitStmts(A) if (B) {ExeWhile(S) ExeCounters(C) for (A;B;C) {S}} else {EndLoop(.Statements)} ... </k>
              <loopCon> true </loopCon>
              <Continue> _=>false </Continue>
              <exeCon> true </exeCon>
         
         rule <k> for (A;.ExpressionList;C) {S} => InitStmts(A) ExeWhile(S) ExeCounters(C) for (A;.ExpressionList;C) {S} ... </k>
              <loopCon> true </loopCon>
              <Continue> _=>false </Continue>
              <exeCon> true </exeCon>

         rule <k> for (A;B;C) {S} => Reset(1) ... </k> 
              <loopCon> false </loopCon>

         rule <k> for (A;B;C) {S} => . ... </k> 
              <exeCon> false </exeCon>

         rule <k> for (A;B;C) S:OtherStatements => A; while (B) {S C;} ... </k> 
         rule <k> for (A;.ExpressionList;C) S:OtherStatements => A; while (true) {S C;} ... </k>

         rule <k> EndLoop(.Statements) => . ... </k>
              <forInit> _=>true </forInit>

         rule <k> InitStmts(S:SimpleStatement Ss:SimpleStatements) => InitStmt(S) ~> InitStmts(Ss) ... </k>
         rule <k> InitStmt(S) => S; ... </k>
              <forInit> true=>false </forInit>
         rule <k> InitStmt(S) => . ... </k>
              <forInit> false </forInit>
         rule <k> InitStmts(.SimpleStatements) => . ... </k>
     
              
            

         rule <k> do {S} while (B); =>  ExeWhile(S) if(B) {do {S} while (B);} else {.Statements} ... </k> 
              <loopCon> true </loopCon>
              <Continue> _=>false </Continue>
              <exeCon> true </exeCon>

         rule <k> do {S} while (B); => Reset(1) ... </k> 
             <loopCon> false </loopCon>

         rule <k> do {S} while (B); => . ... </k> 
             <exeCon> false </exeCon>

               
         rule <k> while (B) {S} => if (B) {ExeWhile(S) while (B) {S}} else {.Statements} ... </k> 
              <loopCon> true </loopCon>
              <Continue> _=>false </Continue>
              <exeCon> true </exeCon>

  
         rule <k> while (B) S:OtherStatements => if (B) {S while (B) S} else {.Statements} ... </k> 

         rule <k> while (B) S => . ... </k>
              <exeCon> false </exeCon>

         rule <k> while (B) S => Reset(1) ... </k> 
              <loopCon> false </loopCon>
    
         
              
         rule <k> ExeWhile(S:Statement Ss:Statements) => ExeWhileStmt(S) ~>  ExeWhile(Ss) ... </k>
         rule <k> ExeWhile(.Statements) => . ... </k>

         rule <k> ExeWhileStmt(S) => S ... </k>
              <exeCon> true </exeCon>
              <Continue> false </Continue>
              <loopCon> true </loopCon>

         rule <k> ExeWhileStmt(S) => . ... </k>
              <exeCon> false </exeCon>

         rule <k> ExeWhileStmt(S) => . ... </k>
             <Continue> true </Continue>

         rule <k> ExeWhileStmt(S) => . ... </k>
             <loopCon> false </loopCon>
              
         rule <k> ExeCounters(S:SimpleStatement Ss:SimpleStatements) => ExeCounter(S) ~> ExeCounters(Ss) ... </k>
         rule <k> ExeCounters(.SimpleStatements) => . ... </k>
         rule <k> ExeCounter(S) => S; ... </k>
              <loopCon> true </loopCon>
              <exeCon> true </exeCon>

         rule <k> ExeCounter(S) => . ... </k>
              <loopCon> false </loopCon>
         
         rule <k> ExeCounter(S) => . ... </k>
              <exeCon> false </exeCon>


    
         rule <k> Reset(1) => . ... </k>
              <loopCon> _=>true </loopCon>
              <forInit> _=> true </forInit>
               
         rule <k> break; => . ... </k>
              <loopCon> _=>false </loopCon>

         rule <k> continue; => . ... </k> 
              <Continue> _=> true </Continue>

         rule <k> revert(.ExpressionList); => throw; ... </k>
      


       
        

//Expression
         
        
         //NewExpression

         rule <k> new X:Id (E:ExpressionList) => CallConstructor(X,N,Cst,E) ... </k>
              <Contract>
		<cname> X </cname>
                <vnum> Num </vnum>
                <vId> V </vId>
		<variables> Rho </variables>
                <typename> Type </typename>
                <cstore> S </cstore>
                <cLocation> CL </cLocation>
               
                <dtype> Dt </dtype>
                <dstore> Ds </dstore>
                <Length> L </Length>
                <baseaddress> B </baseaddress>
                <constructor> Cst </constructor>
           
		...
	</Contract> 
	<cntContracts> N:Int => N +Int 1 </cntContracts>
	(.Bag => 
	    <contractInstance>
		<ctId> N </ctId>
                <ctname> X </ctname>
                <ctnum> Num </ctnum>
                <ctvId> V </ctvId>
		<ctContext> Rho </ctContext>
                <ctType> Type </ctType>
                <ctstore> S </ctstore>
                <ctLocation> CL </ctLocation>
                <idtype> Dt </idtype>
                <idstore> Ds </idstore>
                <Memory> .Map </Memory>
                <ilength> L </ilength>
                <ibaseaddress> B </ibaseaddress>
                
		...
	    </contractInstance>
	)
	<cnttran> K:Int => K +Int 1 </cnttran>
	<trancomputation> (.Map => K |-> "new contract") ... </trancomputation>
        <newStack> (.List => ListItem(X)) ... </newStack>

rule <k> _:AllValues; => . ... </k>
       
        rule  <k> CallConstructor(C,N,0,E) => N ... </k>
              <newStack>  ListItem(C) => .List ... </newStack>
        rule  <k> CallConstructor(C,N,1,E) => functionCall(-1;N;C;E;msginfo(-1,N,0,0))  ... </k> 

        
       
        rule  <k> C:Id(I:Int)=> I ... </k>
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
    
       rule <k> X:Id = I:Value => I ...</k>
            <contractStack> ListItem(-1) ... </contractStack>
            <env>... X |-> N ...</env>
            <store>... (N |-> V) => (N |->I) ...</store>  [assignment] 
            
          

       rule <k> X:Id = I:Value => write(X,I) ...</k>
            <contractStack> ListItem(CI:Int) ... </contractStack>
            requires CI>=Int 0
             
            
       rule <k> write(X,I) => I ... </k>
             
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N...</ctContext>
              <ctstore> ... (N |-> V) => (N |->I) ...</ctstore> 
              <ctLocation> ...  X |-> String2Id("Global") ...</ctLocation>
              <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
              ...
             </contractInstance>

       rule <k> write(X,I) => I ... </k>
             
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <Memory>... (N |-> _) => (N |-> I) ...</Memory> 
              <ctLocation> ...  X |-> String2Id("Local") ...</ctLocation>
              <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
              ...
             </contractInstance>

      

       rule X:Expression += Y:Expression => X=X + Y 
       rule X:Expression -= Y:Expression => X=X - Y 
       rule X:Expression *= Y:Expression => X=X * Y 
       rule X:Expression /= Y:Expression => X=X / Y 
       rule X:Expression %= Y:Expression => X=X % Y
       rule X <<= Y => X= X *2^Int Y
       rule X >>= Y => X= X /2^Int Y

       rule <k> X:Id => read(X) ...</k>
     
       rule <k> read(X:Id) => I ... </k>
            <contractStack> ListItem(-1) ... </contractStack>
            <env>... X |-> N ...</env>
            <store>... N |-> I ...</store>  [lookup] 

       rule <k> read(X:Id) => I ... </k>
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> I ...</ctstore> 
              <ctLocation> ...  X |-> String2Id("Global") ...</ctLocation>
              <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
              ...
             </contractInstance>
            requires CI >=Int 0

        rule <k> read(X:Id) => I ... </k>
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <Memory>... N |-> I ...</Memory> 
              <ctLocation> ...  X |-> String2Id("Local") ...</ctLocation>
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
        rule  true ? B:Expression : C:Expression => B  
        rule  false ? B:Expression : C:Expression => C    



//IndexAccess

    rule <k> X:IndexAccess => read(X) ... </k>
    rule <k> read(X:IndexAccess) => ArrayName(X,X) ... </k>
    rule <k> ArrayName(X:IndexAccess [Y:Int],Z) => ArrayName(X,Z) ... </k>

    rule <k> ArrayName(#indexAccess(X,Y),Z) => IdxAccess(X,Z,1,E) ... </k>
         <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ibaseaddress> ... X  |-> E ... </ibaseaddress>
            
              ...
           </contractInstance>
    
    rule <k> IdxAccess(X,A[Y:Int],N:Int,E) => IdxAccess(X,A,N +Int 1,BaseAddress(X,N,E,Y)) ... </k>
     
         <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctLocation> ... X  |-> String2Id("Local") ... </ctLocation>
              <iarray>
                <ianame> X </ianame>
                <idnum> Num </idnum>
              ...
              </iarray>
              ...
           </contractInstance>     requires N<Int Num 

     rule <k> IdxAccess(X,A[Y:Int],N:Int,E) => IdxAccess(X,A,N +Int 1,BaseAddress(X,N,E,Y)) ... </k>
         <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
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

     rule <k> IdxAccess(X,#indexAccess(X,Y),Num,E) => I ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <idstore> ... (E +Int Y |-> I) ...   </idstore>
  
              ...
           </contractInstance>

 
      rule <k> IdxAccess(X,X[Y:Int],Num,E) => I ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctstore> ... (E +Int Y |-> I) ...   </ctstore>
            
              ...
           </contractInstance>
 

   
     rule <k> BaseAddress(X,N,E,Y) => CntBaseSize(X,N,Y) + E ... </k>


     rule <k> CntBaseSize(X,N,S) => CntBaseSize(X,N +Int 1,S *Int Size) ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
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

     rule <k> CntBaseSize(X,N,S) => CntBaseSize(X,N +Int 1,S *Int Size) ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
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


     rule <k> CntBaseSize(X,Num,S) => S ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctLocation> ... X  |-> String2Id("Local") ... </ctLocation>
              <iarray>
                <ianame> X </ianame>
                <idnum> Num </idnum>
                ...
              </iarray>
              ...
           </contractInstance>

     rule <k> CntBaseSize(X,Num,S) => S ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
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

          

    rule <k> X:Id [Y:Expression] = I:Value => write(X[Y],I) ... </k>

    rule <k> write(X:IndexAccess,I) => ArrayNameW(X,X,I) ... </k>
    rule <k> ArrayNameW(X:IndexAccess [Y:Int],Z,I) => ArrayNameW(X,Z,I) ... </k>

    rule <k> ArrayNameW(X:Id [Y:Int],Z,I) => IdxWrite(X,Z,1,E,I) ... </k>
         <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ibaseaddress> ... X  |-> E ... </ibaseaddress>
            
              ...
           </contractInstance>
    
   

     rule <k> IdxWrite(X,A[Y:Int],N:Int,E,I) => IdxWrite(X,A:IndexAccess,N +Int 1,BaseAddress(X,N,E,Y),I) ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
             // <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
              ...
           </contractInstance>     
          

    
     rule <k> IdxWrite(X,X[Y:Int],Num,E,I) => WriteIndex(E +Int Y,I) ... </k>
          

     // rule <k> IdxWrite(X,X[Y:Int],Num,E,I) => WriteIndex(E +Int Y,I) ... </k>

      rule <k> WriteIndex(A,I) => 1 ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <idstore> ... (A |-> V) => (A |-> I) ...   </idstore>
              <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
              ... 
           </contractInstance>
      
       rule <k> WriteIndex(A,I) => 1 ... </k>
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctstore> ... (A |-> V) => (A |-> I) ...   </ctstore>
              <ctLocation> ... X  |->String2Id("Global") ... </ctLocation>
              ...
           </contractInstance>

 

   
     rule <k> (X:Expression) => X ... </k>   
     
     rule X:Id[Y:Int] += E:Expression => X[Y]= X[Y]+ E
     rule X:Id[Y:Int] -= E:Expression => X[Y]= X[Y]- E
     rule X:Id[Y:Int] %= E:Expression => X[Y]= X[Y]% E


//Msg


      rule <k> msg.value => V ... </k>
           <Msg> msginfo(_,_,V,_) </Msg>

      rule <k> msg.gas => V ... </k>
           <Msg> msginfo(_,_,_,V) </Msg>

      rule <k> msg.sender => V ... </k>
           <Msg> msginfo(V,_,_,_) </Msg>

      rule <k> msg.owner => V ... </k>
          <Msg> msginfo(_,V,_,_) </Msg>

      rule <k> msg.sender = I:Int => I ... </k>
           <Msg> msginfo((_=> I),_,_,_) </Msg>

      rule <k> msg.owner = I:Int => I ... </k>
           <Msg> msginfo(_,(_=> I),_,_) </Msg>

      rule <k> msg.value = I:Int => I ... </k>
           <Msg> msginfo(_,_,(_=> I),_) </Msg>

      rule <k> msg.gas = I:Int => I ... </k>
           <Msg> msginfo(_,_,_,(_=> I)) </Msg>

      rule <k> msg => M ... </k>
           <Msg> M:Msg </Msg>

//Setting length of one-dimensional dynamic array
    
    //Local dynamic array

      rule <k> X:Id.length = I:Int => ArrayUpdate(1,CI,X,I) ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
              <ctId> CI </ctId>
              <ctContext> ... X |-> E ... </ctContext>
              <ctstore> ... (E |-> V) => (E |-> I) ... </ctstore>
              <ibaseaddress> ... X |-> (_=>!Num:Int) ... </ibaseaddress>
              <idstore> (.Map => !Num:Int |-> 0) ... </idstore>
              <ctLocation> ... X  |-> String2Id("Local") ... </ctLocation>
              ...
           </contractInstance>

    //Global dynamic array

      rule <k> X:Id.length = I:Int => DArrayUpdate(1,CI,X,I) ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
              <ctId> CI </ctId>
              <ctContext> ... X |-> E ... </ctContext>
              <ctstore> ... (E |-> V) => (E |-> I) ... </ctstore>
              <ibaseaddress> (.Map => X |-> !Num:Int) ... </ibaseaddress>
              <idstore> (.Map => !Num:Int |-> 0) ... </idstore>
             <ctLocation> ... X  |-> String2Id("Global") ... </ctLocation>
              ...
           </contractInstance>

  

      rule <k> ArrayUpdate(Ins,CI,X,I) => InstanceUpdate(Ins,CI,X,I) ~> ArrayUpdate(Ins+Int 1,CI,X,I) ... </k>
           requires Ins<Int I

      rule <k> ArrayUpdate(I,CI,X,I) => 1 ... </k>


      rule <k> InstanceUpdate(Ins,CI,X,I) => . ... </k>
           <contractInstance>
              <ctId> CI </ctId>
              <idstore> (.Map => !Num:Int |-> 0)... </idstore>
            ...
           </contractInstance> 
           requires Ins>Int 0 

      rule <k> DArrayUpdate(Ins,CI,X,I) => DInstanceUpdate(Ins,CI,X,I) ~> DArrayUpdate(Ins+Int 1,CI,X,I) ... </k>
           requires Ins<Int I

      rule <k> DArrayUpdate(I,CI,X,I) => 1 ... </k>
     

      rule <k> DInstanceUpdate(Ins,CI,X,I) => . ... </k>
           <contractInstance>
              <ctId> CI </ctId>
              <idstore> (.Map => !Num:Int |-> 0)... </idstore>
            ...
           </contractInstance> 
           requires Ins>Int 0 


    

     //Push

      rule <k> X:Id.push(Y:Int); => . ... </k> 
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
               <ctId> CI </ctId>
               <Memory> ... X |-> (E=>E+Int 1) ... </Memory>
               <ctstore> ... (A +Int E |->(_=> Y))... </ctstore>
               <ibaseaddress> ... X |-> A ... </ibaseaddress>
               <ilength> ... X |-> N ...</ilength>
               ...
           </contractInstance>
    
           requires N>Int 0

      rule <k> X:Id.push(Y:Int); => . ... </k> 
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
               <ctId> CI </ctId>
               <Memory> ... X |-> (E=>E+Int 1) ... </Memory>
               <ctstore> (.Map => A +Int E |-> Y)... </ctstore>
               <ibaseaddress> ... X |-> A ... </ibaseaddress>
               <ilength> ... X |-> N ...</ilength>
               ...
           </contractInstance>
           requires N>Int 0



      rule <k> X:Id.push(Y:Int); => . ... </k> 
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
               <ctId> CI </ctId>
               <ctContext> ... X |-> E ... </ctContext>
               <ctstore> ... E |-> (S => S+Int 1) (A +Int S |->(_=> Y))... </ctstore>
               <ibaseaddress> ... X |-> A ... </ibaseaddress>
               <ilength> ... X |-> N ...</ilength>
               ...
           </contractInstance>
    
           requires N>Int 0

      rule <k> X:Id.push(Y:Int); => . ... </k> 
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
              <ctId> CI </ctId>
              <ctContext> ... X |-> E ... </ctContext>
              <ctstore> ... E |-> (S => S+Int 1) ... </ctstore>
              <idstore> ... (A +Int S |->(_=> Y))  ... </idstore>
              <ibaseaddress> ... X |-> A ... </ibaseaddress>
              <ilength> ... X|-> 0 ...</ilength>
              ...
            </contractInstance>

      rule <k> X:Id.push(Y:Int); => . ... </k> 
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
              <ctId> CI </ctId>
              <ctContext> ... X |-> E ... </ctContext>
              <ctstore> ... E |-> (S => S+Int 1) ... </ctstore>
              <idstore> ... (.Map => A +Int S |-> Y)  ... </idstore>
              <ibaseaddress> ... X |-> A ... </ibaseaddress>
              <ilength>... X|-> 0 ...</ilength>
              ...
            </contractInstance>
     
         


      rule <k> X:Id.push(Y:Int); => . ... </k> 
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
               <ctId> CI </ctId>
               <ctContext> ... X |-> E ... </ctContext>
               <ctstore> ... E |-> (S => S+Int 1) (.Map => A +Int S |-> Y)... </ctstore>
               <ibaseaddress> ... X |-> A ... </ibaseaddress>
               <ilength> ... X |-> N ...</ilength>
               ...
           </contractInstance>
           requires N>Int 0


   
    
   


endmodule

