requires "solidity-syntax.k"
requires "configuration.k"

module FUNCTION

imports SOLIDITY-SYNTAX
imports CONFIGURATION

/*****************************@
       FunctionDefinition
*******************************/

rule 
    <k> pcsContractPart(C:Id, function C:Id (Ps1:FParameters) FQ:FunQuantifiers returns  (Ps2:FParameters){B}) => . ... </k>
    <Contract>
        <cname> C </cname>
        <cfunction> (.Map => C |-> CF) ... </cfunction>
        <constructor> _ => 1 </constructor>
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
        </Function>)
    requires Id2String(C) =/=String "main"

rule 
    <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters) FQ:FunQuantifiers returns  (Ps2:FParameters){B}) => . ... </k>
    <Contract>
        <cname> C </cname>
        <cfunction> (.Map => F |-> CF) ... </cfunction>
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
        </Function>)
    requires Id2String(F) =/=String "main" andBool
             Id2String(F) =/=String Id2String(C)

rule 
    <k> pcsContractPart(C:Id, function C:Id (Ps1:FParameters)  FQ:FunQuantifiers  {B}) => . ... </k>
    <Contract>
        <cname> C </cname>
        <cfunction> (.Map => C |-> CF) ... </cfunction>
        // <constructor> Cons:Int => Cons +Int 1  </constructor>
        <constructor> _ => 1 </constructor>
        ...
    </Contract>
    <cntfunction> CF:Int => CF +Int 1 </cntfunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputparameters> Ps1 </inputparameters>
            <outputparameters> .FParameters </outputparameters>
            <body> B </body>
            <FunQuantifiers> FQ </FunQuantifiers>
            <FunCon> true </FunCon>
            <Return> 0 </Return>                     
            </Function>)
    requires Id2String(C) =/=String "main"     

rule  
    <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters)  FQ:FunQuantifiers  {B}) => . ... </k>
    <Contract>
        <cname> C </cname>	      
        <cfunction> (.Map => F |-> CF) ... </cfunction>
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
        </Function>)
    requires Id2String(F) =/=String "main" andBool
             Id2String(F) =/=String Id2String(C)

rule 
    <k> pcsContractPart(C:Id, function .Identifiers (Ps1:FParameters) FQ:FunQuantifiers   {B}) => . ... </k>
    <Contract>
        <cname> C </cname>
        <cfunction> (.Map => String2Id("fallback")  |-> CF) ... </cfunction>
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
        </Function>)
               
rule 
    <k> pcsContractPart(C:Id, function .Identifiers (Ps1:FParameters) FQ:FunQuantifiers returns (Ps2:FParameters) {B}) => . ... </k>
    <Contract>
        <cname> C </cname>
            <cfunction> (.Map => String2Id("fallback")  |-> CF) ... </cfunction>
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
        </Function>)
    
rule 
    <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters) .FunQuantifiers   {B}) => B ... </k>
    <Contract>
        <cname> C </cname>
        <cfunction> (.Map => F |-> CF) ... </cfunction>
        ...
    </Contract>
    <cntfunction> CF:Int => CF +Int 1  </cntfunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputparameters> Ps1 </inputparameters>
            <outputparameters> .FParameters </outputparameters>
            <body> B </body>
            ...                    
        </Function>)
    requires Id2String(F) ==String "main" 

rule 
    <k> pcsContractPart(C:Id, function F:Id (P1:FParameters) .FunQuantifiers returns (Ps2:FParameters) {B}) => B ... </k>
    <Contract>  
        <cname> C </cname>
        <cfunction> (.Map => F |-> CF) ... </cfunction>
        ...
    </Contract>
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

// rule <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters) FQ:FunQuantifiers returns  (Ps2:FParameters);) => . ... </k>
rule pcsContractPart(C:Id, function F:Id (Ps1:FParameters) FQ:FunQuantifiers returns  (Ps2:FParameters);) => .
// rule <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters) FQ:FunQuantifiers;) => . ... </k>
rule pcsContractPart(C:Id, function F:Id (Ps1:FParameters) FQ:FunQuantifiers;) => .
     
//BindParam

