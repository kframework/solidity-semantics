requires "solidity-syntax.k"
requires "configuration.k"
requires "mcontract.k"
requires "function.k"
requires "statement.k"

module SOLIDITY
  imports SOLIDITY-SYNTAX
  imports CONFIGURATION
  imports MCONTRACT
  imports FUNCTION
  imports STATEMENT

rule  Ps:PragmaDirectives Cs:ContractDefinitions => Cs

rule C:ContractDefinition Cs:ContractDefinitions => C ~> Cs

rule .ContractDefinitions => .
    
endmodule
