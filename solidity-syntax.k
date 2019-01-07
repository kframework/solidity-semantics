

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

syntax TypeName ::= ElementaryTypeName

syntax ElementaryTypeName ::= "address" | "string" | "var" | "bool" | SolidityInt

syntax SolidityInt ::= "int"

syntax StateVariableDeclaration ::= TypeName FunQuantifiers Id ";"  [klabel(#stateVarDecl)]
                                  | TypeName FunQuantifiers Id "=" Expression ";"  [klabel(#stateVarDeclWithAssignment)]

syntax FunQuantifier ::= ModifierInvocation
                       | Specifier

syntax ModifierInvocation ::= Id
                            

syntax Specifier ::= "public"
                   | "internal"
                   | "private"
                   | "constant"
                   | "pure"
                   | "view"
                   | "payable"
                   | "external"

syntax FunQuantifiers ::= List{FunQuantifier," "}



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

syntax Statement ::= Block
                   | SimpleStatement ";" [strict,klabel(#simpleStmt)]

syntax SimpleStatement ::= Assignment | Value | VariableDefinition

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

syntax Expression ::= Id | Value
                    > left:
                  Expression "+" Expression            [klabel(#addexp),strict,left]

syntax Identifiers ::= List{Id, ","}        [klabel(#identifiers)]

syntax MemberAccess ::= Expression "." Id        [klabel(#memberAccess)]

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

syntax SolidityItem
       ::= #exeStmt(Statement)

endmodule
