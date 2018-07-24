
requires "solidity-syntax.k"
requires "configuration.k"
requires "contract.k"
requires "function.k"
requires "statement.k"

module SOLIDITY
  imports SOLIDITY-SYNTAX
  imports CONFIGURATION
  imports CONTRACT
  imports FUNCTION
  imports STATEMENT

rule  Ps:PragmaDirectives Cs:ContractDefinitions => Cs

rule C:ContractDefinition Cs:ContractDefinitions => C ~> Cs

rule .ContractDefinitions => .



    
endmodule
