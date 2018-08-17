module SOLIDITY-SYNTAX

imports DOMAINS-SYNTAX
imports DOMAINS

syntax SourceUnit ::=  PragmaDirectives ContractDefinitions
                    
syntax PragmaDirectives ::= List{PragmaDirective, ""}
syntax PragmaDirective ::= "pragma" Id "^" Int "." Int "." Int ";"

syntax ContractDefinitions ::= List{ContractDefinition, ""}

syntax ContractDefinition ::= "contract" Id "{" ContractParts "}"
                            | "library" Id "{" ContractParts "}"
                            | "contract" Id "is" Identifiers "{" ContractParts "}"

syntax ContractParts ::= List{ContractPart, " "}

syntax ContractPart ::= StateVariableDeclaration
                      | UsingForDeclaration
                      | StructDefinition 
                      | ModifierDefinition 
                      | EventDefinition
                      | EnumDefinition  
                      | SolidityItem
                      | FunctionDefinition


syntax TypeName ::= ElementaryTypeName
                  | UserDefinedTypeName
                  | ArrayTypeName 
                  | Mapping 
                  | FunctionTypeName

syntax UserDefinedTypeName ::= Id
                              | MemberAccess

syntax MemberAccess ::= Expression "." Id		[klabel(#memberAccess)]

syntax ElementaryTypeName ::=  NotBool
                               | SBool
                              
syntax NotBool ::= "address"
                 | String
                 | "string"
                 | "var"
                 | SInt
                 | Uint
                 | Byte 
                 | Fixed
                 | Ufixed

syntax Expression ::= Bool | Int | String | Id |Value |ElementaryTypeName 
                //  | TypeName 
                    | IncDecExpression
                    | NewExpression
                    | IndexAccess    
                    | MemberAccess   
                    | FunctionCall 
                    | MemOp
                    | "(" Expression ")"	   [bracket]
                    > SimpleExpression1 
                    > Expression "**" Expression [left, strict]
                    > Expression "*" Expression  [left, strict]
                    | Expression "/" Expression  [left, strict]
                    | Expression "%" Expression  [left, strict]
                    > Expression "+" Expression  [left, strict]
                    | Expression "-" Expression  [left, strict]
                    > Expression "<<" Expression [left, strict]
                    | Expression ">>" Expression [left, strict]
                    > Expression "&" Expression  [strict]
                    > Expression "^" Expression  [strict]
                    > Expression "|" Expression  [strict]
                    > SimpleExpression2
                    > Expression "==" Expression [seqstrict,prefer]
                    | Expression "!=" Expression [seqstrict,prefer]
                    > Expression "&&" Expression [left, strict(1)]
                    > Expression "||" Expression [left, strict(1)]
                    > Expression "?" Expression ":" Expression [strict]
                    > PrimaryExpression
                    | BuiltinParam
                 // | "msg"	  		 [prefer]
                 // | "msg.sender"	         [prefer]
                 // | "msg.value"	         [prefer]
                 // | "msg.gas"               [prefer]
                //  | "msg.owner"             [prefer]
                    | Expression "." "length" [prefer]
                    | BaseAddress(Id,Int,Expression,Int)
                    | CntBaseSize(Id,Int,Expression)
                    | SolidityItem
                    | BinaryConvert(Expression,Expression) [strict]
                    | Max(Int,Int)
                    | Min(Int,Int)
                                         
syntax BuiltinParam ::= "msg"	       [prefer]
                      | "msg.sender"   [prefer]
                      | "msg.value"    [prefer]
                      | "msg.gas"      [prefer]
                      | "msg.owner"    [prefer]   
                      | "msg.data"     [prefer]               

syntax Value ::= Int | Bool 

syntax SInt ::= "int"
              | "int8"
              | "int16"
              | "int24"
              | "int32"
              | "int40"
              | "int48"
              | "int56"
              | "int128"
              | "int136"
              | "int144"
              | "int152"
              | "int160"
              | "int168"
              | "int176"
              | "int184"
              | "int192"
              | "int200"
              | "int208"
              | "int216"
              | "int224"
              | "int232"
              | "int240"
              | "int248"
              | "int256"

syntax Uint ::= "uint"
              | "uint8"
              | "uint16"
              | "uint24"
              | "uint32"
              | "uint40"
              | "uint48"
              | "uint56"
              | "uint64"
              | "uint72"
              | "uint80"
              | "uint88"
              | "uint96"
              | "uint104"
              | "uint112"
              | "uint120"
              | "uint128"
              | "uint136"
              | "uint144"
              | "uint152"
              | "uint160"
              | "uint168"
              | "uint176"
              | "uint184"
              | "uint192"
              | "uint200"
              | "uint208"
              | "uint216"
              | "uint224"
              | "uint232"
              | "uint240"
              | "uint248"
              | "uint256"

syntax Byte ::= "byte"
              | "bytes"   
              | "bytes1"  
              | "bytes2"  
              | "bytes3"  
              | "bytes4"  
              | "bytes5"  
              | "bytes6"  
              | "bytes7"  
              | "bytes8"  
              | "bytes9"  
              | "bytes10" 
              | "bytes11" 
              | "bytes12" 
              | "bytes13" 
              | "bytes14" 
              | "bytes15" 
              | "bytes16" 
              | "bytes17" 
              | "bytes18" 
              | "bytes19" 
              | "bytes20" 
              | "bytes21" 
              | "bytes22" 
              | "bytes23" 
              | "bytes24" 
              | "bytes25" 
              | "bytes26" 
              | "bytes27" 
              | "bytes28" 
              | "bytes29" 
              | "bytes30" 
              | "bytes31" 
              | "bytes32" 

syntax SBool ::= "bool"

syntax Fixed ::= "fixed"
                  | "fixed" DecimalNumber "*" DecimalNumber

syntax Ufixed ::= "ufixed"
                | "ufixed" DecimalNumber "*" DecimalNumber

syntax OtherContractPart ::= UsingForDeclaration 
                            | StructDefinition 
                            | ModifierDefinition 
                            | EventDefinition
                            | EnumDefinition  
                            | SolidityItem

syntax StateVariableDeclaration ::= TypeName FunQuantifiers Id ";" 
                                  | TypeName FunQuantifiers Id "=" Expression ";"

 // syntax Specifiers ::= List{Specifier, ""} 

syntax Specifier ::= "public" 
                   | "internal" 
                   | "private" 
                   | "constant"
                   | "pure" 
                   | "view" 
                   | "payable" 
                   | "external"

syntax UsingForDeclaration ::= "using" Id "for" "*" ";"
                             | "using" Id "for" TypeName ";"

syntax StructDefinition ::= "struct" Id "{" VariableDeclarations ";" "}"

syntax VariableDeclarations ::= List{VariableDeclaration, ";"}

syntax VariableDeclaration ::= TypeName StorageLocations Id
                               
syntax ModifierDefinition ::= "modifier" Id "(" FParameters ")" Block
                            | "modifier" Id Block

syntax ModifierInvocation ::= Id 
                            | FunctionCall 
                            
  //syntax ModifierInvocations ::= List{ModifierInvocation," "}
syntax MIParameters ::= FParameters

syntax FunQuantifier ::= ModifierInvocation 
                       | Specifier

syntax FunReturn ::= "returns" "(" FParameters ")" 

/*by Kan
   syntax Ids
        ::= List{Id, " "}
*/

syntax FunQuantifiers ::= List{FunQuantifier," "}

syntax FunReturns  ::= List{FunReturn, " "}

syntax FunctionDefinition ::= "function" Identifiers "(" FParameters ")" FunQuantifiers "returns" "(" FParameters ")"   Block  [prefer]
                            | "function" Identifiers "(" FParameters ")" FunQuantifiers "returns" "(" FParameters ")"  ";"    [prefer]
                            |  "function" Identifiers "(" FParameters ")" FunQuantifiers Block
                            | "function" Identifiers "(" FParameters ")" FunQuantifiers ";" 
  
syntax EventDefinition ::= "event" Id "(" EventParameters ")" ";"
                         | "event" Id  "(" EventParameters ")" "anonymous" ";"

syntax EventDefinitions ::= List{EventDefinition,""}

syntax EventInvocation ::= Id "(" Identifiers ")" ";"
                         | Id "(" Values ")" ";"
                    
//syntax EnumValue ::= Id
syntax EnumDefinition ::= "enum" Id "{" Identifiers "}"
//syntax Enumlist ::= List{EnumValue, ","}

syntax EventParameters ::= List{EventParameter,""}
syntax EventParameter ::= IndexedParameter
                     // | FParameter
                        | VariableDeclaration
                        | TypeName

syntax IndexedParameterList ::= "(" IndexedParameters ")"
syntax IndexedParameters ::= List{IndexedParameter, ","}
syntax IndexedParameter ::= TypeName "Indexed" Id

syntax FParameters ::= List{FParameter, ","}

syntax FParameter ::= VariableDeclaration
                    | TypeName  

//syntax TypeNames ::= List{TypeName, ","}

syntax Mapping ::= "mapping" "(" ElementaryTypeName "=>" TypeName ")"

syntax ArrayTypeName ::= TypeName "[" "]"
                       | IndexAccess

syntax FunctionTypeName ::= "function" "(" FParameters ")" FunQuantifiers 
                          | "function" "(" FParameters ")" FunQuantifiers "returns" "(" FParameters ")"

syntax StorageLocations ::= List{StorageLocation, " "}
syntax StorageLocation ::= "memory" | "storage"  

syntax LocationSpec ::= StorageLocations | FunQuantifiers

syntax Block ::= "{" Statements "}"
syntax Statements ::= List{Statement, ""}
  
syntax Statement ::= IfStatement 
                   | WhileStatement 
                   | ForStatement 
                   | Block 
                   | OtherStatements 

syntax OtherStatements ::= DoWhileStatement 
                         | "continue" ";"
                         | "break" ";"
                         | "return" ";"
                         | "return" Expression ";" [strict]
                         | "throw" ";"
                         | SimpleStatement ";" [strict]
                         | "require" "(" Expression ")" ";" 
                         | "_;"
                         | FunExe(Statements)
                         | FunctionCall ";" [strict]
                         | ExeWhile(Statements)
                         | InitStmts(SimpleStatements) 
                         | EndLoop(Statements)
                         | "revert" "(" ExpressionList ")" ";"
                         | ExeCounters(SimpleStatements)
                                                                
//syntax StateVariableDeclarations ::= List{StateVariableDeclaration,"" }
//  syntax FunctionDefinitions ::= List{FunctionDefinition,"" }
  
syntax SolidityItem ::=  pcsContractParts(Id,ContractParts)
                      | pcsContractPart(Id,ContractPart)
                      | pcsStateVariableDeclarations(Id,Id,VariableDeclarations,Id)
                      | pcsStateVariableDeclaration(Id,Id,VariableDeclaration,Id)
                      | FunQs(FunQuantifiers,Param)
                      | FunQ(FunQuantifier,Param)
                      | FunctionItem
                      | NewArray(Id,Id,Int,Int,Value)
                      | NewIdx(Id,Id,Int,Value)
                      | NewArrayIndex(Int,Id,Int,Int,Value)
                      | NewArrayIndexes(Int,Id,Int,Int,Value)
                      | UpdateEnv(Int)
                      | ArrayUpdate(Int,Int,Id,Int)
                      | InstanceUpdate(Int,Int,Id,Int)
                      | DArrayUpdate(Int,Int,Id,Int)
                      | DInstanceUpdate(Int,Int,Id,Int)
                      | MulDArray(Id,TypeName,Id,Int,Int,Value)
                      | ODArray(Id,TypeName,Id,Int,Int,Value)
                      | NewRows(Int,Id,TypeName,Int,Int,Value)
                      | NewRow(Int,Id,TypeName,Int,Int,Value)
                      | CntLength(Id,Id,TypeName,Int)
                      | cntLength(Id,Id,Int)
                      | ICntLength(Int,Id,TypeName,Int)
                      | IcntLength(Int,Id,Int)
                      | CallConstructor(Id,Int,Int,ExpressionList)
                      | SetSize(Id,Id)
                      | CntSize(Id,Id,Int,Int)
                      | DSize(Id,Id,Int)
                      | ISetSize(Int,Id)
                      | ICntSize(Int,Id,Int,Int)
                      | IDSize(Int,Id,Int)
                      | SetStructSize(Id,Id,Id)
                      | MemOp
                      | IdxAccess(Id,IndexAccess,Int,Expression)
                      | IdxWrite(Id,IndexAccess,Int,Expression,Expression)
                      | ArrayName(IndexAccess,IndexAccess)
                      | ArrayNameW(IndexAccess,IndexAccess,Expression)
                      | NewContract(Id,ExpressionList)
                      //| CallCons(Id,Int,Int,ExpressionList)
                      | FunCall(Expression, Id, ExpressionList, Msg)
                      | WriteIndex(Int,Expression)
                      | UpdateTemp(Int)
                      | Reset(Int)
                      | funBody(Bool,Statements)
                      | funStmt(Statement)
                      | ExeWhileStmt(Statement)
                      | InitStmt(SimpleStatement)
                      | ExeCounter(SimpleStatement)
                      | BitAnd(Expression, Expression) [strict]
                      | ModValue(Int,Expression)  [strict(2)]
                      | BitAndSteps(Int,Int,Int)
                      | BitAndStep(Int,Int,Int)
                      | DecimalConversions(Int,Int)
                      | DecimalConversion(Int,Int)
                      | BinaryValue(Int,Expression) [strict(2)]
                      | GetValue(Int)
                      | BitOr(Expression, Expression) [strict]
                      | BitOrSteps(Int,Int,Int)
                      | BitOrStep(Int,Int,Int)
                      | BitExOr(Expression, Expression) [strict]
                      | BitExOrSteps(Int,Int,Int)
                      | BitExOrStep(Int,Int,Int)
                      | readAddress(Int,Id)
                      | writeToAddress(Int,Expression,Id)
                      | writeIndexToAddress(Int,Expression,Int)
                      | readIndexAddress(Int,Int)
         
syntax MemOp ::= allocate(Expression,TypeName,Id,Expression,Expression)
               | read(Expression)
               | write(Expression,Expression)

syntax Param ::= Int | Id 

syntax IfStatement ::= "if" "(" Expression ")" Statement "else" Statement [strict(1)] 
                     | "if" "(" Expression ")" Statement [strict(1)]

syntax WhileStatement ::= "while" "(" Expression ")" Statement

// TODO: why not adding this to Values? Any reason not to?
syntax Value1 ::= String | Uint | Byte | Fixed | Ufixed | Msg
syntax AllValues ::= Value | Value1

syntax KResult ::=  Values | AllValues
  
syntax SimpleStatement ::= VariableDefinition 
                         | SimpleExpression3 
                       //| FunctionCall 
                         | IncDecExpression 
                         | NewExpression 
                         | AllValues
                         | FunctionItem 
                         | SolidityItem

//syntax ExpStatement ::= KResult 
//syntax NewStatement ::= NewExpression 

syntax ForStatement ::= "for" "(" SimpleStatements ";" ExpressionList ";" SimpleStatements  ")" Statement
 
syntax SimpleStatements ::= List{SimpleStatement,""}

syntax DoWhileStatement ::= "do" Statement "while" "(" Expression ")" ";"

syntax Continue ::= "continue"
syntax Break ::= "break"
syntax Return ::= "return" Expression
                  | "return"
syntax Throw ::= "throw"

syntax VariableDefinition ::= "var" Id
                            | VariableDeclaration
                          //| "var" Id "=" Expression
                            | VariableDeclaration "=" Expression

syntax Identifiers ::= List{Id, ","}

syntax SimpleExpression1 ::= "!" Expression [strict]
                           | "~" Expression
                           | "+" PrimaryExpression [left, strict]
                           | "-" PrimaryExpression [left, strict]

syntax SimpleExpression2 ::= Expression "<" Expression   [seqstrict]
                           | Expression ">" Expression   [seqstrict]
                           | Expression "<=" Expression  [seqstrict]
                           | Expression ">=" Expression  [seqstrict]

syntax SimpleExpression3 ::= Expression "=" Expression  [strict(2), klabel(#assign1)]
                           | Expression "|=" Expression [strict(2)]
                           | Expression "^=" Expression [strict(2)]
                           | Expression "&=" Expression [strict(2)]
                           | Expression "<<=" Expression   [strict(2)]
                           | Expression ">>=" Expression   [strict(2)]
                           | Expression "+=" Expression    [strict(2)]
                           | Expression "-=" Expression    [strict(2)]
                           | Expression "*=" Expression    [strict(2)]
                           | Expression "/=" Expression    [strict(2)]
                           | Expression "%=" Expression    [strict(2)]
                           | "delete" Expression
                           | Id "[" Expression "]" "+=" Expression  [strict(2,3),prefer] 
                           | Id "[" Expression "]" "=" Expression  [strict(2,3),prefer] 
                           | Id "[" Expression "]" "-=" Expression  [strict(2,3),prefer]
                           | Id "[" Expression "]" "%=" Expression  [strict(2,3),prefer]
                           | Id "." "push" "(" Int ")" [prefer]
                             
syntax IncDecExpression ::= Expression "++"
                          | Expression "--"
                          | "++" Expression
                          | "--" Expression 

syntax PrimaryExpression ::= BooleanLiteral
                           | NumberLiteral
                           | HexLiteral
                           | StringLiteral
                           | TupleExpression
                           | Id
                           | ElementaryTypeNameExpression

syntax ExpressionList ::= List{Expression, ","}    [strict]


syntax FunctionCall ::= Expression "(" FunctionCallArguments ")" [strict(2),klabel(#functionCall)]

syntax FunctionCallArguments ::= ExpressionList		
                               | "{" NameValueList "}" [strict]

syntax ExpressionList ::= Values | FParameters

syntax FParameters ::= Identifiers 
                   //| Enumlist

syntax NameValue ::= Id ":" Expression        [strict(2)]
syntax NameValueList ::= List{NameValue, ","} [strict]
   
syntax NewExpression ::= "new" TypeName

syntax IndexAccess ::= TypeName "[" Expression "]"  [strict (2),klabel(#indexAccess)]		

syntax Values ::= List{Value, ","}

syntax BooleanLiteral ::= Bool

syntax NumberLiteral ::= HexNumber
                       | DecimalNumber
                       | HexNumber " " NumberUnit
                       | DecimalNumber " " NumberUnit

syntax NumberUnit ::= "wei" | "szabo" | "finney"  | "ether" | "seconds" | "minutes" | "hours" | "days"  | "weeks" | "years"

syntax StringLiteral ::= String

syntax HexNumber ::= String                      

syntax DecimalNumber ::= Int

syntax TupleExpression ::= "(" ExpressionList ")"			[klabel(tupleExp1),prefer]
                         | "[" ExpressionList "]"

syntax ElementaryTypeNameExpression ::= ElementaryTypeName
   
syntax Expression ::= Msg 

syntax Msg ::= msginfo(Expression,Expression,Expression,Expression)	[strict]
             | "#emptymsg"
           //| "msg"
 
syntax FunctionCall ::= "functionCall" "(" Expression ";" Expression ";" Id ";" ExpressionList ";" Msg ")" [strict(1,2,4)]
                      | "functionCall" "(" Id ";" ExpressionList ")"				[strict(2)] 
                    //| "functionCall" "(" Expression ";" Id ";" ExpressionList ";" Msg ")"	[strict(1,3)]
                    //| "functionCall" "(" Id ";" ExpressionList ";" Msg ")"			[strict(2)]

syntax FunctionItem ::= returnValue(Statements)	[strict]
                      | returnValue(Int)
                      | addMsg(Msg)
                      | returnContext(Int)
                      | UpdateContext(Int)
                      | createTransaction(List)
                      | Call(Id,Values)

syntax Id ::= "returns" [reject]

syntax HexNumber ::= r"0x[0-9a-fA-F]+" [token]
syntax HexLiteral ::= r"hex(\"([0-9a-fA-F]{2})*\"|\\'([0-9a-fA-F]{2})*\\')" [token]
syntax DecimalNumber ::= Int | Float

endmodule
