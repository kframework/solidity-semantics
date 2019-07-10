
contract Test {
    uint[3] array;
    uint[3] target;

    constructor() public{
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
    }

    function assignmentTest() public {
        target = array;
    }

    function targetRead(uint index) public returns (uint) {
        if(index < 3){
            return target[index];
        }
        else{
            return target[0];
        }
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.assignmentTest();
                    uint value1 = t.targetRead(0);
                    uint value2 = t.targetRead(1);
                    uint value3 = t.targetRead(2);
                )
    },
    "post" : {
        "mem" :  #exists("value1", 1),
        "mem" :  #exists("value2", 2),
        "mem" :  #exists("value3", 3)
    }
}


}
