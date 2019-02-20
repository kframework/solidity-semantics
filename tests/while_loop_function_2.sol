contract Test {
    function whileTest(int a, int b) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            result = result + factorial(index);

            index = index + 1;

            if(result > b){
                return result;
            }
        }

        return result;
    }

    function factorial(int n) public returns (int){
        int index = 1;
        int result = 1;

        while(index <= n){
            result = result * index;

            index = index + 1;
        }

        return result;
    }
}


{


"Test1" : {
    "exec" : {
        "code" : #solidity( int result = functionCall(new Test(); whileTest; 5, 20);)
    },
    "post" : {
        "mem" :  #exists("result", 34)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity( int result = functionCall(new Test(); whileTest; 0, 20);)
    },
    "post" : {
        "mem" :  #exists("result", 1)
    }
},

"Test3" : {
    "exec" : {
        "code" : #solidity( int result = functionCall(new Test(); whileTest; -10, 10);)
    },
    "post" : {
        "mem" :  #exists("result", 0)
    }
},

"Test3" : {
    "exec" : {
        "code" : #solidity( int result = functionCall(new Test(); whileTest; 10, 50);)
    },
    "post" : {
        "mem" :  #exists("result", 154)
    }
}


}