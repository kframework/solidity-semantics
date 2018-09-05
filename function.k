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
    <cntFunction> CF:Int => CF +Int 1  </cntFunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputParameters> Ps1 </inputParameters>
            <outputParameters> Ps2 </outputParameters>
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
    <cntFunction> CF:Int => CF +Int 1  </cntFunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputParameters> Ps1 </inputParameters>
            <outputParameters> Ps2 </outputParameters>
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
    <cntFunction> CF:Int => CF +Int 1 </cntFunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputParameters> Ps1 </inputParameters>
            <outputParameters> .FParameters </outputParameters>
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
    <cntFunction> CF:Int => CF +Int 1  </cntFunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputParameters> Ps1 </inputParameters>
            <outputParameters> .FParameters </outputParameters>
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
    <cntFunction> CF:Int => CF +Int 1  </cntFunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputParameters> Ps1 </inputParameters>
            <outputParameters> .FParameters </outputParameters>
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
    <cntFunction> CF:Int => CF +Int 1  </cntFunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputParameters> Ps1 </inputParameters> 
            <outputParameters> Ps2 </outputParameters>
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
    <cntFunction> CF:Int => CF +Int 1  </cntFunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputParameters> Ps1 </inputParameters>
            <outputParameters> .FParameters </outputParameters>
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
    <cntFunction> CF:Int => CF +Int 1  </cntFunction>
    (.Bag =>
        <Function>
            <fId> CF </fId>
            <inputParameters> P1 </inputParameters>
            <outputParameters> Ps2 </outputParameters>
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
        <ctName> C </ctName>
        <ctContext> .Map => (P |-> !N:Int) ... </ctContext>
        <ctType> .Map =>(P |-> T) ... </ctType>
        <ctStore> .Map => (!N |-> E) ... </ctStore>
        <ctLocation> .Map =>( P |-> String2Id("Global")) ...</ctLocation>
        ...
    </contractInstance>

// FunQuantifiers
       
rule FunQs(FQ:FunQuantifier FQs:FunQuantifiers,F:Param) => FunQ(FQ,F) ~> FunQs(FQs,F)
rule FunQs(.FunQuantifiers,F:Param) => .
      
// Specifier

rule FunQ(FQ:Specifier,F:Param) => .
      
// ModifierInvocation

rule 
    <k> FunQ(X:Id, F:Param) => . ... </k>
    <Contract>
        ...
        <mname> X </mname>
        <condition> Con:Expression </condition>
        <cfunction> ... (F |-> CF:Int) ... </cfunction>
    </Contract>            
    <fId> CF </fId>
    <inputParameters> Ps1 </inputParameters>
    <outputParameters> Ps2 </outputParameters>
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
    <inputParameters> Ps1 </inputParameters>
    <outputParameters> Ps2 </outputParameters>
    <body> B:K </body>
    <FunQuantifiers> FQ </FunQuantifiers>
    <FunCon> (FC:Expression => (FC && Con)) </FunCon>

// ModifierDefinition

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

// Functioncall

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
        <inputParameters> Ps:FParameters </inputParameters>
        <body> B:Statements </body>
        <FunQuantifiers> FQ </FunQuantifiers>
        <FunCon> Con </FunCon>
        ...
    </Function>

rule
    <k> functionCall(Sender:Int ; C:Int ; F:Id ; Es:Values ; M:Msg) => 
            createTransaction(L) ~> 
            functionCall(F ; Es) ~> 
            returnContext(C) ... </k>
    <contractStack> (.List => ListItem(C)) L:List </contractStack>
    <Msg> M1 => M </Msg>
    <MsgStack> (.List => ListItem(M1)) ... </MsgStack>
    <functionStack> (.List => ListItem(F)) ... </functionStack>

rule
    <k> BindParam(T:SBool .StorageLocations P:Id, .Values) => BindParam(T:SBool .StorageLocations P,false) ... </k>

rule 
    <k> BindParam(T:NotBoolByte .StorageLocations P:Id, .Values) => BindParam(T .StorageLocations P,0) ... </k>

rule 
    <k> BindParam(T:TypeName, .Values) => . ...</k>

rule 
    <k> Call(F:Id,Es:Values) => BindParam(Ps,Es) ~> BindParam(OPs,.Values) ~> funBody(Con,B) ~> UpdateTemp(CI)  ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctName> Cn:Id </ctName>
        <ctContext> Rho </ctContext>
        <ctStore> S </ctStore>
        <idStore> Ds </idStore>
        <Memory> M </Memory>
        <ctType> T </ctType>
        <ctLocation> L </ctLocation>
        <tempContext> _=> Rho </tempContext>
        <tempStore> _=>S </tempStore>
        <tempIdStore> _=>Ds </tempIdStore>
        <tempMemory> _=>M </tempMemory>
        <tempType> _=>T </tempType>
        <tempLocation> _=>L </tempLocation>
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
        <inputParameters> Ps:FParameters </inputParameters>
        <outputParameters> OPs:FParameters </outputParameters>
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
        <ctType> T </ctType>
        <ctLocation> L </ctLocation>
        <tempContext> Rho1=>Rho </tempContext>
        <tempStore> S1=>S </tempStore>
        <tempIdStore> Ds1 => Ds </tempIdStore>
        <tempMemory> M1 => M </tempMemory>
        <tempType> T1=>T </tempType>
        <tempLocation> L1=>L </tempLocation>
        ...
    </contractInstance>  
    <exeCon> _=> true </exeCon>
    <forInit> _=> true </forInit>
    <Throw> _=> false </Throw>

rule 
    <k> throw; => . ... </k>
    <contractStack> ListItem(CI:Int) ... </contractStack>
    <contractInstance>
        <ctId> CI </ctId>
        <ctContext> Rho => Rho1 </ctContext>
        <ctStore> S => S1 </ctStore>
        <idStore> Ds => Ds1 </idStore>
        <Memory> M => M1 </Memory>
        <ctType> T => T1 </ctType>
        <ctLocation> L => L1 </ctLocation>
        <tempContext> Rho1 </tempContext>
        <tempStore> S1 </tempStore>
        <tempIdStore> Ds1 </tempIdStore>
        <tempMemory> M1 </tempMemory>
        <tempType> T1 </tempType>
        <tempLocation> L1 </tempLocation>
        ...
    </contractInstance>
    <exeCon> _ => false </exeCon>
  
rule 
    funBody(Con,S:Statement Ss:Statements) => funStmt(if(Con){S}) ~> funBody(Con,Ss)

rule 
    funBody(Con,.Statements) => .

rule 
    <k> funStmt(S) => S ... </k>
    <exeCon> true </exeCon>
    <Throw> false </Throw>

rule 
    <k> funStmt(S) => throw; ... </k>
    <exeCon> true </exeCon>
    <Throw> true </Throw>
           
rule 
    <k> funStmt(S) => . ... </k>
    <exeCon> false </exeCon>
     
rule 
    <k> createTransaction(ListItem(-1)) => . ... </k>
    <newStack> .List </newStack>
    <cnttran> I:Int => I +Int 1 </cnttran>
    <tranComputation> (.Map => I |-> "functioncall" ) ... </tranComputation>  

rule 
    <k> createTransaction(ListItem(-1)) => . ... </k> 
    <newStack> L </newStack>
    requires L =/=K .List

rule 
    createTransaction(L ListItem(-1)) => . 
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
    <k> return E:KResult => 1 ... </k>
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
    <k> return => 1 ... </k>
    <exeCon> _ => false </exeCon>

endmodule