syntax SolidityItem ::=BindParam(FParameters, Values)
      
rule BindParam(.FParameters, Values) => .

rule 
    <k> BindParam(T:TypeName .StorageLocations P:Id, Ps:FParameters, E:Value, Es:Values) => BindParam(Ps,Es) ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> .Map => (P |-> !N:Int) ... </ctContext>
        <ctStore> .Map => (!N:Int |-> E) ... </ctStore>
        <ctLocation> .Map =>( P |-> String2Id("Global")) ...</ctLocation>
        <ctType> .Map =>(P |-> T) ... </ctType>
        ...
    </contractInstance>

//FunQuantifiers
       
rule FunQs(FQ:FunQuantifier FQs:FunQuantifiers,F:Param) => FunQ(FQ,F) ~> FunQs(FQs,F)
rule FunQs(.FunQuantifiers,F:Param) => .
      
//Specifier
rule FunQ(FQ:Specifier,F:Param) => .
      
//ModifierInvocation
rule 
    <k> FunQ(X:Id, F:Param) => . ... </k>
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
       
rule 
    <k> FunQ(X:Id (MIPs:Values), F:Param) => BindParam(Ps,MIPs) ... </k>
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

rule 
    <k> pcsContractPart(CN:Id, modifier X:Id (Ps:FParameters ) {require(C:Expression); _;}) => . ... </k>
    <Contract>
        <cname> CN </cname>
        (.Bag => 
            <Modifier>
                <mname> X </mname>
                <mparameters> Ps </mparameters>
                <condition> C </condition>
            </Modifier>)
        ...
    </Contract> 

rule 
    <k> pcsContractPart(CN:Id, modifier X:Id {require(C:Expression); _;}) => . ... </k>
    <Contract>
        <cname> CN </cname>
        (.Bag => 
            <Modifier>
                <mname> X </mname>
                <mparameters> .K </mparameters>
                <condition> C </condition>
            </Modifier>)
        ...
    </Contract> 

rule 
    <k> pcsContractPart(CN:Id, modifier X:Id {if(Con:Expression) {throw;} _;}) => . ... </k>
        <Contract>
            <cname> CN </cname>
            (.Bag => 
                <Modifier>
                    <mname> X </mname>
                    <mparameters> .K </mparameters>
                    <condition> ! Con </condition>
                </Modifier>)
            ...
        </Contract> 

rule 
    <k> pcsContractPart(CN:Id, modifier X:Id (Ps:FParameters ) {if(Con:Expression) {throw;} _;}) => . ... </k>
    <Contract>
        <cname> CN </cname>
        (.Bag => 
            <Modifier>
                <mname> X </mname>
                <mparameters> .K </mparameters>
                <condition> ! Con </condition>
            </Modifier>)
        ...
    </Contract> 

//Functioncall

rule [function-call]:
    <k> functionCall(F:Id ; Es:Values) => FunQs(FQ,F) ~> Call(F,Es)  ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Cn:Id </ctName>
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

rule 
    <k> Call(F:Id,Es:Values) => BindParam(Ps,Es) ~> BindParam(OPs,0) ~> funBody(Con,B) ~> UpdateTemp(CI)  ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Cn:Id </ctName>
        <ctContext> Rho </ctContext>
        <ctStore> S </ctStore>
        <idStore> Ds </idStore>
        <Memory> M </Memory>
        <tempContext> _=> Rho </tempContext>
        <tempStore> _=>S </tempStore>
        <tempIdStore> _=>Ds </tempIdStore>
        <tempMemory> _=>M </tempMemory>
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
        <outputparameters> OPs:FParameters </outputparameters>
        <body> B:Statements </body>
        <FunQuantifiers> FQ </FunQuantifiers>
        <FunCon> Con </FunCon>
        ...
    </Function>

rule 
    <k> UpdateTemp(CI) => . ... </k>   
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> Rho </ctContext>
        <ctStore> S </ctStore>
        <idStore> Ds </idStore>
        <Memory> M </Memory>
        <tempContext> Rho1=>Rho </tempContext>
        <tempStore> S1=>S </tempStore>
        <tempIdStore> Ds1 => Ds </tempIdStore>
        <tempMemory> M1 => M </tempMemory>
        ...
    </contractInstance>  
    <exeCon> _=> true </exeCon>
    <forInit> _=> true </forInit>

