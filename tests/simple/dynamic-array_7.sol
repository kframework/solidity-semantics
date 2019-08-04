
contract Test {
    uint[][] arrays;

    constructor() public {
        arrays.push([10,20,30]);
        arrays.push([100,200,300,400]);
    }

    function getLength() public returns (uint) {
        return arrays.length;
    }

    function getElement(uint index1, uint index2) public returns (uint) {
        return arrays[index1][index2];
    }

    function getArrayLength(uint index) public returns (uint) {
        return arrays[index].length;
    }

    function pushElement(uint index, uint item) public returns (uint){
        return arrays[index].push(item);
    }
}


{

"Test" : {
    "exec" : {
        "code" : #solidity(
                    Test t = new Test();
                    uint value00 = t.getElement(0,0);
                    uint value01 = t.getElement(0,1);
                    uint value02 = t.getElement(0,2);

                    uint value10 = t.getElement(1,0);
                    uint value11 = t.getElement(1,1);
                    uint value12 = t.getElement(1,2);
                    uint value13 = t.getElement(1,3);

                    uint len1 = t.getLength();
                    uint len2 = t.getArrayLength(0);
                    uint len3 = t.getArrayLength(1);

                    uint len4 = t.pushElement(0,40);
                    uint len5 = t.pushElement(1,500);

                    uint value03 = t.getElement(0,3);
                    uint value14 = t.getElement(1,4);
                )
    },
    "post" : {
        "mem" :  #exists("value03", 40),
        "mem" :  #exists("value14", 500),
        "mem" :  #exists("len1", 2),
        "mem" :  #exists("len2", 3),
        "mem" :  #exists("len3", 4),
        "mem" :  #exists("len4", 4),
        "mem" :  #exists("len5", 5)
    }
}


}
