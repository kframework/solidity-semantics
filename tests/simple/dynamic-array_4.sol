
contract Test {
    uint[] array;

    constructor() public{
       array.push(100);
       array.push(200);
       array.push(300);
       array.push(400);
    }

    function changeValue() public {
        uint[] storage temp = array;

        temp[0] = 10;
        temp[1] = 20;
        temp[2] = 30;
        temp[3] = 40;
    }

    function getElement(uint index) public returns (uint) {
        return array[index];
    }
}


{

"Test" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    t.changeValue();
                    uint value1 = t.getElement(0);
                    uint value2 = t.getElement(1);
                    uint value3 = t.getElement(2);
                    uint value4 = t.getElement(3);
                )
    },
    "post" : {
        "mem" :  #exists("value1", 10),
        "mem" :  #exists("value2", 20),
        "mem" :  #exists("value3", 30),
        "mem" :  #exists("value3", 40)
    }
}


}
