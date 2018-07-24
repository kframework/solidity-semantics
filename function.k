
requires "solidity-syntax.k"
requires "configuration.k"

module FUNCTION

imports SOLIDITY-SYNTAX
imports CONFIGURATION

/*****************************@
       FunctionDefinition
*******************************/

         rule <k> pcsContractPart(C:Id, function C:Id (Ps1:Parameters) FQ:FunQuantifiers returns  (Ps2:Parameters){B}) => . ... </k>
            <contract>
	       <cname> C </cname>
	       <cfunction> (.Map => C |-> CF) ... </cfunction>
               <constructor> _=>1 </constructor>
               ...
            </contract>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <return> 0 </return>
                  </function>
	       )
               
              
                requires Id2String(C) =/=String "main"

       rule <k> pcsContractPart(C:Id, function F:Id (Ps1:Parameters) FQ:FunQuantifiers returns  (Ps2:Parameters){B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => F |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <return> 0 </return>
                  </function>
	       )
               
                requires Id2String(F) =/=String "main" andBool
                         Id2String(F) =/=String Id2String(C)

     

        rule <k> pcsContractPart(C:Id, function C:Id (Ps1:Parameters)  FQ:FunQuantifiers  {B}) => . ... </k>
             <contract>
	       <cname> C </cname>
	      
               <cfunction> (.Map => C |-> CF) ... </cfunction>
               <constructor> _=>1 </constructor>
               ...
              </contract>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               (.Bag =>
	          <function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .Parameters </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <return> 0 </return>
                     
	          </function>
	       )
                
          
                requires Id2String(C) =/=String "main"     
                
      
       

       rule <k> pcsContractPart(C:Id, function F:Id (Ps1:Parameters)  FQ:FunQuantifiers  {B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => F |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .Parameters </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <return> 0 </return>
                     
	          </function>
	       )

                requires Id2String(F) =/=String "main" andBool
                         Id2String(F) =/=String Id2String(C)
                 

              

       rule <k> pcsContractPart(C:Id, function .Ids (Ps1:Parameters) FQ:FunQuantifiers   {B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => String2Id("fallback")  |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .Parameters </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <return> 0 </return>
	          </function>
	       )
               
       rule <k> pcsContractPart(C:Id, function .Ids (Ps1:Parameters) FQ:FunQuantifiers returns (Ps2:Parameters) {B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => String2Id("fallback")  |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <return> 0 </return>
	          </function>
	       )


                     
      
        rule <k> pcsContractPart(C:Id, function F:Id (Ps1:Parameters) .FunQuantifiers   {B}) => B ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => F |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .Parameters </outputparameters>
                     <body> B </body>
                    
	          </function>
	       )
  
               requires Id2String(F) ==String "main" 
               

         rule <k> pcsContractPart(C:Id, function F:Id (Ps1:Parameters) .FunQuantifiers returns (Ps2:Parameters) {B}) => B ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => F |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
                     <body> B </body>
                    
                     
	          </function>
	       )
  
               requires Id2String(F) ==String "main" 

     
//BindParam

         syntax SolidityItem
                  ::=BindParam(Parameters, Values)
      
         rule BindParam(.Parameters, .Values) => .

         rule <k> BindParam(T:TypeName .StorageLocations P:Id, Ps:Parameters, E:Value, Es:Values) => BindParam(Ps,Es) ... </k>
              <contractStack> ListItem(CI:Int) ... </contractStack>
              <contractInstance>
                <ctId> CI </ctId>
                <ctContext> .Map => (P |-> !N:Int) ... </ctContext>
                <ctstore> .Map => (!N:Int |-> E) ... </ctstore>
                ...
              </contractInstance>

//FunQuantifiers
       
       rule FunQs(FQ:FunQuantifier FQs:FunQuantifiers,F:Param) => FunQ(FQ,F) ~> FunQs(FQs,F)
       rule FunQs(.FunQuantifiers,F:Param) => .
      
       //Specifier
       rule FunQ(FQ:Specifier,F:Param) => .
      
       //ModifierInvocation
       rule <k> FunQ(X:Id, F:Param) => . ... </k>
          
           
         
	          <contract>
                    ...
       
	             <mname> X </mname>
                  
                     <condition> Con </condition>

                     <cfunction> ... (F |-> CF:Int) ... </cfunction>
	           </contract>            

                
                     <fId> CF </fId>
                     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
                     <body> B:K </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> FC => FC && Con </FunCon>
                   
        
       
        rule <k> FunQ(X:Id (MIPs:Values), F:Param) => BindParam(Ps,MIPs) ... </k>
              
           
	          <contract>
                    ...
       
	             <mname> X </mname>
                     <mparameters> Ps:Parameters </mparameters>
                     <condition> Con </condition>

                     <cfunction> ... (F |-> CF:Int) ... </cfunction>
	           </contract>            

                
                     <fId> CF </fId>
                     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
                     <body> B:K </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> FC => FC && Con </FunCon>
                  
          
            

//ModifierDefinition

         rule <k> pcsContractPart(CN:Id, modifier X:Id (Ps:Parameters ) {require(C:Expression); _;}) => . ... </k>
              <contract>
              (.Bag => 
                 <modifier>
                    <mname> X </mname>
                    <mparameters> Ps </mparameters>
                    <condition> C </condition>
                 </modifier>
               )
              ...
              </contract> 

         rule <k> pcsContractPart(CN:Id, modifier X:Id {require(C:Expression); _;}) => . ... </k>
              <contract>
              (.Bag => 
                 <modifier>
                    <mname> X </mname>
                    <mparameters> .K </mparameters>
                    <condition> C </condition>
                 </modifier>
               )
              ...
              </contract> 


//Functioncall

     rule [function-call]:
        <k> functionCall(F:Id ; Es:Values) => FunQs(FQ,F) ~> Call(F,Es)  ... </k>
        <contractStack> ListItem(CI:Int) ... </contractStack>
    
        <contractInstance>
     	  <ctId> CI </ctId>
          <ctname> Cn:Id </ctname>
	  ...
        </contractInstance>
        <contracts>
           <contract>
	     <cname> Cn </cname>
     	     <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	    ...
           </contract>
         ...
        </contracts>
        <function>
	   <fId> CT </fId>
     	   <inputparameters> Ps:Parameters </inputparameters>
     	   <body> B:Statements </body>
           <FunQuantifiers> FQ </FunQuantifiers>
           <FunCon> Con </FunCon>
	   ...
        </function>

      rule <k> Call(F:Id,Es:Values) => BindParam(Ps,Es) ~> funBody(Con,B) ~> UpdateTemp(CI) ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
     	       <ctId> CI </ctId>
               <ctname> Cn:Id </ctname>
               <ctContext> Rho </ctContext>
               <ctstore> S </ctstore>
               <distore> Ds </distore>
               <memory> M </memory>
               <tempContext> _=> Rho </tempContext>
               <tempStore> _=>S </tempStore>
               <tempdistore> _=>Ds </tempdistore>
               <tempmemory> _=>M </tempmemory>
	       ...
           </contractInstance>
           <contracts>
               <contract>
	         <cname> Cn </cname>
     	         <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	         ...
               </contract>
           ...
           </contracts>
           <function>
	       <fId> CT </fId>
     	       <inputparameters> Ps:Parameters </inputparameters>
     	       <body> B:Statements </body>
               <FunQuantifiers> FQ </FunQuantifiers>
               <FunCon> Con </FunCon>
	       ...
           </function>

      rule <k> UpdateTemp(CI) => . ... </k>   
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
     	       <ctId> CI </ctId>
               <ctContext> Rho </ctContext>
               <ctstore> S </ctstore>
               <distore> Ds </distore>
               <memory> M </memory>
               <tempContext> Rho1=>Rho </tempContext>
               <tempStore> S1=>S </tempStore>
               <tempdistore> Ds1 => Ds </tempdistore>
               <tempmemory> M1 => M </tempmemory>
               ...
           </contractInstance>  
           <funCon> _=>true </funCon>
           <forInit> _=>true </forInit>

      rule <k> throw; => . ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
     	       <ctId> CI </ctId>
               <ctContext> Rho => Rho1 </ctContext>
               <ctstore> S => S1 </ctstore>
               <distore> Ds => Ds1 </distore>
               <memory> M => M1 </memory>
               <tempContext> Rho1 </tempContext>
               <tempStore> S1 </tempStore>
               <tempdistore> Ds1 </tempdistore>
               <tempmemory> M1 </tempmemory>
               ...
           </contractInstance>
           <funCon> _ => false </funCon>
  

      rule <k> funBody(Con,S:Statement Ss:Statements) => funStmt(if(Con){S}) ~> funBody(Con,Ss) ... </k>
      rule <k> funBody(Con,.Statements) => . ... </k>
      rule <k> funStmt(S) => S ... </k>
           <funCon> true </funCon>
           
      rule <k> funStmt(S) => . ... </k>
           <funCon> false </funCon>
         



    
      rule <k> functionCall(Sender:Int; C:Int ; F:Id ; Es:Values ; M:Msg) =>  functionCall(C:Int ; F:Id ; Es:Values ; M:Msg)... </k>

      rule <k> functionCall(C:Int ; F:Id ; Es:Values ; M:Msg) =>  createTransaction(L) ~> functionCall(F ; Es) ~> returnContext(C) ... </k>
  
           <contractStack>  (.List => ListItem(C)) L:List ListItem(-1)   </contractStack>
           <Msg> M1=>M </Msg>
           <MsgStack> (.List => ListItem(M1)) ... </MsgStack>
           <functionStack> (.List => ListItem(F)) ... </functionStack>

     
      rule <k> createTransaction(.List) => . ... </k>
           <cnttran> I:Int => I +Int 1 </cnttran>
           <trancomputation> (.Map => I |-> "functioncall" ) ... </trancomputation>  
           <newStack>  .List </newStack>

      rule <k> createTransaction(.List) => . ... </k> 
           <newStack> L </newStack>
           requires L =/=K .List
     

      rule createTransaction(L) => .
           requires L =/=K .List

      rule <k> returnContext(C:Int) => E ... </k>
   
           <contractStack> ListItem(C) => .List ... </contractStack>
           <Msg> M => M1 </Msg>
           <MsgStack> ListItem(M1) => .List ... </MsgStack>
           <vposition> _ => 1 </vposition>
           <functionStack> ListItem(F) => .List ... </functionStack>
           <newStack>  L => .List </newStack>
           <contractInstance>
     	      <ctId> C </ctId>
              <ctname> Cn:Id </ctname>
	      ...
           </contractInstance>
           <contracts>
              <contract>
	         <cname> Cn </cname>
     	         <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	      ...
              </contract>
            ...
           </contracts>
           <function>
	      <fId> CT </fId>
     	     <return> E </return>
	     ...
           </function>
          

      rule <k> return E:Int; => . ...</k>
           <functionStack> ListItem(F:Id) ... </functionStack>
           <contractStack> ListItem(CI:Int) ... </contractStack>
   
           <contractInstance>
     	      <ctId> CI </ctId>
              <ctname> Cn:Id </ctname>
	      ...
           </contractInstance>
           <contracts>
              <contract>
	         <cname> Cn </cname>
     	         <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	       ...
              </contract>
            ...
           </contracts>
           <function>
	       <fId> CT </fId>
     	       <return> _=> E </return>
	       ...
           </function> 
           <funCon> _=> false </funCon>

      rule <k> return; => . ... </k>
           <funCon> _=> false </funCon>

endmodule