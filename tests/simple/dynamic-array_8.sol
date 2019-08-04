
contract Test {
    uint[] array;

    function arrayPush(uint value) public returns (uint) {
        return array.push(value);
    }

    function arrayPop() public returns (uint) {
        uint len = array.length;
        uint result = array[len - 1];
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
                    uint len = t.arrayPush(100);
                    int value = t.arrayPop();
                    uint len2 = t.getArrayLength();
                )
    },
    "post" : {
        "mem" :  #exists("len", 1),
        "mem" :  #exists("value", 100),
        "mem" :  #exists("len2", 0)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    uint len1 = t.arrayPush(100);
                    uint len2 = t.arrayPush(200);
                    uint len3 = t.arrayPush(300);

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
