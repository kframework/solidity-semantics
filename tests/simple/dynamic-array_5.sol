
contract Test {
    uint[] array;

    function changeValue() public {
        uint[] memory temp = new uint[](4);

        temp[0] = 10;
        temp[1] = 20;
        temp[2] = 30;
        temp[3] = 40;

        array = temp;       // this causes a copy from temp to array
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
        "mem" :  #exists("value4", 40)
    }
}


}
