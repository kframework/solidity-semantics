
contract Test {
    uint[3][2] array;
    uint[3] target;

    constructor() public{
        target = [1, 2, 3];
    }

    function assignmentTest(uint index) public {
        array[index] = target;
    }

    function targetRead(uint idx1, uint idx2) public returns (uint) {
        return array[idx1][idx2];
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();

                    t.assignmentTest(0);
                    t.assignmentTest(1);

                    uint value00 = t.targetRead(0,0);
                    uint value01 = t.targetRead(0,1);
                    uint value02 = t.targetRead(0,2);

                    uint value10 = t.targetRead(1,0);
                    uint value11 = t.targetRead(1,1);
                    uint value12 = t.targetRead(1,2);
                )
    },
    "post" : {
        "mem" :  #exists("value00", 1),
        "mem" :  #exists("value01", 2),
        "mem" :  #exists("value02", 3),
        "mem" :  #exists("value10", 1),
        "mem" :  #exists("value11", 2),
        "mem" :  #exists("value12", 3)
    }
}


}
