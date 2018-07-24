
requires "solidity-syntax.k"
requires "configuration.k"

module STATEMENT

imports SOLIDITY-SYNTAX
imports CONFIGURATION

// Member Access

     rule <k> X:Id.Y:Id = I:Value  => 1 ... </k>
         
         <contractStack> ListItem(CI:Int) ... </contractStack>
          <contractInstance>
            <ctId> CI </ctId>
            <ctname> Name </ctname>
            <ctContext> ... D |-> E ... </ctContext>
            <ctstore> ... E |-> (_=> I) ... </ctstore>
            ...
         </contractInstance>
         <contract>
            <cname> Name </cname>
            <structinstance>
                <iname> X </iname>
                <ivariables> ... Y |-> D ... </ivariables>
                ... 
            </structinstance>
           ...
         </contract> 

     rule <k> X:Id.Y:Id  => I ... </k>
         <contractStack> ListItem(CI:Int) ... </contractStack>
         <contractInstance>
            <ctId> CI </ctId>
            <ctname> Name </ctname>
            <ctContext> ... D |-> E ... </ctContext>
            <ctstore> ... E |-> I ... </ctstore>
            ...
         </contractInstance>
         <contract>
            <cname> Name </cname>
            <structinstance>
                <iname> X </iname>
                <ivariables> ... Y |-> D ... </ivariables>
                ... 
            </structinstance>
         ...
         </contract>

    rule <k> X:Id.Y:Id[Z:Int] = I:Value  => 1 ... </k>
         
         <contractStack> ListItem(CI:Int) ... </contractStack>
          <contractInstance>
            <ctId> CI </ctId>
            <ctname> Name </ctname>
            <ctContext> ... D |-> S ... </ctContext>
            <ctstore> ... S+Int Z+Int 1|-> (_=> I)... </ctstore>
            ...
         </contractInstance>
         <contract>
            <cname> Name </cname>
            <structinstance>
                <iname> X </iname>
                <ivariables> ... Y |-> D ... </ivariables>
                ... 
            </structinstance>
           ...
         </contract> 

     rule <k> X:Id.Y:Id[Z:Int]  => I ... </k>
         <contractStack> ListItem(CI:Int) ... </contractStack>
         <contractInstance>
            <ctId> CI </ctId>
            <ctname> Name </ctname>
            <ctContext> ... D |-> S ... </ctContext>
            <ctstore> ... S+Int Z +Int 1|-> I... </ctstore>
            ...
         </contractInstance>
         <contract>
            <cname> Name </cname>
            <structinstance>
                <iname> X </iname>
                <ivariables> ... Y |-> D ... </ivariables>
                ... 
            </structinstance>
         ...
         </contract>


//Block

         rule <k> {Ss:Statements} => Ss ~> Rho ...</k> <env> Rho </env>  [structural]
         rule <k> Rho => . ...</k> <env> _ => Rho </env>    [structural]        
   
