
contract Test {
    uint[3][2] array;
    uint[3] target;

    constructor() public{
        array[0] = [1, 2, 3];
        array[1] = [4, 5, 6];
    }

    function assignmentTest(uint index) public {
        if(index < 2) {
            target = array[index];
        }
        else {
            target = array[0];
        }
    }

    function targetRead(uint index) public returns (uint) {
        if(index < 3){
            return target[index];
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

                    t.assignmentTest(0);

                    uint value0 = t.targetRead(0);
                    uint value1 = t.targetRead(1);
                    uint value2 = t.targetRead(2);
                    uint value3 = t.targetRead(3);
                )
    },
    "post" : {
        "mem" :  #exists("value0", 1),
        "mem" :  #exists("value1", 2),
        "mem" :  #exists("value2", 3),
        "mem" :  #exists("value3", 0)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();

                    t.assignmentTest(1);

                    uint value0 = t.targetRead(0);
                    uint value1 = t.targetRead(1);
                    uint value2 = t.targetRead(2);
                    uint value3 = t.targetRead(3);
                )
    },
    "post" : {
        "mem" :  #exists("value0", 4),
        "mem" :  #exists("value1", 5),
        "mem" :  #exists("value2", 6),
        "mem" :  #exists("value3", 0)
    }
}


}
