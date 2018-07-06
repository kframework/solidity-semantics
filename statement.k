
requires "solidity-syntax.k"
requires "configuration.k"


module STATEMENT

imports SOLIDITY-SYNTAX
imports CONFIGURATION

// Member Access

    rule <k> #assign1(#memberAccess(X:Id,Y:Id), I:Value)  => write(#memberAccess(X:Id,Y:Id), I:Value)  ... </k>
         
        /* <contractStack> ListItem(CI:Int) ... </contractStack>
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
         </Contract> */

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
        /* <contractStack> ListItem(CI:Int) ... </contractStack>
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
         </Contract>*/

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
         
       /*  <contractStack> ListItem(CI:Int) ... </contractStack>
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
         </Contract> */

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
        /* <contractStack> ListItem(CI:Int) ... </contractStack>
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
         </Contract>*/

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

         rule <k> {Ss:Statements} => Ss ~> Rho ...</k> <env> Rho </env> [structural]
         rule <k> Rho:Map => . ... </k> <env> _ => Rho </env>           [structural]
   
//Statements
         rule .Statements => .
         rule S:Statement Ss:Statements => S ~> Ss

//         rule K:KResult ; => .

         rule if (true)  S => S
         rule if (false) S:Statement => .
         rule if (true)  S else S1:Statement => S
         rule if (false) S1:Statement else S => S

         rule for (A;B;C) S => A; while (B) {S C;} [structural]
         rule do S while (B) =>  S if(B) {do S while (B)} else {.Statements}  [structural]
         rule while (B) S => if (B) {S while (B) S} else {.Statements}  [structural]

       
        

//Expression
         
        
         //NewExpression
      
         rule <k>  new C (E:ExpressionList)  => CallConstructor(C,N,Cst,E) ~> N ... </k>
     
   	<Contract>
		<cname> C </cname>
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
                <ctname> C </ctname>
                <ctnum> Num </ctnum>
                <ctvId> V </ctvId>
		<ctContext> Rho </ctContext>
                <ctType> Type </ctType>
                <ctstore> S </ctstore>
                <ctLocation> CL </ctLocation>
                <ditype> Dt </ditype>
                <distore> Ds </distore>
                <Memory> .Map </Memory>
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
       
      rule <k> ++X => write(X, X +Int 1) ...</k>

          /*
           <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (I => I +Int 1) ...</ctstore> 
              ...
             </contractInstance>*/

       rule <k> X++ => write(X, X +Int 1) ...</k>
          /*
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (I => I +Int 1) ...</ctstore> 
              ...
             </contractInstance>*/

       rule <k> --X => write(X, X -Int 1) ...</k> 
       /*
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (I => I -Int 1) ...</ctstore> 
              ...
             </contractInstance>*/


       rule <k> X-- => write(X, X -Int 1) ...</k>
       /*
           <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (I => I -Int 1) ...</ctstore> 
              ...
             </contractInstance>*/
      

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

       rule <k> X:Expression = I:Value => write(X,I) ...</k>

       rule <k> write(X,I) => I ... </k>
             
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> (_ => I) ...</ctstore> 
              <ctLocation> ...  X |-> L:Specifiers ...</ctLocation>
              <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
              ...
             </contractInstance>

       rule <k> write(X,I) => I ... </k>
             
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <Memory>... N |-> (_ => I) ...</Memory> 
              <ctLocation> ...  X |-> L:StorageLocations ...</ctLocation>
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

      
       rule <k> X:Id => I ...</k>
            <contractStack> ListItem(-1) ... </contractStack>
            <env>... X |-> N ...</env>
            <store>... N |-> I ...</store>  [lookup] 

       rule <k> X:Id => read(X) ...</k>

       rule <k> read(X:Id) => I ... </k>
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <ctstore>... N |-> I ...</ctstore> 
              <ctLocation> ...  X |-> L:Specifiers ...</ctLocation>
              <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
              ...
             </contractInstance>

        rule <k> read(X:Id) => I ... </k>
            <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctContext>... X |-> N ...</ctContext>
              <Memory>... N |-> I ...</Memory> 
              <ctLocation> ...  X |-> L:StorageLocations ...</ctLocation>
              <ctType> ... X |-> T:ElementaryTypeName ... </ctType>
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

rule 
  <k> ArrayName(X:Id [Y:Int],Z) => IdxAccess(X,Z,1,E) ... </k>
  <contractStack> ListItem(CI:Int) ... </contractStack>
  <contractInstance>
    <ctId> CI </ctId>
    <ctname> Name </ctname> // This is not used! 
    <ibaseaddress> ... X  |-> E ... </ibaseaddress>
    ...
  </contractInstance>
    
