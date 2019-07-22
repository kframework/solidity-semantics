
contract Test {
    uint[][2] array;

    function arrayPush(uint index, uint value) public {
        array[index].push(value);
    }

    function arrayPop(uint index) public returns (uint) {
        uint len = array[index].length;
        uint result = array[index][len - 1];
        array[index].pop();

        return result;
    }

    function getArrayLength(uint index) public returns (uint) {
        return array[index].length;
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.arrayPush(0,100);
                    uint len = t.getArrayLength(0);
                    int value = t.arrayPop(0);
                    uint len2 = t.getArrayLength(1);
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
                    t.arrayPush(1,100);
                    uint len1 = t.getArrayLength(1);
                    t.arrayPush(1,200);
                    uint len2 = t.getArrayLength(1);
                    t.arrayPush(1,300);
                    uint len3 = t.getArrayLength(1);

                    uint value1 = t.arrayPop(1);
                    uint value2 = t.arrayPop(1);
                    uint value3 = t.arrayPop(1);

                    uint len4 = t.getArrayLength(1);
                    uint len5 = t.getArrayLength(0);
                )
    },
    "post" : {
        "mem" :  #exists("len1", 1),
        "mem" :  #exists("len2", 2),
        "mem" :  #exists("len3", 3),
        "mem" :  #exists("len4", 0),
        "mem" :  #exists("len5", 0),
        "mem" :  #exists("value1", 300),
        "mem" :  #exists("value2", 200),
        "mem" :  #exists("value3", 100)
    }
}


}