rule 
    <k> throw; => . ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> Rho => Rho1 </ctContext>
        <ctStore> S => S1 </ctStore>
        <idStore> Ds => Ds1 </idStore>
        <Memory> M => M1 </Memory>
        <tempContext> Rho1 </tempContext>
        <tempStore> S1 </tempStore>
        <tempIdStore> Ds1 </tempIdStore>
        <tempMemory> M1 </tempMemory>
        ...
    </contractInstance>
    <exeCon> _ => false </exeCon>
  
// rule <k> funBody(Con,S:Statement Ss:Statements) => funStmt(if(Con){S}) ~> funBody(Con,Ss) ... </k>
rule funBody(Con,S:Statement Ss:Statements) => funStmt(if(Con){S}) ~> funBody(Con,Ss)

// rule <k> funBody(Con,.Statements) => . ... </k>
rule funBody(Con,.Statements) => .

rule 
    <k> funStmt(S) => S ... </k>
    <exeCon> true </exeCon>
           
rule 
    <k> funStmt(S) => . ... </k>
    <exeCon> false </exeCon>

rule 
    <k> functionCall(Sender:Int; C:Int ; F:Id ; Es:Values ; M:Msg) => createTransaction(.List) ~> functionCall(F;Es) ~> returnContext(C) ... </k>
    <contractStack>  (.List => ListItem(C))  ListItem(-1) </contractStack>
    <Msg> M1=>M </Msg>
    <MsgStack> (.List => ListItem(M1)) ... </MsgStack>
    <functionStack> (.List => ListItem(F)) ... </functionStack>
       
rule 
    <k> functionCall(Sender:Int; C:Int ; F:Id ; Es:Values ; M:Msg) =>  createTransaction(L:List) ~> functionCall(F;Es) ~> returnContext(C)  ... </k>
    <contractStack>  (.List => ListItem(C)) L:List ListItem(-1) </contractStack>
    <Msg> M1=>M </Msg>
    <MsgStack> (.List => ListItem(M1)) ... </MsgStack>
    <functionStack> (.List => ListItem(F)) ... </functionStack>
    requires L =/=K .List

  /*rule <k> FunCall(C:Int, F:Id, Es:Values,M:Msg) => createTransaction(L:List) ~> FunQs(FQ,F)~> Call(F,Es) ~> returnContext(C)  ... </k>
        <contractStack>   ListItem(C) L:List ListItem(-1)   </contractStack>
    
        <contractInstance>
     	  <ctId> C </ctId>
          <ctName> Cn:Id </ctName>
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
        </Function>*/
     
rule 
    <k> createTransaction(.List) => . ... </k>
    <cnttran> I:Int => I +Int 1 </cnttran>
    <trancomputation> (.Map => I |-> "functioncall" ) ... </trancomputation>  
    <newStack>  .List </newStack>

rule 
    <k> createTransaction(.List) => . ... </k> 
    <newStack> L </newStack>
    requires L =/=K .List

// rule <k> createTransaction(L) => . ... </k> requires L =/=K .List
rule createTransaction(L) => . 
     requires L =/=K .List

rule 
    <k> returnContext(C:Int) => E ... </k>
    <contractStack> ListItem(C) => .List ... </contractStack>
    <Msg> M => M1 </Msg>
    <MsgStack> ListItem(M1) => .List ... </MsgStack>
    <vposition> _ => 1 </vposition>
    <functionStack> ListItem(F) => .List ... </functionStack>
    <newStack>  L => .List </newStack>
    <contractInstance>
        <ctId> C </ctId>
        <ctName> Cn:Id </ctName>
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

rule 
    <k> return E:Int; => . ...</k>
    <functionStack> ListItem(F:Id) ... </functionStack>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Cn:Id </ctName>
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
        <Return> _ => E </Return>
        ...
    </Function> 
    <exeCon> _ => false </exeCon>

rule 
    <k> return; => . ... </k>
    <exeCon> _ => false </exeCon>

endmodule