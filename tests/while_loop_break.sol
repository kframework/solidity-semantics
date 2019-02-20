
contract Test {
    function whileTest(int a, int b) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            index = index + 1;
            result = result + index;

            if(result > b){
                break;
            }
        }

        return result;
    }
}


{

"Test1" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 20, 15);)
    },
    "post" : {
        "mem" :  #exists("sum", 21)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 20, 0);)
    },
    "post" : {
        "mem" :  #exists("sum", 1)
    }
},

"Test3" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 20, 30);)
    },
    "post" : {
        "mem" :  #exists("sum", 36)
    }
},

"Test4" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 30, 400);)
    },
    "post" : {
        "mem" :  #exists("sum", 406)
    }
}

}
