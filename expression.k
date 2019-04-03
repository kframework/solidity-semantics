

requires "solidity-syntax.k"
requires "configuration.k"


module EXPRESSION

imports SOLIDITY-SYNTAX
imports CONFIGURATION

rule [Allocate-State-Variables]:
    <k> #allocate(N, CN, #varInfo(X:Id,E:Value,T:TypeName, #storage)) => . ...</k>
    <account>
        <acctID> N </acctID>
        <contractName> CN </contractName>
        <acctEnv> CONTEXT:Map => CONTEXT[X <- #storedVar(!N:Int, T, #storage)] </acctEnv>
        <acctStorage> STORAGE:Map => STORAGE[!N <- E] </acctStorage>
        ...
    </account>

rule [Allocate-Local-Variables]:
    <k> #allocate(C, CN, #varInfo(X:Id, E:Value, T:TypeName, #mem)) => . ...</k>
    <env> ENV:Map => ENV[X <- #storedVar(!N:Int, T, #mem)] </env>
    <currentAccount> #account(C, CN) </currentAccount>
    <localMem> MEM:Map => MEM[!N <- E] </localMem>

rule [Read-Local-Variables]:
    <k> X:Id => I ...</k>
    <env> ... X |-> #storedVar(N:Int, _:TypeName, #mem) ...</env>
    <localMem> ... N |-> I:Value ...</localMem>

rule [Read-State-Variables]:
    <k> X:Id => I ...</k>
    <env> ... X |-> #storedVar(N:Int, _:TypeName, #storage) ...</env>
    <currentAccount> #account(C, CN) </currentAccount>
    <account>
        <acctID> C </acctID>
        <contractName> CN </contractName>
        <acctStorage> ... N |-> I:Value ...</acctStorage>
        ...
    </account>

rule [Write-Local-Variables]:
    <k> X:Id = I:Value => #end_Exp ...</k>
    <env> ... X |-> #storedVar(N:Int, _:TypeName, #mem) ...</env>
    <localMem> ... ((N |-> _:Value) => (N |-> I)) ...</localMem>

rule [Write-State-Variables]:
    <k> X:Id = I:Value => #end_Exp ...</k>
    <env> ... X |-> #storedVar(N:Int, _:TypeName, #storage) ...</env>
    <currentAccount> #account(C, CN) </currentAccount>
    <account>
        <acctID> C </acctID>
        <contractName> CN </contractName>
        <acctStorage> ... ((N |-> _:Value) => (N |-> I)) ...</acctStorage>
        ...
    </account>

rule <k> I1:Int +  I2:Int => I1  +Int I2 ... </k>
rule <k> I1:Int *  I2:Int => I1  *Int I2 ... </k>
rule <k> I1:Int /  I2:Int => I1  /Int I2 ... </k>
rule <k> I1:Int -  I2:Int => I1  -Int I2 ... </k>
rule <k> I1:Int <  I2:Int => I1  <Int I2 ... </k>
rule <k> I1:Int <= I2:Int => I1 <=Int I2 ... </k>
rule <k> I1:Int >  I2:Int => I1  >Int I2 ... </k>
rule <k> I1:Int >= I2:Int => I1 >=Int I2 ... </k>


endmodule