//Statements
         rule .Statements => .
        
         rule S:Statement Ss:Statements => S ~> Ss

         rule _:KResult ; => .

         rule if (true)  S => S
         rule if (false) _ => .
         rule if (true)  S else _ => S
         rule if (false) _ else S => S

         rule <k> for (A;B;C) {S} => InitStmts(A;) if (B) {ExeWhile(C; S) for (A;B;C) {S}} else {EndLoop(.Statements)} ... </k>
              <loopCon> true </loopCon>
              <Continue> _=>false </Continue>
              <funCon> true </funCon>

         rule <k> for (A;B;C) {S} => Reset(1) ... </k> 
              <loopCon> false </loopCon>

         rule <k> for (A;B;C) {S} => . ... </k> 
              <funCon> false </funCon>

         rule <k> EndLoop(.Statements) => . ... </k>
              <forInit> _=>true </forInit>

         rule <k> InitStmts(S:Statement Ss:Statements) => InitStmt(S) ~> InitStmts(Ss) ... </k>
         rule <k> InitStmt(S) => S ... </k>
              <forInit> true=>false </forInit>
         rule <k> InitStmt(S) => . ... </k>
              <forInit> false </forInit>
         rule <k> InitStmts(.Statements) => . ... </k>
     
              
            

         rule <k> do {S} while (B) =>  ExeWhile(S) if(B) {do {S} while (B)} else {.Statements} ... </k> 
              <loopCon> true </loopCon>
              <Continue> _=>false </Continue>
              <funCon> true </funCon>

        rule <k> do {S} while (B) => Reset(1) ... </k> 
             <loopCon> false </loopCon>

        rule <k> do {S} while (B) => . ... </k> 
             <funCon> false </funCon>

         /*rule <k> while (B) S => if (B) {S while (B) S} else {.Statements} ... </k> 
              <loopCon> true </loopCon>
              <Continue> false </Continue>
              <funCon> true </funCon>*/

               
         rule <k> while (B) {S} => if (B) {ExeWhile(S) while (B) {S}} else {.Statements} ... </k> 
              <loopCon> true </loopCon>
              <Continue> _=>false </Continue>
              <funCon> true </funCon>
             


         rule <k> ExeWhile(S:Statement Ss:Statements) => ExeWhileStmt(S) ~>  ExeWhile(Ss) ... </k>
         rule <k> ExeWhile(.Statements) => . ... </k>

         rule <k> ExeWhileStmt(S) => S ... </k>
              <funCon> true </funCon>
              <Continue> false </Continue>
              <loopCon> true </loopCon>

         rule <k> ExeWhileStmt(S) => . ... </k>
              <funCon> false </funCon>

         rule <k> ExeWhileStmt(S) => . ... </k>
             <Continue> true </Continue>

         rule <k> ExeWhileStmt(S) => . ... </k>
             <loopCon> false </loopCon>
              

         rule <k> while (B) S => . ... </k>
              <funCon> false </funCon>

         rule <k> while (B) S => Reset(1) ... </k> 
              <loopCon> false </loopCon>
    
         rule <k> Reset(1) => . ... </k>
              <loopCon> _=>true </loopCon>
              <forInit> _=> true </forInit>
               
         rule <k> break; => . ... </k>
              <loopCon> _=>false </loopCon>

         rule <k> continue; => . ... </k> 
              <Continue> _=> true </Continue>
          
      

  
         
       
        

//Expression
         
        
         //NewExpression
      
         rule <k>  new C (E:ExpressionList)  => CallConstructor(C,N,Cst,E) ~> N ... </k>
     
   	<contract>
		<cname> C </cname>
                <vnum> Num </vnum>
                <vId> V </vId>
		<variables> Rho </variables>
                <typename> Type </typename>
                <cstore> S </cstore>
               
                <dtype> Dt </dtype>
                <dstore> Ds </dstore>
                <length> L </length>
                <baseaddress> B </baseaddress>
                <constructor> Cst </constructor>
           
		...
	</contract>
	<cntContracts> N:Int => N +Int 1 </cntContracts>
	(.Bag => 
	    <contractInstance>
		<ctId> N </ctId>
                <ctname> C </ctname>
                <ctnum> Num </ctnum>
                <ctvId> V </ctvId>
		<ctContext> Rho </ctContext>
                <ctType> Type </ctType>
                <ctstore> S </ctstore>
                <tempContext> Rho </tempContext>
                <tempStore> S </tempStore>
                <tempdistore> Ds </tempdistore>
               
               
                <ditype> Dt </ditype>
                <distore> Ds </distore>
                <memory> .Map </memory>
                <ilength> L </ilength>
                <ibaseaddress> B </ibaseaddress>
                
		...
	    </contractInstance>
	)
	<cnttran> K:Int => K +Int 1 </cnttran>
	<trancomputation> (.Map => K |-> "new contract") ... </trancomputation>
        <newStack> (.List => ListItem(C)) ... </newStack>
      
        rule  <k> CallConstructor(C,N,0,E) => . ... </k>
              <newStack>  ListItem(C) => .List ... </newStack>
        rule  <k> CallConstructor(C,N,1,E) => functionCall(-1;N;C;E:ExpressionList;msginfo(-1,N,0,0)); ... </k> 

       
        rule  <k> C:Id(I:Int,.ExpressionList)=> I ... </k>
              <contract>
                  <cname> C </cname>
                  ...
              </contract>

