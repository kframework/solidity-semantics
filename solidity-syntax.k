

module SOLIDITY-SYNTAX
 
  syntax SourceUnit ::=  PragmaDirectives ContractDefinitions
                      
  syntax PragmaDirectives ::= List{PragmaDirective, ""}

  syntax ContractDefinitions ::= List{ContractDefinition, ""}

  syntax PragmaDirective ::= "pragma" Id "^" Int "." Int "." Int ";"

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


  syntax OtherContractPart ::=  
                         UsingForDeclaration 
                        | StructDefinition 
                        | ModifierDefinition 
                        | EventDefinition
                        | EnumDefinition  
                        | SolidityItem

  syntax StateVariableDeclaration ::= TypeName Specifiers Id ";" 
                                    | TypeName Specifiers Id "=" Expression ";"
                                                               


  syntax Specifier ::= "public" | "internal" | "private" | "constant"
                     | "pure" | "view" | "payable" | "external"

  syntax UsingForDeclaration ::= "using" Id "for" "*" ";"
                               | "using" Id "for" TypeName ";"

  syntax StructDefinition ::= "struct" Id "{" VariableDeclarations ";" "}"

  syntax VariableDeclarations ::= List{VariableDeclaration, ";"}

  syntax VariableDeclaration ::= TypeName StorageLocations Id
                               
  syntax ModifierDefinition ::= "modifier" Id "(" Parameters ")" Block
                              | "modifier" Id Block

  syntax ModifierInvocation ::= Id 
                              | FunctionCall
                            

  syntax MIParameters ::= ExpressionList

  syntax FunQuantifier ::= ModifierInvocation 
                         | Specifier

  syntax FunReturn
          ::= "returns" "(" Parameters ")" 


  syntax Ids
        ::= List{Id, " "}

  syntax FunQuantifiers ::= List{FunQuantifier," "}

  syntax FunReturns  ::= List{FunReturn, " "}
