
requires "solidity-syntax.k"
requires "configuration.k"

module FUNCTION

imports SOLIDITY-SYNTAX
imports CONFIGURATION


/*****************************@
       FunctionDefinition
*******************************/

rule <k> pcsContractPart(C:Id, function C:Id (Ps1:FParameters) FQ:FunQuantifiers returns  (Ps2:FParameters){B}) => . ... </k>
            <Contract>
	       <cname> C </cname>
	       <cfunction> (.Map => C |-> CF) ... </cfunction>
               <constructor> _=>1 </constructor>
               ...
            </Contract>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <Return> 0 </Return>
                  </Function>
	       )
               
              
                requires Id2String(C) =/=String "main"

       rule <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters) FQ:FunQuantifiers returns  (Ps2:FParameters){B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => F |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <Return> 0 </Return>
                  </Function>
	       )
               
                requires Id2String(F) =/=String "main" 

     

        rule <k> pcsContractPart(C:Id, function C:Id (Ps1:FParameters)  FQ:FunQuantifiers  {B}) => . ... </k>
             <Contract>
	       <cname> C </cname>
	      
               <cfunction> (.Map => C |-> CF) ... </cfunction>
               <constructor> _=>1 </constructor>
               ...
              </Contract>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .FParameters </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <Return> 0 </Return>                     
	          </Function>
	       )
                
          
                requires Id2String(C) =/=String "main"     
                
      
       

       rule <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters)  FQ:FunQuantifiers  {B}) => . ... </k>
       
	       <cname> C </cname>	      
               <cfunction> (.Map => F |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .FParameters </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <Return> 0 </Return>                     
	          </Function>
	       )

                requires Id2String(F) =/=String "main" 
                 

              
/*
       rule <k> pcsContractPart(C:Id, function .Ids (Ps1:FParameters) FQ:FunQuantifiers   {B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => String2Id("fallback")  |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .FParameters </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <Return> 0 </Return>
	          </Function>
	       )
               
       rule <k> pcsContractPart(C:Id, function .Ids (Ps1:FParameters) FQ:FunQuantifiers returns (Ps2:FParameters) {B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => String2Id("fallback")  |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters> 
                     <outputparameters> Ps2 </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <Return> 0 </Return>
	          </Function>
	       )

*/
                     
    
        rule <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters) .FunQuantifiers   {B}) => B ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => F |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .FParameters </outputparameters>
                     <body> B </body>
		     ...                    
	          </Function>
	       )
  
               requires Id2String(F) ==String "main"
               

rule <k> pcsContractPart(C:Id, function F:Id (P1:FParameters) .FunQuantifiers
     	 		       returns (Ps2:FParameters) {B}) => B ... </k>
       
	       <cname> C </cname>
               <cfunction> (.Map => F |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>

               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> P1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
                     <body> B </body>
                     ...
	          </Function>)

               requires Id2String(F) ==String "main"

     
//BindParam

         syntax SolidityItem
                  ::=BindParam(FParameters, Values)
      
         rule BindParam(.FParameters, .Values) => .

         rule <k> BindParam(T:TypeName .StorageLocations P:Id, Ps:FParameters, E:Value, Es:Values) => BindParam(Ps,Es) ... </k>
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
          
           
         
	          <Contract>
                    ...
       
	             <mname> X </mname>
                  
                     <condition> Con:Expression </condition>

                     <cfunction> ... (F |-> CF:Int) ... </cfunction>
	           </Contract>            

                
                     <fId> CF </fId>
                     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
                     <body> B:K </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> FC:Expression => (FC && Con) </FunCon>
                   
        
       
        rule <k> FunQ(X:Id (MIPs:Values), F:Param) => BindParam(Ps,MIPs) ... </k>
              
           
	          <Contract>
                    ...
       
	             <mname> X </mname>
                     <mparameters> Ps:FParameters </mparameters>
                     <condition> Con:Expression </condition>

                     <cfunction> ... (F |-> CF:Int) ... </cfunction>
	           </Contract>            

                
                     <fId> CF </fId>
                     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> Ps2 </outputparameters>
                     <body> B:K </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> (FC:Expression => (FC && Con)) </FunCon>
                  
          
            

//ModifierDefinition

         rule <k> pcsContractPart(CN:Id, modifier X:Id (Ps:FParameters ) {require(C:Expression); _;}) => . ... </k>
              <Contract>
              (.Bag => 
                 <Modifier>
                    <mname> X </mname>
                    <mparameters> Ps </mparameters>
                    <condition> C </condition>
                 </Modifier>
               )
              ...
              </Contract> 

         rule <k> pcsContractPart(CN:Id, modifier X:Id {require(C:Expression); _;}) => . ... </k>
              <Contract>
              (.Bag => 
                 <Modifier>
                    <mname> X </mname>
                    <mparameters> .K </mparameters>
                    <condition> C </condition>
                 </Modifier>
               )
              ...
              </Contract> 


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
           <Contract>
	     <cname> Cn </cname>
     	     <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	    ...
           </Contract>
         ...
        </contracts>
        <Function>
	   <fId> CT </fId>
     	   <inputparameters> Ps:FParameters </inputparameters>
     	   <body> B:Statements </body>
           <FunQuantifiers> FQ </FunQuantifiers>
           <FunCon> Con </FunCon>
	   ...
        </Function>

      rule <k> Call(F:Id,Es:Values) => BindParam(Ps,Es) ~> if(Con){B}  ... </k>
           <contractStack> ListItem(CI:Int) ... </contractStack>
           <contractInstance>
     	       <ctId> CI </ctId>
               <ctname> Cn:Id </ctname>
	       ...
           </contractInstance>
           <contracts>
               <Contract>
	         <cname> Cn </cname>
     	         <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	         ...
               </Contract>
           ...
           </contracts>
           <Function>
	       <fId> CT </fId>
     	       <inputparameters> Ps:FParameters </inputparameters>
     	       <body> B:Statements </body>
               <FunQuantifiers> FQ </FunQuantifiers>
               <FunCon> Con </FunCon>
	       ...
           </Function>


     


 
    
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
              <Contract>
	         <cname> Cn </cname>
     	         <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	      ...
              </Contract>
            ...
           </contracts>
           <Function>
	      <fId> CT </fId>
     	     <Return> E </Return>
	     ...
           </Function>

      rule <k> return E:Int; => . ...</k>
           <functionStack> ListItem(F:Id) ... </functionStack>
           <contractStack> ListItem(CI:Int) ... </contractStack>
   
           <contractInstance>
     	      <ctId> CI </ctId>
              <ctname> Cn:Id </ctname>
	      ...
           </contractInstance>
           <contracts>
              <Contract>
	         <cname> Cn </cname>
     	         <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	       ...
              </Contract>
            ...
           </contracts>
           <Function>
	       <fId> CT </fId>
     	       <Return> _=> E </Return>
	       ...
           </Function> 

      rule <k> return; => . ... </k>


endmodule
