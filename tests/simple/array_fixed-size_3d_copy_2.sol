
contract Test {
    uint[3][4][2] target;
    uint[3][4][2] array;

    constructor() public{
        target = [ [ [0,1,2], [1,2,3], [2,3,4], [3,4,5] ], [ [9,8,7], [8,7,6], [7,6,5], [6,5,4] ] ];
    }

    function assignmentTest() public {
        array[0] = target[0];
        array[1] = target[1];
    }

    function arrayRead(uint i, uint j, uint k) public returns (uint) {
        return array[i][j][k];
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.assignmentTest();

                    int value000 = t.arrayRead(0,0,0);     // read value of array[0][0][0]
                    int value001 = t.arrayRead(0,0,1);     // read value of array[0][0][1]
                    int value002 = t.arrayRead(0,0,2);     // read value of array[0][0][2]

                    int value010 = t.arrayRead(0,1,0);     // read value of array[0][1][0]
                    int value011 = t.arrayRead(0,1,1);     // read value of array[0][1][1]
                    int value012 = t.arrayRead(0,1,2);     // read value of array[0][1][2]

                    int value020 = t.arrayRead(0,2,0);     // read value of array[0][2][0]
                    int value021 = t.arrayRead(0,2,1);     // read value of array[0][2][1]
                    int value022 = t.arrayRead(0,2,2);     // read value of array[0][2][2]

                    int value030 = t.arrayRead(0,3,0);     // read value of array[0][3][0]
                    int value031 = t.arrayRead(0,3,1);     // read value of array[0][3][1]
                    int value032 = t.arrayRead(0,3,2);     // read value of array[0][3][2]

                    int value100 = t.arrayRead(1,0,0);     // read value of array[1][0][0]
                    int value101 = t.arrayRead(1,0,1);     // read value of array[1][0][1]
                    int value102 = t.arrayRead(1,0,2);     // read value of array[1][0][2]

                    int value110 = t.arrayRead(1,1,0);     // read value of array[1][1][0]
                    int value111 = t.arrayRead(1,1,1);     // read value of array[1][1][1]
                    int value112 = t.arrayRead(1,1,2);     // read value of array[1][1][2]

                    int value120 = t.arrayRead(1,2,0);     // read value of array[1][2][0]
                    int value121 = t.arrayRead(1,2,1);     // read value of array[1][2][1]
                    int value122 = t.arrayRead(1,2,2);     // read value of array[1][2][2]

                    int value130 = t.arrayRead(1,3,0);     // read value of array[1][3][0]
                    int value131 = t.arrayRead(1,3,1);     // read value of array[1][3][1]
                    int value132 = t.arrayRead(1,3,2);     // read value of array[1][3][2]
                )
    },
    "post" : {
        "mem" :  #exists("value000", 0),
        "mem" :  #exists("value001", 1),
        "mem" :  #exists("value002", 2),

        "mem" :  #exists("value010", 1),
        "mem" :  #exists("value011", 2),
        "mem" :  #exists("value012", 3),

        "mem" :  #exists("value020", 2),
        "mem" :  #exists("value021", 3),
        "mem" :  #exists("value022", 4),

        "mem" :  #exists("value030", 3),
        "mem" :  #exists("value031", 4),
        "mem" :  #exists("value032", 5),

        "mem" :  #exists("value100", 9),
        "mem" :  #exists("value101", 8),
        "mem" :  #exists("value102", 7),

        "mem" :  #exists("value110", 8),
        "mem" :  #exists("value111", 7),
        "mem" :  #exists("value112", 6),

        "mem" :  #exists("value120", 7),
        "mem" :  #exists("value121", 6),
        "mem" :  #exists("value122", 5),

        "mem" :  #exists("value130", 6),
        "mem" :  #exists("value131", 5),
        "mem" :  #exists("value132", 4)
    }
}


}