//SimpleExpression1

       rule ! T => notBool T
       
       rule + I =>  I requires  I>=Int 0
       rule + I => (-1) * I requires I<Int 0
       rule - I => (-1) * I requires I>=Int 0
       rule - I => I requires I<Int 0
     /*
       rule <k> ++X => I +Int 1 ...</k>
            <env>... X |-> N ...</env>
            <store>... N |-> (I => I +Int 1) ...</store> 

       rule <k> X++ => I +Int 1 ...</k>
            <env>... X |-> N ...</env>
            <store>... N |-> (I => I +Int 1) ...</store> 

       rule <k> --X => I -Int 1 ...</k>
            <env>... X |-> N ...</env>
            <store>... N |-> (I => I -Int 1) ...</store> 

       rule <k> X-- => I -Int 1 ...</k>
            <env>... X |-> N ...</env>
            <store>... N |-> (I => I -Int 1) ...</store> 
     */
       
      rule <k> ++X => I +Int 1 ...</k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (I => I +Int 1) ...</ctstore> 
              ...
             </contractInstance>

       rule <k> X++ => I +Int 1 ...</k>
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (I => I +Int 1) ...</ctstore> 
              ...
             </contractInstance>

       rule <k> --X => I -Int 1 ...</k> 
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (I => I -Int 1) ...</ctstore> 
              ...
             </contractInstance>


       rule <k> X-- => I -Int 1 ...</k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (I => I -Int 1) ...</ctstore> 
              ...
             </contractInstance>
      

//SimpleExpression2

       rule I1 < I2 => I1 <Int I2
       rule I1 > I2 => I1 >Int I2
       rule I1 <= I2 => I1 <=Int I2
       rule I1 >= I2 => I1 >=Int I2

//SimpleExpression3
    
       rule <k> X:Expression = I:Value => I ...</k>
            <contractStack> ListItem(-1) ... </contractStack>
            <env>... X |-> N ...</env>
            <store>... N |-> (_ => I) ...</store>  [assignment] 

       rule <k> X:Expression = I:Value => I ...</k>
             
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (_ => I) ...</ctstore> 
              ...
             </contractInstance>


       rule X:Expression += Y:Expression => X=X + Y 
       rule X:Expression -= Y:Expression => X=X - Y 
       rule X:Expression *= Y:Expression => X=X * Y 
       rule X:Expression /= Y:Expression => X=X / Y 
       rule X:Expression %= Y:Expression => X=X % Y
       rule X <<= Y => X= X *2^Int Y
       rule X >>= Y => X= X /2^Int Y

      
       rule <k> X:Id => I ...</k>
            <contractStack> ListItem(-1) ... </contractStack>
            <env>... X |-> N ...</env>
            <store>... N |-> I ...</store>  [lookup] 

       rule <k> X:Id => I ...</k>
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> I ...</ctstore> 
              ...
             </contractInstance>



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
        rule _ && false => false
        rule true || _ => true
        rule false || B => B
        rule _ || true => true
        rule B || false => B
        rule  true ? B:Expression : C:Expression => B  
        rule  false ? B:Expression : C:Expression => C    



