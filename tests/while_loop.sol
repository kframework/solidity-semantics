
contract Test {
    function whileTest(int a) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            result = result + index;
            index = index + 1;
        }

        return result;
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 4);)
    },
    "post" : {
        "mem" :  #exists("sum", 10)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 0);)
    },
    "post" : {
        "mem" :  #exists("sum", 0)
    }
},

"Test3" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; -2);)
    },
    "post" : {
        "mem" :  #exists("sum", 0)
    }
},

"Test4" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 10);)
    },
    "post" : {
        "mem" :  #exists("sum", 55)
    }
}


}
