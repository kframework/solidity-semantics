

module SOLIDITY-SYNTAX

import DOMAINS-SYNTAX
import DOMAINS

syntax SourceUnit ::=  PragmaDirectives ContractDefinitions

syntax PragmaDirectives ::= List{PragmaDirective, ""}
syntax PragmaDirective ::= "pragma" Id "^" Int "." Int "." Int ";"

syntax ContractDefinitions ::= List{ContractDefinition, ""}  [klabel(#contractDefs)]

syntax ContractDefinition ::= "contract" Id "{" ContractParts "}"  [klabel(#contractDef)]
                            | "library" Id "{" ContractParts "}"
                            | "contract" Id "is" Identifiers "{" ContractParts "}"

syntax ContractParts ::= List{ContractPart, " "}   [klabel(#contractParts)]

syntax ContractPart ::= StateVariableDeclaration
                      | FunctionDefinition


syntax TypeName ::= NonArrayType
                  | ArrayTypeName

syntax NonArrayType ::= ElementaryTypeName | UserDefinedTypeName | Mapping

syntax UserDefinedTypeName ::= Id

syntax Mapping ::= "mapping" "(" ElementaryTypeName "=>" TypeName ")"


syntax ElementaryTypeName ::= AddressType | AddressPayableType | "string" | "var" | "bool" | SolidityInt | SolidityUint

syntax AddressPayableType ::= "address payable" [klabel(#address-payable)]

syntax AddressType ::= "address" [klabel(#address)]

syntax ArrayTypeName ::= TypeName "[" Expression "]" [strict(2)]
                       | TypeName "[" "]"


syntax SolidityInt ::= "int"
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

syntax SolidityUint ::= "uint"
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

syntax StateVariableDeclaration ::= TypeName FunQuantifiers Id ";"  [klabel(#stateVarDecl)]
                                  | TypeName FunQuantifiers Id "=" Expression ";"  [klabel(#stateVarDeclWithAssignment)]

syntax FunQuantifier ::= ModifierInvocation
                       | Specifier

syntax ModifierInvocation ::= Id
                            | FunctionCall

syntax Specifier ::= "public"
                   | "internal"
                   | "private"
                   | "constant"
                   | "pure"
                   | "view"
                   | "payable"
                   | "external"

syntax FunQuantifiers ::= List{FunQuantifier," "}

syntax FunctionDefinition ::= "function" IdentifierOrNone "(" FParameters ")" FunQuantifiers "returns" "(" FParameters ")"   Block  [prefer]
                            | "function" IdentifierOrNone "(" FParameters ")" FunQuantifiers "returns" "(" FParameters ")"  ";"    [prefer]
                            | "function" IdentifierOrNone "(" FParameters ")" FunQuantifiers Block
                            | "function" IdentifierOrNone "(" FParameters ")" FunQuantifiers ";"
                            | "constructor" "(" FParameters ")" FunQuantifiers Block

syntax IdentifierOrNone
          ::= Id
            | ""     [klabel(#none), onlyLabel]

syntax FParameter ::= VariableDeclaration
                    | TypeName

syntax FParameters ::= List{FParameter, ","}   [klabel(#fParameters)]

syntax VariableDeclaration ::= TypeName StorageLocations Id   [klabel(#varDeclaration)]

syntax StorageLocations ::= List{StorageLocation, " "}
syntax StorageLocation ::= Memory | "storage" 
syntax Memory ::= "memory"
syntax Memories ::= List{Memory, " "}
syntax StorageLocations ::= Memories

syntax Block ::= "{" Statements "}"   [klabel(#block)]
syntax Statements ::= List{Statement, ""}   [klabel(#statements)]

syntax Statement ::= BlockStatement
                   | SimpleStatement ";" [strict,klabel(#simpleStmt)]
                   | Break
                   | Continue
                   | "#loop_mark"

syntax SimpleStatement ::= FunctionCall
                         | Assignment
                         | Value
                         | VariableDefinition
                         | Return
                         | NewExpression
                         | MemOperation

syntax BlockStatement ::= IfStatement
                        | WhileStatement
                        | Block

syntax FunctionCall ::= Id "(" FunctionCallArguments ")" [strict(2),klabel(#localFunctionCall)]
                      | MemberAccess "(" FunctionCallArguments ")" [strict(2),klabel(#externalFunctionCall)]
                      | "functionCall" "(" Expression ";" Id ";" ExpressionList ")" [strict(1,3)]
                      | "functionCall" "(" Id ";" ExpressionList ")" [strict(2)]


syntax FunctionCallArguments ::= ExpressionList
                               | "{" NameValueList "}" [strict]

syntax ExpressionList ::= List{Expression, ","}    [strict]

syntax NameValue ::= Id ":" Expression        [strict(2)]
syntax NameValueList ::= List{NameValue, ","} [strict]

syntax Assignment ::= Expression "=" Expression  [strict(2), klabel(#assign)]

syntax VariableDefinition ::= "var" Id
                            | VariableDeclaration
                            | VariableDeclaration "=" Expression    [strict(2)]

syntax KResult ::= Value | Values

syntax Value
       ::= ValueResult | #tupleExp(ExpressionList) | #arrayExp(Expression) | #newArray(TypeName, Int)

syntax Values
       ::= List{Value, ","}

syntax ExpressionList ::= Values

syntax ValueResult ::= Bool | Int | String

syntax Return ::= "return" Expression [strict]
                | "return"

syntax Break ::= "break" ";"

syntax Continue ::= "continue" ";"

syntax NewExpression ::= "new" TypeName "(" ExpressionList ")"

syntax TupleExpression ::= "[" ExpressionList "]"       [klabel(#bracketTuple),strict(1)]
//                         | "(" ExpressionList ")"       [klabel(#parTuple),strict(1)]

syntax Expression ::= Id | Value
                | NewExpression
                | IndexAccess
                | FunctionCall
                > left:
                  MemberAccess
                | TupleExpression
                > left:
                  Expression "*" Expression            [klabel(#multexp),strict,left]
                | Expression "/" Expression            [klabel(#divtexp),strict,left]
                > left:
                  Expression "+" Expression            [klabel(#addexp),strict,left]
                | Expression "-" Expression            [klabel(#subexp),strict,left]
                > left:
                  Expression "<" Expression            [klabel(#less),seqstrict,left]
                | Expression "<=" Expression            [klabel(#leq),seqstrict,left]
                | Expression ">" Expression            [klabel(#great),seqstrict,left]
                | Expression ">=" Expression            [klabel(#geq),seqstrict,left]
                > left:
                  Expression "&&" Expression            [klabel(#and),seqstrict,left]
                | Expression "||" Expression            [klabel(#or),seqstrict,left]

syntax IfStatement ::= "if" "(" Expression ")" Statement "else" Statement [strict(1)]
                     | "if" "(" Expression ")" Statement [strict(1)]

syntax WhileStatement ::= "while" "(" Expression ")" Statement

syntax Identifiers ::= List{Id, ","}        [klabel(#identifiers)]

syntax MemberAccess ::= Expression "." Id        [klabel(#memberAccess), strict(1)]

syntax IndexAccess ::= Expression "[" Expression "]"        [strict(2), klabel(#indexAccess)]
                     | Expression "[" "]"

syntax AccountId
       ::=  Id | "#Testing-Engine#"

syntax ContractInstanceSig
       ::= #account(Int,AccountId)

syntax ValueResult
       ::= "#undef_Value"
         | "#end_Exp"

syntax VarInfo
       ::= #varInfo(Id, Expression, TypeName, MemFlag, Expression) 	[strict(2,5)]
         | #storedVar(Int, TypeName, MemFlag, Int, Int, VarTypeFlag)

syntax MemOperation
        ::= #read(Expression)
          | #readAddress(Expression, MemFlag) 							[strict(1)]
          | #write(Expression, Expression) 									[strict(2)]
          | #writeAddress(Expression, Expression, MemFlag) 	[strict(1,2)]
          | #allocate(Int, AccountId, VarInfo)      

syntax MemFlag
       ::= "#mem"
         | "#storage"

syntax OperandFlag
       ::= "#left"
         | "#right"

syntax VarTypeFlag
       ::= "#fixed-size"
         | "#dynamic"

syntax ArrayOpFlag
       ::= "#getLength"
         | "#getAddr"
         | PushOrPop

syntax PushOrPop 
       ::= "#push"
         | "#pop"

syntax Exec
       ::= "#execute"

syntax SolidityItem ::= #exeStmt(Statement)
                      | AbnormalTerminationCode
                      | #allocateArray(MemOperation, Expression, Int, VarTypeFlag)                              
                      | #readArray(Expression, IndexAccess)
                      | #writeArray(Expression, IndexAccess, Expression)
                      | #assignArray(Id, ExpressionList, Expression, Expression, TypeName) 		[strict(3,4)]
                      | #allocateDynamicArray(Int, AccountId, VarInfo, Expression)           [strict(4)]
                      | #copyArray(Int, MemFlag, Int, MemFlag, Int, Int)
                      | #processArrayExp(Expression, Value, List)
                      | #processArray(Expression, Expression, List, List)
                      | #processArrayIndex(Expression, Expression, OperandFlag, Expression, List, List)              [strict(4)]
                      | #assignArrayPartial(Id, ExpressionList, TypeName, Int, List, Int)
                      | #copyArrayArrayPartial(Id, Id, TypeName, TypeName, Int, List, Int, List, Int, Int)
                      | #addDynamicLength(Int, Expression, Int, TypeName, Int, List, Expression)        [strict(7)]
                      | #singleArrayIndex(Expression, List, Expression, ArrayOpFlag) [strict(3)]
                      | #computeArrayLength(List, Int, TypeName)
                      | #computeIndexAddr(Int, List, Expression, Expression, TypeName)  [strict(3,4)]
                      | #updateArrayLength(Id, List, TypeName, Int, PushOrPop)
                      | #resizeArray(Expression, Int, Int)
                      | #increaseArraySize(Expression, Int, Int)
                      | #reduceArraySize(Expression, Int, Int)
                      | #pointToStorage(Id, VarInfo)

syntax AbnormalTerminationCode ::= "#continue#" | "#break#" | "#return#" | "#transfer-failed#"

syntax Expression ::= #getAddress(Int, Expression, Expression, Int, List, Expression)							[strict(3)]
                    | #recordIndexLength(Int, Expression, Int, TypeName, Int, List)
                    | #getIndexAddress(Int, Expression, Int, TypeName, Int)
                    | #getRelativeAddr(Int, Expression, Int) 												[strict(2)]
                    | #tupleExp(ExpressionList) 																			[strict]
                    | MemOperation
                    | #getDynamicSize()
                    | #singleArrayExp(Expression, List, ArrayOpFlag)
                    | #getInitValue(Expression)                                     [strict]


endmodule
