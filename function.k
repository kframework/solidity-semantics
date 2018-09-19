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
    (.Bag =>
    <contractInstance>
        <ctId> -1 </ctId>
        <ctContext> .Map </ctContext>
        <ctStore> .Map </ctStore>
        ...
    </contractInstance>)
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
     (.Bag =>
    <contractInstance>
        <ctId> -1 </ctId>
        <ctContext> .Map </ctContext>
        <ctStore> .Map </ctStore>
        ...
    </contractInstance>)
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
        <Memory> .Map => (!N:Int |-> E) ... </Memory>
        <ctLocation> .Map =>( P |-> String2Id("Local")) ...</ctLocation>
        <ctType> .Map =>(P |-> T) ... </ctType>
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
    <functionStack> (.List => ListItem(#state(RhoC,F,0))) ... </functionStack>
    <contractInstance>
        <ctId> Sender </ctId>
        <globalContext> RhoG </globalContext>
        <ctContext> RhoC => RhoG </ctContext>
        ...
    </contractInstance>

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
  
rule 
    funBody(Con,S:Statement Ss:Statements) => funStmt(if(Con){S}) ~> funBody(Con,Ss)

rule 
    funBody(Con,.Statements) => .

rule 
    <k> funStmt(S) => S ... </k>
    <exeCon> true </exeCon>
           
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
    <k> returnContext(C:Int) => E:Value ... </k>
    <contractStack> ListItem(C) ListItem(S) => ListItem(S) ... </contractStack>
    <Msg> M => M1 </Msg>
    <MsgStack> ListItem(M1) => .List ... </MsgStack>
    <vposition> _ => 1 </vposition>
    <functionStack> ListItem(#state(Rho:Map,F,E)) => .List ... </functionStack>
    <newStack>  L => .List </newStack>
    <contractInstance>
        <ctId> C </ctId>
        <ctName> Cn:Id </ctName>
        <ctContext> _ => RhoG </ctContext>
        <globalContext> RhoG </globalContext>
        ...
    </contractInstance>
    <contractInstance>
        <ctId> S </ctId>
        <ctContext> _ => Rho </ctContext>
        ...
    </contractInstance>

rule 
    <k> return E:Int; => . ...</k>
    <functionStack> ListItem(#state(_,_,_=>E)) ... </functionStack>
    <exeCon> _ => false </exeCon>

rule 
    <k> return; => . ... </k>
    <exeCon> _ => false </exeCon>

// TODO: move in correct place
rule 
    <k> logValue(V:Int); => . ... </k>
    <outputLog> ... .List => ListItem(V) </outputLog>

endmodule
