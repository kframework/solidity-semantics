

requires "solidity-syntax.k"
requires "configuration.k"


module EXPRESSION

imports SOLIDITY-SYNTAX
imports CONFIGURATION

/* ===============================================================================
This rule allocates a non-array type variable named "X" in storage
    CN  : contract name
    C   : the logical address of the "CN" contract instance
    L   : the number of storage slots required for variable "X"

    ??  : L is not used in RHS of this rule
-------------------------------------------------------------------------------- */
rule [Allocate-Global-NonArrayType]:
    <k> #allocate(N, CN, #varInfo(X:Id, E:Value, T:NonArrayType,  #storage, L)) => . ...</k>
    <account>
        <acctID> N </acctID>
        <contractName> CN </contractName>
        <acctEnv> CONTEXT:Map => CONTEXT[X <- #storedVar(Slot +Int 1, T, #storage, 1)] </acctEnv>
        <acctStorage> STORAGE:Map => STORAGE[Slot +Int 1 <- E] </acctStorage>
        <acctSlots> Slot => Slot +Int 1 </acctSlots>
        ...
    </account>
//================================================================================


/* ===============================================================================
This rule allocates a non-array type variable named "X" in memory
    CN  : contract name
    C   : the logical address of the "CN" contract instance
    L   : the number of memory slots required for variable "X"

    ??  : L is not used in RHS of this rule
--------------------------------------------------------------------------------- */
rule [Allocate-Local-NonArrayType]:
    <k> #allocate(C, CN, #varInfo(X:Id, E:Value, T:NonArrayType, #mem, L)) => . ...</k>
    <env> ENV:Map => ENV[X <- #storedVar(Slot +Int 1, T, #mem, 1)] </env>
    <currentAccount> #account(C, CN) </currentAccount>
    <localMem> MEM:Map => MEM[Slot +Int 1 <- E] </localMem>
    <memorySlots> Slot => Slot +Int 1 </memorySlots>
//=================================================================================


/* ================================================================================================
This rule triggers the allocation of an array
    CN  : contract name
    N   : the logical address of the "CN" contract instance
    X   : the name of the array
    Len : the dimension of the array
    M   : memory location (either #storage or #mem)
    L   : the number of slots required for each element in the array (in the top level, L will be 1)

---------------------------------------------------------------------------------------------------*/
rule [Allocate-Array]:
    <k> #allocate(N, CN, #varInfo(X:Id, E:Value, T:TypeName[Len:Int], M, L)) => #allocateArray(#allocate(N, CN, #varInfo(X, E, T, M, L *Int Len)), Len, 0)  ...</k>
//===================================================================================================


/* ==================================================================================
This rule recursively allocates each element in an array
    A   : the term for allocating one element of the array
    Len : the dimension of the array
    N   : recursive index (starting from 0 and approaching "Len")
-----------------------------------------------------------------------------------*/
rule
    <k> #allocateArray(A, Len, N) => A ~> #allocateArray(A, Len, N +Int 1) ...</k>
    requires N <Int Len
//===================================================================================


/* =======================================================================================================
This rule terminates the recursive allocation (in memory) of an array, whose element is non-array type.
In addition, it corrects the information of the array.
--------------------------------------------------------------------------------------------------------*/
rule
    <k> #allocateArray(#allocate(N, CN, #varInfo(X, E, T:ElementaryTypeName, #mem, L)), Len, Len) => . ...</k>
    <env> ... X |-> #storedVar(A => A -Int L +Int 1, T => T[Len], #mem, _ => L) ...</env>
//========================================================================================================


/* ========================================================================================================
This rule terminates the recursive allocation (in storage) of an array, whose element is non-array type.
In addition, it corrects the information of the array.
---------------------------------------------------------------------------------------------------------*/
rule
    <k> #allocateArray(#allocate(N, CN, #varInfo(X, E, T:ElementaryTypeName, #storage, L)), Len, Len) => . ...</k>
    <account>
        <acctID> N </acctID>
        <contractName> CN </contractName>
        <acctEnv> ... X |-> #storedVar(A => A -Int L +Int 1, T => T[Len], #storage, _ => L) ... </acctEnv>
        ...
    </account>
//=========================================================================================================


/* ========================================================================================================
This rule terminates the recursive allocation (in memory) of an array, whose element is array type.
In addition, it corrects the information of the array.
---------------------------------------------------------------------------------------------------------*/
rule
    <k> #allocateArray(#allocate(N, CN, #varInfo(X, E, T:ArrayTypeName, #mem, L)), Len, Len) => . ...</k>
    <env> ... X |-> #storedVar(_, T => T[Len], #mem, _) ...</env>
//=========================================================================================================
/* ==================================================================================================
This rule terminates the recursive allocation (in storage) of an array, whose element is array type.
In addition, it corrects the information of the array.
---------------------------------------------------------------------------------------------------*/
rule
    <k> #allocateArray(#allocate(N, CN, #varInfo(X, E, T:ArrayTypeName, #storage, L)), Len, Len) => . ...</k>
    <account>
        <acctID> N </acctID>
        <contractName> CN </contractName>
        <acctEnv> ... X |-> #storedVar(_, T => T[Len], #storage, _) ... </acctEnv>
        ...
    </account>
//===================================================================================================

rule
    <k> [E:ExpressionList] => #tupleExp(E) ...</k>

rule
    <k> #read(X:Id) => #arrayExp(X) ...</k>
    <env> ... X |-> #storedVar(_, _:ArrayTypeName, _, _) ...</env>

rule
    <k> X:Id => #read(X) ...</k>
    requires notBool (Id2String(X) ==String "this")

rule [Keyword-This]:
    <k> THIS:Id => C ... </k>
    <currentAccount> #account(C, CN) </currentAccount>
    requires Id2String(THIS) ==String "this"

rule [Assign-NonArrayType]:
    <k> X:Id = I:Value => #write(X,I) ...</k>
    <env> ... X |-> #storedVar(_, _:NonArrayType, _, _) ...</env>
/* =========================================================================================
This rule recursively assigns constant values (tuples) to each dimention of array "X"
    Addr: the starting (logical) address to write values in
    L   : the number of elements to be assigned
    I   : the number of elements of the top dimention

    If L is not equal to 1, it means that "X" consists of more than one dimention
-------------------------------------------------------------------------------------------*/
rule
    <k> #assignArray(X, #tupleExp(E:ExpressionList),EL:ExpressionList, Addr, L, T[I]) => #assignArray(X, E, Addr, L /Int I, T) ~> #assignArray(X, EL, Addr +Int L, L, T[I]) ...</k>
    requires L >Int 1
//===========================================================================================


/* ================================================================================================
This rule assigns constant tuples (values) to 1D (sub) array "X"
    Addr: the starting (logical) address to write values in
    L   : the number of elements to be assigned
    I   : the number of elements of the top dimention
--------------------------------------------------------------------------------------------------*/
rule
    <k> #assignArray(X, V:Value,E:Values, Addr, 1, T) => #writeAddress(Addr, V, M); ~> #assignArray(X, E, Addr +Int 1, 1, T)...</k>
    <env> ... X |-> #storedVar(_, _, M, _) ...</env>
/* ========================================================================
This rule terminates the assignment of constant values to an array.
-------------------------------------------------------------------------*/
rule
    <k> #assignArray(X, .ExpressionList, Addr, L, T) => . ...</k>
//=========================================================================================


/* ==============================================================================================
This rule recursively copies each element of array "Y" to array "X"
    AddrX   : starting (logical) address of array "X"
    MX      : memory location of array "X"
    AddrY   : starting (logical) address of array "Y"
    MY      : memory location of array "Y"
    L       : the number of elements to be copied
    N       : recursive index for the copy (starting from 0 and approaching "L")
------------------------------------------------------------------------------------------------*/
rule
    <k> #copyArray(AddrX, MX, AddrY, MY, L, N) => #writeAddress(AddrX, #readAddress(AddrY, MY), MX); ~>  #copyArray(AddrX +Int 1, MX, AddrY +Int 1, MY, L, N +Int 1) ...</k>
    requires L >Int N
//===============================================================================================


/* ==============================================================
This rule terminates the copy of arrays.
----------------------------------------------------------------*/
rule
    <k> #copyArray(AddrX, MX, AddrY, MY, L, L) => . ...</k>

rule
    <k> X:Expression[Index] => #read(X[Index]) ...</k>

rule
    <k> X:Expression[Index] = I:ValueResult => #write(X[Index],I) ...</k>

rule [Assign-Array-ArrayType-Partial]:
    <k> X:Expression = #arrayExp(Y:Expression) => #processArray(X, Y, .List, .List) ...</k>

rule
    <k> #processArray(X:Expression[Index1], Y, IdxList1, IdxList2) => #processArrayIndex(X, Y, #left, Index1, IdxList1, IdxList2) ...</k>

rule
    <k> #processArrayIndex(X, Y, #left, Index1:Int, IdxList1, IdxList2) => #processArray(X, Y, ListItem(Index1)IdxList1, IdxList2) ...</k>

rule
    <k> #processArray(X:Id, Y[Index2], IdxList1, IdxList2) => #processArrayIndex(X:Id, Y, #right, Index2, IdxList1, IdxList2) ...</k>

rule
    <k> #processArrayIndex(X:Id, Y, #right, Index2:Int, IdxList1, IdxList2) => #processArray(X, Y, IdxList1, ListItem(Index2)IdxList2) ...</k>

rule
    <k> #processArray(X:Id, Y:Id, IdxList1, IdxList2) => #copyArrayArrayPartial(X, Y, T1, T2, 0, IdxList1, 0, IdxList2, L1, L2) ...</k>
    <env> ... (X |-> #storedVar(_, T1, _, L1)) (Y |-> #storedVar(_, T2, _, L2))...</env>

rule
    <k> #copyArrayArrayPartial(X, Y, T1[I1:Int], T2, D1, ListItem(Index1)IdxList1, D2, IdxList2, L1, L2) => #copyArrayArrayPartial(X, Y, T1, T2, D1 +Int (Index1 *Int (L1 /Int I1)), IdxList1, D2, IdxList2, L1 /Int I1, L2) ...</k>

rule
    <k> #copyArrayArrayPartial(X, Y, T1, T2[I2:Int], D1, .List, D2, ListItem(Index2)IdxList2, L1, L2) => #copyArrayArrayPartial(X, Y, T1, T2, D1, .List, D2 +Int (Index2 *Int (L2 /Int I2)), IdxList2, L1, L2 /Int I2) ...</k>

rule
    <k> #copyArrayArrayPartial(X, Y, T1, T2, D1, .List, D2, .List, L1, L2) => #copyArray(AddrX +Int D1, MX, AddrY +Int D2, MY, L1, 0) ~> #end_Exp ...</k>
    <env> ... (X |-> #storedVar(AddrX:Int, _:ArrayTypeName, MX, _)) (Y |-> #storedVar(AddrY:Int, _:ArrayTypeName, MY, _)) ...</env>
    requires L1 ==Int L2

/* ===============================================================================================================
This rule triggers #processArrayExp to handle the case of constant assignment to sub-array, e.g., A[1] = [2,3,4]
*/
rule [Assign-Const-ArrayType-Partial]:
    <k> X:Expression = #tupleExp(E) => #processArrayExp(X, #tupleExp(E), .List) ...</k>
/* ==================================================================================================================
These two rules help to obtain the (array-access) indexes in reversed order, e.g., A[1][2][3] to 3 2 1
And, then trigger the #assignArrayPartial rules for constant assignment to sub-array
*/
rule
    <k> #processArrayExp(X:Expression[Index], #tupleExp(E), IdxList) => #processArrayExp(X, #tupleExp(E), ListItem(Index)IdxList) ...</k>

rule
    <k> #processArrayExp(X:Id, #tupleExp(E), IdxList) => #assignArrayPartial(X, E, T, 0, IdxList, L) ...</k>
    <env> ... X |-> #storedVar(_, T, _, L) ...</env>
//===================================================================================================================
/* ==================================================================================================================
These two rules recursively calculate the offset (from the starting address of the array) to be assigned in
    X       : the name of the array
    E       : the tuple expression to be assigned
    D       : offset from the starting address of the array
    IdxList : the list of (array-access) indexes in reversed order
    L       : the number of elements to be assigned

Once the offset is determined, the #assignArray rule is invoked
*/
rule
    <k> #assignArrayPartial(X, E, T[I:Int], D, ListItem(Index)IdxList, L) => #assignArrayPartial(X, E, T, D +Int (Index *Int (L /Int I)), IdxList, L /Int I) ...</k>

rule
    <k> #assignArrayPartial(X, E, T[I:Int], D, .List, L) => #assignArray(X, E, Addr +Int D, L /Int I, T) ~> #end_Exp ...</k>
    <env> ... X |-> #storedVar(Addr:Int, _, _, _) ...</env>
//=====================================================================================================================


rule [Read-NonArrayType]:
    <k> #read(X:Id) => #readAddress(N, M) ...</k>
    <env> ... X |-> #storedVar(N:Int, _:NonArrayType, M, 1) ...</env>

rule [Read-ArrayType-Index]:
    <k> #read(X:Expression[Index]) => #readArray(X, X[Index]) ...</k>

rule
    <k> #readArray(X:Expression[Index], Y) => #readArray(X, Y) ...</k>

rule
    <k> #readArray(X:Id, Y:IndexAccess) => #readAddress(#getIndexAddress(N, Y, 0, T, Len), M) ...</k>
    <env> ... X |-> #storedVar(N:Int, T:ArrayTypeName, M, Len) ...</env>

/* ==============================================================================================
This rule helps to get the actual logical address for <IndexAccess> of an array
    N   : starting (logical) address of the array
    X   : the whole <IndexAccess> expression
    D   : offset (initially it is 0)
    T   : the type of the array
    Len : the total number of memory slots occupied by the array

This rule triggers #recordIndexLength rule to recursively obtain the actual logical address

    ??: it seems that "D" will always be 0 and not used
-----------------------------------------------------------------------------------------------*/

rule
    <k> #getIndexAddress(N, X, D, T, Len) => #recordIndexLength(N, X, D, T, Len, .List) ...</k>
//===============================================================================================


/* ============================================================================================================
These two rules help to obtain the length of each dimension in reversed order, e.g., uint [1][2][3] to 3 2 1
    N   : starting (logical) address of the array
    X   : the whole <IndexAccess> expression
    D   : offset (initially it is 0)
    Len : the total number of memory slots occupied by the array
    L   : a list to record the length of each dimension in reversed order

Once the list is obtained, the #getAddress rule is invoked to get the actual logical address of <IndexAccess>
-------------------------------------------------------------------------------------------------------------*/

rule
    <k> #recordIndexLength(N, X, D, T[IdxLen], Len, L:List) => #recordIndexLength(N, X, D, T, Len, ListItem(IdxLen)L) ...</k>

rule
    <k> #recordIndexLength(N, X, D, T:ElementaryTypeName, Len, L:List) => #getAddress(N, X, D, 1, L, X) ...</k>

//============================================================================================================


/* ====================================================================================================
These three rules calculate the actual logical address of <IndexAccess>
    N   : starting (logical) address of the array
    X   : the name of the array
    D   : offset (initially it is 0) from the beginning of the array
    Len : jumping length (initially it is 1)
    L   : a list to record the length of each dimension in reversed order
    Y   : the original <IndexAccess> expression
--------------------------------------------------------------------*/

rule
    <k> #getAddress(N, X:Id, D, Len, .List, Y) => N +Int D ...</k>

/* This is for the case where Y (the original <IndexAccess> expression) is an array instead of a value */
rule
    <k> #getAddress(N, X:Id, D, Len, L, Y) => #arrayExp(Y) ...</k>
    requires L =/=K .List
//=====================================================================================================


/* ================================================================================
This rule helps to calcuate the relative adddress
    D       : offset
    Index   : the index to access the array
    Len     : the length of the current dimension
*/
rule
    <k> #getRelativeAddr(D, Index:Int, Len) => D +Int Index *Int Len ...</k>
//==================================================================================

rule
    <k> #readAddress(#arrayExp(Y), M) => #arrayExp(Y) ...</k>

rule
    <k> #getAddress(N, X:Expression[Index:Expression], D, Len, ListItem(IndexLen)L:List, Y) => #getAddress(N, X, #getRelativeAddr(D, Index, Len), Len *Int IndexLen, L, Y) ...</k>

rule
    <k> #getRelativeAddr(D, Index:Int, Len) => D +Int Index *Int Len ...</k>

rule [Read-Local-Variables]:
    <k> #readAddress(N, #mem) => I ...</k>
    <localMem> ... N |-> I:Value ...</localMem>

rule [Read-State-Variables]:
    <k> #readAddress(N, #storage) => I ...</k>
    <currentAccount> #account(C, CN) </currentAccount>
    <account>
        <acctID> C </acctID>
        <contractName> CN </contractName>
        <acctStorage> ... N |-> I:Value ...</acctStorage>
        ...
    </account>

rule [Write-NonArrayType]:
    <k> #write(X:Id,I:Value) => #writeAddress(N, I, M) ...</k>
    <env> ... X |-> #storedVar(N:Int, _:NonArrayType, M, 1) ...</env>

rule [Write-ArrayType-Index]:
    <k> #write(X:Expression[Index],I:ValueResult) => #writeArray(X, X[Index], I) ...</k>

rule
    <k> #writeArray(X:Expression[Index], Y, I:ValueResult) => #writeArray(X, Y, I) ...</k>

rule
    <k> #writeArray(X:Id, Y:IndexAccess,I:ValueResult) => #writeAddress(#getIndexAddress(N, Y, 0, T, Len), I, M) ...</k>
    <env> ... X |-> #storedVar(N:Int, T:ArrayTypeName, M, Len) ...</env>

rule [Write-Local-Variables]:
    <k> #writeAddress(N, I:ValueResult, #mem) => #end_Exp ...</k>
    <localMem> ... ((N |-> _:Value) => (N |-> I)) ...</localMem>

rule [Write-State-Variables]:
    <k> #writeAddress(N, I:ValueResult, #storage) => #end_Exp ...</k>
    <currentAccount> #account(C, CN) </currentAccount>
    <account>
        <acctID> C </acctID>
        <contractName> CN </contractName>
        <acctStorage> ... ((N |-> _:Value) => (N |-> I)) ...</acctStorage>
        ...
    </account>

rule [Address-Balance]:
    <k> #memberAccess(Base:Int, N:Id) => B ... </k>
    <account>
        <acctID> Base </acctID>
        <balance> B </balance>
        ...
    </account>
    requires Id2String(N) ==String "balance"


rule <k> I1:Int +  I2:Int => I1  +Int I2 ... </k>
rule <k> I1:Int *  I2:Int => I1  *Int I2 ... </k>
rule <k> I1:Int /  I2:Int => I1  /Int I2 ... </k>
rule <k> I1:Int -  I2:Int => I1  -Int I2 ... </k>
rule <k> I1:Int <  I2:Int => I1  <Int I2 ... </k>
rule <k> I1:Int <= I2:Int => I1 <=Int I2 ... </k>
rule <k> I1:Int >  I2:Int => I1  >Int I2 ... </k>
rule <k> I1:Int >= I2:Int => I1 >=Int I2 ... </k>
rule <k> A:Bool && B:Bool => A andBool B ... </k>
rule <k> A:Bool || B:Bool => A orBool B ... </k>


endmodule


