
contract Test {
    uint a;
    uint b;
    uint c;
    uint[3] array;

    constructor() public{
        a = 1;
        b = 2;
        c = 3;
        array = [a,b,c];
    }

    function arrayRead(uint index) public returns (uint) {
        if(index < 3){
            return array[index];
        }
        else{
            return array[0];
        }
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    int value = t.arrayRead(0);
                )
    },
    "post" : {
        "mem" :  #exists("value", 1)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    int value = t.arrayRead(1);
                )
    },
    "post" : {
        "mem" :  #exists("value", 2)
    }
},

"Test3" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    int value = t.arrayRead(2);
                )
    },
    "post" : {
        "mem" :  #exists("value", 3)
    }
},

"Test4" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    int value = t.arrayRead(10);
                )
    },
    "post" : {
        "mem" :  #exists("value", 1)
    }
}


}
