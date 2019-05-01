

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


syntax TypeName ::= ElementaryTypeName
                  | UserDefinedTypeName

syntax UserDefinedTypeName ::= Id

syntax ElementaryTypeName ::= AddressType | AddressPayableType | "string" | "var" | "bool" | SolidityInt | SolidityUint

syntax AddressPayableType ::= "address payable" [klabel(#address-payable)]

syntax AddressType ::= "address" [klabel(#address)]


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
syntax StorageLocation ::= "memory" | "storage"

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
       ::= Bool | Int | String

syntax Values
       ::= List{Value, ","}

syntax ExpressionList ::= Values

syntax Return ::= "return" Expression [strict]
                | "return"

syntax Break ::= "break" ";"

syntax Continue ::= "continue" ";"

syntax NewExpression ::= "new" Id "(" ExpressionList ")"

syntax Expression ::= Id | Value
                | NewExpression
                | FunctionCall
                | MemberAccess
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

syntax IfStatement ::= "if" "(" Expression ")" Statement "else" Statement [strict(1)]
                     | "if" "(" Expression ")" Statement [strict(1)]

syntax WhileStatement ::= "while" "(" Expression ")" Statement

syntax Identifiers ::= List{Id, ","}        [klabel(#identifiers)]

syntax MemberAccess ::= Expression "." Id        [klabel(#memberAccess), strict(1)]

syntax AccountId
       ::=  Id | "#Testing-Engine#"

syntax ContractInstanceSig
       ::= #account(Int,AccountId)

syntax Value
       ::= "#undef_Value"
         | "#end_Exp"

syntax VarInfo
       ::= #varInfo(Id, Expression, TypeName, MemFlag) [strict(2)]
         | #storedVar(Int, TypeName, MemFlag)

syntax MemOperation
        ::= #read(Id)
          | #write(Id, Expression) [strict(2)]
          | #allocate(Int, AccountId, VarInfo)

syntax MemFlag
       ::= "#mem"
         | "#storage"

syntax Exec
       ::= "#execute"

syntax SolidityItem ::= #exeStmt(Statement) | AbnormalTerminationCode

syntax AbnormalTerminationCode ::= "#continue#" | "#break#" | "#return#" | "#transfer-failed#"

endmodule
