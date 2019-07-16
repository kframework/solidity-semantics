
contract Test {
    uint[] array;

    constructor() public{
       array.push(100);
       array.push(200);
       array.push(300);
       array.push(400);
    }

    function increaseSize(uint size) public {
        array.length = array.length + size;
    }

    function getElement(uint index) public returns (uint) {
        return array[index];
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    uint value1 = t.getElement(0);
                    uint value2 = t.getElement(1);
                    uint value3 = t.getElement(2);
                    uint value4 = t.getElement(3);
                )
    },
    "post" : {
        "mem" :  #exists("value1", 100),
        "mem" :  #exists("value2", 200),
        "mem" :  #exists("value3", 300),
        "mem" :  #exists("value3", 400)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.increaseSize(4);
                    uint value1 = t.getElement(4);
                    uint value2 = t.getElement(5);
                    uint value3 = t.getElement(6);
                    uint value4 = t.getElement(7);
                )
    },
    "post" : {
        "mem" :  #exists("value1", 0),
        "mem" :  #exists("value2", 0),
        "mem" :  #exists("value3", 0),
        "mem" :  #exists("value3", 0)
    }
}


}
