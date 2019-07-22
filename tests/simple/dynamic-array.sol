
contract Test {
    uint[] array;

    function arrayPush(uint value) public {
        array.push(value);
    }

    function arrayPop() public returns (uint) {
        uint result = array[array.length - 1];
        array.pop();

        return result;
    }

    function getArrayLength() public returns (uint) {
        return array.length;
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    uint len0 = t.getArrayLength();
                    t.arrayPush(100);
                    uint len = t.getArrayLength();
                    int value = t.arrayPop();
                )
    },
    "post" : {
        "mem" :  #exists("len0", 0),
        "mem" :  #exists("len", 1),
        "mem" :  #exists("value", 100)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.arrayPush(100);
                    uint len1 = t.getArrayLength();
                    t.arrayPush(200);
                    uint len2 = t.getArrayLength();
                    t.arrayPush(300);
                    uint len3 = t.getArrayLength();

                    uint value1 = t.arrayPop();
                    uint value2 = t.arrayPop();
                    uint value3 = t.arrayPop();

                    uint len4 = t.getArrayLength();
                )
    },
    "post" : {
        "mem" :  #exists("len1", 1),
        "mem" :  #exists("len2", 2),
        "mem" :  #exists("len3", 3),
        "mem" :  #exists("len4", 0),
        "mem" :  #exists("value1", 300),
        "mem" :  #exists("value2", 200),
        "mem" :  #exists("value3", 100)
    }
}


}
