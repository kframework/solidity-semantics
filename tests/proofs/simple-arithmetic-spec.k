requires "solidity.k"

module SIMPLE-ARITHMETIC-SPEC
    imports SOLIDITY

    rule <k> X:Id * Y:Id => XI *Int YI ... </k>
         <env>
           ...
           X |-> #storedVar(XL:Int, _:TypeName, #mem)
           Y |-> #storedVar(YL:Int, _:TypeName, #mem)
           ...
         </env>
         <localMem>
           ...
           XL |-> XI:Int
           YL |-> YI:Int
           ...
         </localMem>
      requires Id2String(X) =/=K "this"
       andBool Id2String(Y) =/=K "this"

    rule <k> X:Id + Y:Id => XI +Int YI ... </k>
         <env>
           ...
           X |-> #storedVar(XL:Int, _:TypeName, #mem)
           Y |-> #storedVar(YL:Int, _:TypeName, #mem)
           ...
         </env>
         <localMem>
           ...
           XL |-> XI:Int
           YL |-> YI:Int
           ...
         </localMem>
      requires Id2String(X) =/=K "this"
       andBool Id2String(Y) =/=K "this"

    rule <k> X:Id / Y:Id => XI /Int YI ... </k>
         <env>
           ...
           X |-> #storedVar(XL:Int, _:TypeName, #mem)
           Y |-> #storedVar(YL:Int, _:TypeName, #mem)
           ...
         </env>
         <localMem>
           ...
           XL |-> XI:Int
           YL |-> YI:Int
           ...
         </localMem>
      requires Id2String(X) =/=K "this"
       andBool Id2String(Y) =/=K "this"

endmodule
