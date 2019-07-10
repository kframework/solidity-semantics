
contract Test {
    uint[3][4][2] target;
    uint[3][4] array;

    constructor() public{
        target = [ [ [0,1,2], [1,2,3], [2,3,4], [3,4,5] ], [ [9,8,7], [8,7,6], [7,6,5], [6,5,4] ] ];
    }

    function assignmentTest(uint index, uint idx1, uint idx2) public {
        array[index] = target[idx1][idx2];
    }

    function arrayRead(uint i, uint j) public returns (uint) {
        return array[i][j];
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.assignmentTest(0,0,0);
                    t.assignmentTest(1,0,1);
                    t.assignmentTest(2,0,2);
                    t.assignmentTest(3,0,3);

                    int value00 = t.arrayRead(0,0);     // read value of array[0][0]
                    int value01 = t.arrayRead(0,1);     // read value of array[0][1]
                    int value02 = t.arrayRead(0,2);     // read value of array[0][2]

                    int value10 = t.arrayRead(1,0);     // read value of array[1][0]
                    int value11 = t.arrayRead(1,1);     // read value of array[1][1]
                    int value12 = t.arrayRead(1,2);     // read value of array[1][2]

                    int value20 = t.arrayRead(2,0);     // read value of array[2][0]
                    int value21 = t.arrayRead(2,1);     // read value of array[2][1]
                    int value22 = t.arrayRead(2,2);     // read value of array[2][2]

                    int value30 = t.arrayRead(3,0);     // read value of array[3][0]
                    int value31 = t.arrayRead(3,1);     // read value of array[3][1]
                    int value32 = t.arrayRead(3,2);     // read value of array[3][2]
                )
    },
    "post" : {
        "mem" :  #exists("value00", 0),
        "mem" :  #exists("value01", 1),
        "mem" :  #exists("value02", 2),

        "mem" :  #exists("value10", 1),
        "mem" :  #exists("value11", 2),
        "mem" :  #exists("value12", 3),

        "mem" :  #exists("value20", 2),
        "mem" :  #exists("value21", 3),
        "mem" :  #exists("value22", 4),

        "mem" :  #exists("value30", 3),
        "mem" :  #exists("value31", 4),
        "mem" :  #exists("value32", 5)
    }
},


"Test2" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.assignmentTest(0,1,0);
                    t.assignmentTest(1,1,1);
                    t.assignmentTest(2,1,2);
                    t.assignmentTest(3,1,3);

                    int value00 = t.arrayRead(0,0);     // read value of array[0][0]
                    int value01 = t.arrayRead(0,1);     // read value of array[0][1]
                    int value02 = t.arrayRead(0,2);     // read value of array[0][2]

                    int value10 = t.arrayRead(1,0);     // read value of array[1][0]
                    int value11 = t.arrayRead(1,1);     // read value of array[1][1]
                    int value12 = t.arrayRead(1,2);     // read value of array[1][2]

                    int value20 = t.arrayRead(2,0);     // read value of array[2][0]
                    int value21 = t.arrayRead(2,1);     // read value of array[2][1]
                    int value22 = t.arrayRead(2,2);     // read value of array[2][2]

                    int value30 = t.arrayRead(3,0);     // read value of array[3][0]
                    int value31 = t.arrayRead(3,1);     // read value of array[3][1]
                    int value32 = t.arrayRead(3,2);     // read value of array[3][2]
                )
    },
    "post" : {
        "mem" :  #exists("value00", 9),
        "mem" :  #exists("value01", 8),
        "mem" :  #exists("value02", 7),

        "mem" :  #exists("value10", 8),
        "mem" :  #exists("value11", 7),
        "mem" :  #exists("value12", 6),

        "mem" :  #exists("value20", 7),
        "mem" :  #exists("value21", 6),
        "mem" :  #exists("value22", 5),

        "mem" :  #exists("value30", 6),
        "mem" :  #exists("value31", 5),
        "mem" :  #exists("value32", 4)
    }
}


}