//IndexAccess

   //One-dimensional array

     //Array with fixed-size

     rule <k> X:Id[Y:Int] => I ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ibaseaddress> ... X  |-> E ... </ibaseaddress>
              <ctstore> ... (E +Int Y |-> I) ...   </ctstore>
              ...
           </contractInstance>

     rule <k> X:Id[Y:Int] = I:Value => 1 ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
             <ibaseaddress> ... X  |-> E ... </ibaseaddress>
             <ctstore> ... (E +Int Y |->(_ => I)) ...   </ctstore>
             ...
           </contractInstance>

     // dynamic array


     rule <k> X:Id[Y:Int] => I ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ibaseaddress> ... X  |-> S ... </ibaseaddress>
              <distore> ... S +Int Y |-> I ... </distore>
               ...
           </contractInstance>

     rule <k> X:Id[Y:Int] = I:Value => 1 ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ibaseaddress> ... X  |-> S ... </ibaseaddress>
              <distore> ... S +Int Y |->(_=> I) ... </distore>
               ...
           </contractInstance>

  //Two-dimensional array

      //Global array with fixed-size

      rule <k> X:Id[Y:Int][Z:Int] => I ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ibaseaddress> ... X  |-> E ... </ibaseaddress>
              <ctstore> ... (E +Int Y +Int Size*Int Z|-> I) ...   </ctstore>
            
              ...
           </contractInstance>
          <contract>
           <cname> Name </cname>
           <array>
                <aname> X </aname>
                <dimensions> ... 2 |-> Size ... </dimensions>
              ...
              </array>
           ...
          </contract>

     rule <k> X:Id[Y:Int][Z:Int] = I:Value => 1 ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
             <ibaseaddress> ... X  |-> E ... </ibaseaddress>
              <ctstore> ... (E +Int Y +Int Size*Int Z|->(_ => I)) ...   </ctstore>
      
             ...
           </contractInstance>
          <contract>
           <cname> Name </cname>
           <array>
                <aname> X </aname>
                <dimensions> ... 2 |-> Size ... </dimensions>
              ...
              </array>
           ...
          </contract>
           


     //Local array with fixed-size

     rule <k> X:Id[Y:Int][Z:Int] => I ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ibaseaddress> ... X  |-> E ... </ibaseaddress>
              <ctstore> ... (E +Int Y +Int Size*Int Z|-> I) ...   </ctstore>
              <iarray>
                <ianame> X </ianame>
                <idimensions> ... 2 |-> Size ... </idimensions>
              ...
              </iarray>
              ...
           </contractInstance>
           

     rule <k> X:Id[Y:Int][Z:Int] = I:Value => 1 ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
             <ibaseaddress> ... X  |-> E ... </ibaseaddress>
             <ctstore> ... (E +Int Y +Int Size*Int Z|->(_ => I)) ...   </ctstore>
               <iarray>
                <ianame> X </ianame>
                <idimensions> ... 2 |-> Size ... </idimensions>
              ...
              </iarray>
             ...
           </contractInstance>
           

        
     
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

      rule <k> X:Id.length = I:Int; => ArrayUpdate(1,CI,X,I) ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
              <ctId> CI </ctId>
              <ctContext> ... X |-> E ... </ctContext>
              <ctstore> ... E |-> (_=>I) ... </ctstore>
              <ibaseaddress> ... X |-> (_=>!Num:Int) ... </ibaseaddress>
              <distore> (.Map => !Num:Int |-> 0) ... </distore>
              ...
           </contractInstance>

    //Global dynamic array

      rule <k> X:Id.length = I:Int; => DArrayUpdate(1,CI,X,I) ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
              <ctId> CI </ctId>
              <ctContext> ... X |-> E ... </ctContext>
              <ctstore> ... E |->(_=> I) ... </ctstore>
              <ibaseaddress> (.Map => X |-> !Num:Int) ... </ibaseaddress>
              <distore> (.Map => !Num:Int |-> 0) ... </distore>
              ...
           </contractInstance>

  

      rule <k> ArrayUpdate(Ins,CI,X,I) => InstanceUpdate(Ins,CI,X,I) ~> ArrayUpdate(Ins+Int 1,CI,X,I) ... </k>
           requires Ins<Int I

      rule <k> ArrayUpdate(I,CI,X,I) => . ... </k>


      rule <k> InstanceUpdate(Ins,CI,X,I) => . ... </k>
           <contractInstance>
              <ctId> CI </ctId>
              <distore> (.Map => !Num:Int |-> 0)... </distore>
            ...
           </contractInstance> 
           requires Ins>Int 0 

      rule <k> DArrayUpdate(Ins,CI,X,I) => DInstanceUpdate(Ins,CI,X,I) ~> DArrayUpdate(Ins+Int 1,CI,X,I) ... </k>
           requires Ins<Int I

      rule <k> DArrayUpdate(I,CI,X,I) => . ... </k>
     

      rule <k> DInstanceUpdate(Ins,CI,X,I) => . ... </k>
           <contractInstance>
              <ctId> CI </ctId>
              <distore> (.Map => !Num:Int |-> 0)... </distore>
            ...
           </contractInstance> 
           requires Ins>Int 0 


    

     //Push

      rule <k> X:Id.push(Y:Int); => . ... </k> 
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
               <ctId> CI </ctId>
               <memory> ... X |-> (E=>E+Int 1) ... </memory>
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
               <memory> ... X |-> (E=>E+Int 1) ... </memory>
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
              <distore> ... (A +Int S |->(_=> Y))  ... </distore>
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
              <distore> ... (.Map => A +Int S |-> Y)  ... </distore>
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

