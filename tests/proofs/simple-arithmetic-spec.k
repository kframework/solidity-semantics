requires "solidity.k"

module SIMPLE-ARITHMETIC-SPEC
    imports SOLIDITY

    rule <k> #multexp(X:Id, Y:Id) => 12 ... </k>
         <env>
           X |-> #storedVar(0, _, _)
           Y |-> #storedVar(1, _, _)
         </env>
         <localMem>
           0 |-> 4
           1 |-> 3
         </localMem>
endmodule
