

requires "solidity-syntax.k"
requires "configuration.k"


module EXPRESSION

imports SOLIDITY-SYNTAX
imports CONFIGURATION

rule [Allocate-State-Variables]:
    <k> #allocate(N:Int, CN:Id, #varInfo(X:Id,E:Value,T:TypeName, #storage)) => . ...</k>
    <account>
        <acctID> #account(N, CN) </acctID>
        <context> CONTEXT:Map => CONTEXT[X <- #storedVar(!N:Int, T, #storage)] </context>
        <Storage> STORAGE:Map => STORAGE[!N <- E] </Storage>
        ...
    </account>

rule [Allocate-Local-Variables]:
    <k> #allocate(C:Int, CN:Id, #varInfo(X:Id, E:Value, T:TypeName, #mem)) => . ...</k>
    <env> ENV:Map => ENV[X <- #storedVar(!N:Int, T, #mem)] </env>
    <currentAccount> #account(C, CN) </currentAccount>
    <localMem> MEM:Map => MEM[!N <- E] </localMem>

rule
    <k> X:Id => #read(X) ...</k>

rule
    <k> X:Id = I:Value => #write(X,I) ...</k>

rule [Read-Local-Variables]:
    <k> #read(X:Id) => I ...</k>
    <env> ... X |-> #storedVar(N:Int, _:TypeName, #mem) ...</env>
    <localMem> ... N |-> I:Value ...</localMem>

rule [Read-State-Variables]:
    <k> #read(X:Id) => I ...</k>
    <env> ... X |-> #storedVar(N:Int, _:TypeName, #storage) ...</env>
    <currentAccount> #account(C, CN) </currentAccount>
    <account>
        <acctID> #account(C, CN) </acctID>
        <Storage> ... N |-> I:Value ...</Storage>
        ...
    </account>

rule [Write-Local-Variables]:
    <k> #write(X:Id,I:Value) => #end_Exp ...</k>
    <env> ... X |-> #storedVar(N:Int, _:TypeName, #mem) ...</env>
    <localMem> ... ((N |-> _:Value) => (N |-> I)) ...</localMem>

rule [Write-State-Variables]:
    <k> #write(X:Id,I:Value) => #end_Exp ...</k>
    <env> ... X |-> #storedVar(N:Int, _:TypeName, #storage) ...</env>
    <currentAccount> #account(C, CN) </currentAccount>
    <account>
        <acctID> #account(C, CN) </acctID>
        <Storage> ... ((N |-> _:Value) => (N |-> I)) ...</Storage>
        ...
    </account>

rule I1:Int + I2:Int => I1 +Int I2
rule I1:Int * I2:Int => I1 *Int I2
rule I1:Int / I2:Int => I1 /Int I2
rule I1:Int - I2:Int => I1 -Int I2
rule I1:Int < I2:Int => I1 <Int I2
rule I1:Int <= I2:Int => I1 <=Int I2
rule I1:Int > I2:Int => I1 >Int I2
rule I1:Int >= I2:Int => I1 >=Int I2


endmodule