/*
syntax FunctionDefinition ::= 
             "function" Ids "(" Parameters ")" FunQuantifiers
              FunReturns  Block
            | "function" Ids "(" Parameters ")" FunQuantifiers
               FunReturns ";" 
*/ 

  syntax FunctionDefinition ::= 
             "function" Ids "(" Parameters ")" FunQuantifiers
              "returns" "(" Parameters ")"   Block  [prefer]
            | "function" Ids "(" Parameters ")" FunQuantifiers
               "returns" "(" Parameters ")"  ";"    [prefer]
            |  "function" Ids "(" Parameters ")" FunQuantifiers
                 Block
            | "function" Ids "(" Parameters ")" FunQuantifiers
                ";" 
  syntax Specifiers ::= List{Specifier, ""} 
  
  syntax EventDefinition ::= "event" Id "(" EventParameters ")" ";"
                           | "event" Id  "(" EventParameters ")" "anonymous" ";"
  syntax EventDefinitions ::= List{EventDefinition,""}

  syntax EventInvocation ::= Id "(" Identifiers ")" ";"
                           | Id "(" Values ")" ";"
                    
  syntax EnumValue ::= Id
  syntax EnumDefinition ::= "enum" Id "{" Enumlist "}"
  syntax Enumlist ::= List{EnumValue, ","}

  syntax EventParameters ::= List{EventParameter,""}
  syntax EventParameter ::= IndexedParameter
                          | Parameter

  syntax IndexedParameterList ::= "(" IndexedParameters ")"
  syntax IndexedParameters ::= List{IndexedParameter, ","}
  syntax IndexedParameter ::= TypeName "Indexed" Id

  syntax Parameters ::= List{Parameter, ","}

  syntax Parameter ::= VariableDeclaration
                    | TypeName  


  syntax TypeNames ::= List{TypeName, ","}

  syntax TypeName ::= ElementaryTypeName
                  | UserDefinedTypeName
                  | ArrayTypeName 
                  | Mapping 
                  | FunctionTypeName
            

  syntax UserDefinedTypeName ::= Id
                               | MemberAccess

  syntax Mapping ::= "mapping" "(" ElementaryTypeName "=>" TypeName ")"


  syntax ArrayTypeName ::= TypeName "[" "]"
                         | IndexAccess


  syntax FunctionTypeName ::= "function" "(" Parameters ")" Specifiers
                            | "function" "(" Parameters ")" Specifiers "returns" "(" Parameters ")"
                              

  syntax StorageLocations ::= List{StorageLocation, " "}
  syntax StorageLocation ::= "memory" | "storage"  

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
                           | "_" ";"
                           | FunExe(Statements)
                          
                          
                                                                
  syntax StateVariableDeclarations ::= List{StateVariableDeclaration,"" }

  syntax FunctionDefinitions ::= List{FunctionDefinition,"" }          
  syntax SolidityItem
       ::=  pcsContractParts(Id,ContractParts)
         | pcsContractPart(Id,ContractPart)
         | pcsStateVariableDeclarations(Id,Id,VariableDeclarations,Id)
         | pcsStateVariableDeclaration(Id,Id,VariableDeclaration,Id)
         | FunQs(FunQuantifiers,Param)
         | FunQ(FunQuantifier,Param)
         | FunctionItem
         | NewArray(Id,Id,Int,Int)
         | NewIdx(Id,Id,Int)
         | NewArrayIndex(Int,Id,Int,Int)
         | NewArrayIndexes(Int,Id,Int,Int)
         | UpdateEnv(Int)
         | ArrayUpdate(Int,Int,Id,Int)
         | InstanceUpdate(Int,Int,Id,Int)
         | DArrayUpdate(Int,Int,Id,Int)
         | DInstanceUpdate(Int,Int,Id,Int)
         | MulDArray(Id,TypeName,Id,Int,Int)
         | ODArray(Id,TypeName,Id,Int,Int)
         | NewRows(Int,Id,TypeName,Int,Int)
         | NewRow(Int,Id,TypeName,Int,Int)
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

        
 


  syntax Param ::= Int | Id 


  syntax IfStatement ::= "if" "(" Expression ")" Statement "else" Statement [strict(1)] 
                       | "if" "(" Expression ")" Statement [strict(1)]
  

  syntax WhileStatement ::= "while" "(" Expression ")" Statement


  syntax SimpleStatement ::= VariableDefinition | SimpleExpression3 | FunctionCall | IncDecExpression 


  syntax ForStatement ::= "for" "(" SimpleStatements ";" ExpressionList ";" SimpleStatements  ")" Statement
 
  syntax SimpleStatements ::= List{SimpleStatement,""}

  syntax DoWhileStatement ::= "do" Statement "while" "(" Expression ")"

  syntax Continue ::= "continue"
  syntax Break ::= "break"
  syntax Return ::= "return" Expression
                  | "return"
  syntax Throw ::= "throw"
  syntax RewritingStatement ::= Expression "=>" Expression


  syntax VariableDefinition ::= "var" Id
                              | VariableDeclaration
                              | "var" Id "=" Expression
                              | VariableDeclaration "=" Expression


  syntax Identifiers ::= List{Id, ","}
  

  syntax Expression ::= Bool | Int | String | Id |Value |ElementaryTypeName 
                      | IncDecExpression
                      | NewExpression
                      | IndexAccess    
                      | MemberAccess   
                      | FunctionCall
                      | "(" Expression ")"  [bracket]
                      > SimpleExpression1 
                      > Expression "**" Expression [left, strict]
                      > Expression "*" Expression  [left, strict]
                      | Expression "/" Expression  [left, strict]
                      | Expression "%" Expression  [left, strict]
                      > Expression "+" Expression  [left, strict]
                      | Expression "-" Expression  [left, strict]
                      > Expression "<<" Expression [left, strict]
                      | Expression ">>" Expression [left, strict]
                      > Expression "&" Expression
                      > Expression "^" Expression
                      > Expression "|" Expression
                      > SimpleExpression2
                      > Expression "==" Expression [seqstrict]
                      | Expression "!=" Expression [seqstrict]
                      > Expression "&&" Expression [left, strict(1)]
                      > Expression "||" Expression [left, strict(1)]
                      > Expression "?" Expression ":" Expression [strict]
                      > PrimaryExpression
                       | "msg"	  		 [prefer]
	               | "msg.sender"	         [prefer]
	               | "msg.value"	         [prefer]
                       | "msg.gas"               [prefer]
                       | "msg.owner"             [prefer]
                       | Id "." "length" [prefer]
                       
         

   syntax SimpleExpression1 ::= "!" Expression [strict]
                              | "~" Expression
                              | "+" PrimaryExpression [left, strict]
                              | "-" PrimaryExpression [left, strict]

   syntax SimpleExpression2 ::= Expression "<" Expression   [seqstrict]
                              | Expression ">" Expression   [seqstrict]
                              | Expression "<=" Expression  [seqstrict]
                              | Expression ">=" Expression  [seqstrict]

   syntax SimpleExpression3 ::= Expression "=" Expression  [strict(2)]
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
                             

   syntax IncDecExpression ::= Expression "++"  [strict]
                    | Expression "--"  [strict]
                    | "++" Expression  [strict]
                    | "--" Expression  [strict] 

   syntax PrimaryExpression ::= BooleanLiteral
                              | NumberLiteral
                              | HexLiteral
                              | StringLiteral
                              | TupleExpression
                              | Id
                              | ElementaryTypeNameExpression

   syntax ExpressionList ::= List{Expression, ","}    [strict]


   syntax FunctionCall ::= Expression "(" FunctionCallArguments ")" [strict(2)]

   syntax FunctionCallArguments ::= ExpressionList | "{" NameValueList "}" [strict]

   syntax NameValue ::= Id ":" Expression            [strict(2)]
   syntax NameValueList ::= List{NameValue, ","}       [strict]

   
   syntax NewExpression ::= "new" TypeName
                                                
   syntax MemberAccess ::= Expression "." Id                         

   syntax IndexAccess ::= TypeName "[" Expression "]"  [strict(2)]

   syntax Value
       ::= Int | Bool 

   syntax Values
       ::= List{Value, ","}

   syntax BooleanLiteral ::= Bool
   syntax NumberLiteral ::= HexNumber
                          | DecimalNumber
                          | HexNumber " " NumberUnit
                          | DecimalNumber " " NumberUnit
   syntax NumberUnit ::= "wei" | "szabo" | "finney"  | "ether" | "seconds" | "minutes" | "hours" | "days"  | "weeks" | "years"
   syntax HexLiteral ::= "hex"
   syntax StringLiteral ::= String
   syntax HexNumber ::= String                      

   syntax DecimalNumber ::= Int

   syntax TupleExpression ::= "(" ExpressionList ")"
                            | "[" ExpressionList "]"

   syntax ElementaryTypeNameExpression ::= ElementaryTypeName
   syntax ElementaryTypeName ::=  NotBool
                               | SBool
                              
     syntax NotBool ::=        "address"
                               | String
                               | "var"
                               | SInt
                               | Uint
                               | Byte 
                               | Fixed
                               | Ufixed

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
                 | "bytes"   [prefer]
                 | "bytes1"  [prefer]
                 | "bytes2"  [prefer]
                 | "bytes3"  [prefer]
                 | "bytes4"  [prefer]
                 | "bytes5"  [prefer]
                 | "bytes6"  [prefer]
                 | "bytes7"  [prefer]
                 | "bytes8"  [prefer]
                 | "bytes9"  [prefer]
                 | "bytes10" [prefer]
                 | "bytes11" [prefer]
                 | "bytes12" [prefer]
                 | "bytes13" [prefer]
                 | "bytes14" [prefer]
                 | "bytes15" [prefer]
                 | "bytes16" [prefer]
                 | "bytes17" [prefer]
                 | "bytes18" [prefer]
                 | "bytes19" [prefer]
                 | "bytes20" [prefer]
                 | "bytes21" [prefer]
                 | "bytes22" [prefer]
                 | "bytes23" [prefer]
                 | "bytes24" [prefer]
                 | "bytes25" [prefer]
                 | "bytes26" [prefer]
                 | "bytes27" [prefer]
                 | "bytes28" [prefer]
                 | "bytes29" [prefer]
                 | "bytes30" [prefer]
                 | "bytes31" [prefer]
                 | "bytes32" [prefer]

   syntax SBool ::= "bool"

   syntax Fixed ::= "fixed"
                  | "fixed" DecimalNumber "*" DecimalNumber
   syntax Ufixed ::= "ufixed"
                   | "ufixed" DecimalNumber "*" DecimalNumber
  
   
   syntax Expression
       ::= Msg 

   syntax Msg
      ::= msginfo(Expression,Expression,Expression,Expression)	[strict]
        | "#emptymsg"
        | "msg"
 
   syntax FunctionCall
       ::= "functionCall" "(" Expression ";" Expression ";" Id ";" ExpressionList ";" Msg ")" [strict(1,2,4)]
         | "functionCall" "(" Expression ";" Id ";" ExpressionList ";" Msg ")"	[strict(1,3)]
         | "functionCall" "(" Id ";" ExpressionList ";" Msg ")"			[strict(2)]
	 | "functionCall" "(" Id ";" ExpressionList ")"				[strict(2)] 
       


   syntax FunctionItem
       ::= returnValue(Statements)	[strict]
         | returnValue(Int)
         | addMsg(Msg)
	 | returnContext(Int)
         | UpdateContext(Int)
	 | createTransaction(List)
         | Call(Id,Values)
                 
        

   syntax List

   syntax Id ::= "returns" [reject]

endmodule
