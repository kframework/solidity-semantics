
contract Test {
    uint[3][2] array;
    uint[3][2] target;

    constructor() public{
        array[0] = [1, 2, 3];
        array[1] = [4, 5, 6];
    }

    function assignmentTest() public {
        target[0] = array[0];
        target[1] = array[1];
    }

    function targetRead(uint index1, uint index2) public returns (uint) {
        if(index1 < 2 && index2 < 3){
            return target[index1][index2];
        }
        else{
            return 0;
        }
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.assignmentTest();
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
        "mem" :  #exists("value10", 4),
        "mem" :  #exists("value11", 5),
        "mem" :  #exists("value12", 6)
    }
}


}
