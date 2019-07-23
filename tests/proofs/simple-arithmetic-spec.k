requires "solidity.k"

module SIMPLE-ARITHMETIC-SPEC
    imports SOLIDITY

    rule <k> X:Id * Y:Id => XI *Int YI ... </k>
         <env>
           ...
           X |-> #storedVar(XL:Int, _:ElementaryTypeName, #mem, 1, 1, #fixed-size)
           Y |-> #storedVar(YL:Int, _:ElementaryTypeName, #mem, 1, 1, #fixed-size)
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
           X |-> #storedVar(XL:Int, _:ElementaryTypeName, #mem, 1, 1, #fixed-size)
           Y |-> #storedVar(YL:Int, _:ElementaryTypeName, #mem, 1, 1, #fixed-size)
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
           X |-> #storedVar(XL:Int, _:ElementaryTypeName, #mem, 1, 1, #fixed-size)
           Y |-> #storedVar(YL:Int, _:ElementaryTypeName, #mem, 1, 1, #fixed-size)
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