// I think the variable names looks a bit confusing e.g. in the follosing rules, 
// it is not immediately clear what X, A, Y, N, E are...
// Same thing for some cells names: ianame, idnum...

rule 
  <k> IdxAccess(X,A[Y:Int],N:Int,E) => IdxAccess(X,A,N +Int 1,BaseAddress(X,N,E,Y)) ... </k>
  <contractStack> ListItem(CI:Int) ... </contractStack>
  <contractInstance>
    <ctId> CI </ctId>
    <ctname> Name </ctname> // Name is not used here! 
    <ctLocation> ... X  |-> L:StorageLocations ... </ctLocation>
    <iarray>
      <ianame> X </ianame>
      <idnum> Num </idnum>
      ...
    </iarray>
    ...
  </contractInstance>     
    requires N <Int Num 

     rule <k> IdxAccess(X,A[Y:Int],N:Int,E) => IdxAccess(X,A,N +Int 1,BaseAddress(X,N,E,Y)) ... </k>
         <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctLocation> ... X  |-> L:Specifiers ... </ctLocation>
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

     rule <k> IdxAccess(X,X[Y:Int],Num,E) => I ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctstore> ... (E +Int Y |-> I) ...   </ctstore>
              <ctLocation> ... X  |-> L:StorageLocations ... </ctLocation>
              <iarray>
                <ianame> X </ianame>
                <idnum> Num </idnum>
                ...
              </iarray>
              ...
           </contractInstance>
 
      rule <k> IdxAccess(X,X[Y:Int],Num,E) => I ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctstore> ... (E +Int Y |-> I) ...   </ctstore>
              <ctLocation> ... X  |-> L:Specifiers ... </ctLocation>
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

   
     rule <k> BaseAddress(X,N,E,Y) => CntBaseSize(X,N,Y) + E ... </k>


     rule <k> CntBaseSize(X,N,S) => CntBaseSize(X,N +Int 1,S *Int Size) ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctLocation> ... X  |-> L:StorageLocations ... </ctLocation>
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
              <ctLocation> ... X  |-> L:Specifiers ... </ctLocation>
              
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
              <ctLocation> ... X  |-> L:StorageLocations ... </ctLocation>
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
              <ctLocation> ... X  |-> L:Specifiers ... </ctLocation>
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

          

    rule <k> X:IndexAccess = I:Value => write(X,I) ... </k>

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
    
    rule <k> IdxWrite(X,A[Y:Int],N:Int,E,I) => IdxWrite(X,A,N +Int 1,BaseAddress(X,N,E,Y),I) ... </k>
         <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctLocation> ... X  |-> L:StorageLocations ... </ctLocation>
              <iarray>
                <ianame> X </ianame>
                <idnum> Num </idnum>
              ...
              </iarray>
              ...
           </contractInstance>     requires N<Int Num 

     rule <k> IdxWrite(X,A[Y:Int],N:Int,E,I) => IdxWrite(X,A,N +Int 1,BaseAddress(X,N,E,Y),I) ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctLocation> ... X  |-> L:Specifiers ... </ctLocation>
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


     rule <k> IdxWrite(X,X[Y:Int],Num,E,I) => 1 ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctstore> ... (E +Int Y |->(_ => I)) ...   </ctstore>
              <ctLocation> ... X  |-> L:StorageLocations ... </ctLocation>
              <iarray>
                <ianame> X </ianame>
                <idnum> Num </idnum>
                ...
              </iarray>
              ...
           </contractInstance>
    
     rule <k> IdxWrite(X,X[Y:Int],Num,E,I) => 1 ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
              <ctstore> ... (E +Int Y |-> I) ...   </ctstore>
              <ctLocation> ... X  |-> L:Specifiers ... </ctLocation>
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



   /*
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
          <Contract>
           <cname> Name </cname>
           <array>
                <aname> X </aname>
                <dimensions> ... 2 |-> Size ... </dimensions>
              ...
              </array>
           ...
          </Contract>

     rule <k> X:Id[Y:Int][Z:Int] = I:Value => 1 ... </k>
          <contractStack> ListItem(CI:Int) ... </contractStack>
             <contractInstance>
              <ctId> CI </ctId>
              <ctname> Name </ctname>
             <ibaseaddress> ... X  |-> E ... </ibaseaddress>
              <ctstore> ... (E +Int Y +Int Size*Int Z|->(_ => I)) ...   </ctstore>
      
             ...
           </contractInstance>
          <Contract>
           <cname> Name </cname>
           <array>
                <aname> X </aname>
                <dimensions> ... 2 |-> Size ... </dimensions>
              ...
              </array>
           ...
          </Contract>
           


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
           
      */
        
     
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


    rule .ExpressionList => .Values
    rule .FParameters => .Values


endmodule

