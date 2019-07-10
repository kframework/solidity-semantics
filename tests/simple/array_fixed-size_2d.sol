
contract Test {
    uint[3][4] array;

    constructor() public{
        uint i = 0;
        uint j = 0;

        while(i < 4){
            while(j < 3) {
                array[i][j] = i + j;

                j = j + 1;
            }
            j = 0;
            i = i + 1;
        }
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
}


}
