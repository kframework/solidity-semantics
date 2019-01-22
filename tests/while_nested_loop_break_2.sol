
contract Test {
    function whileTest(int a, int b, int c, int d) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            index = index + 1;

            int k = 0;

            while(k <= b){
                k = k + 1;

                if(k > c){
                    break;
                }

                result = result + k;
            }

            result = result + index;

            if(result > d){
                break;
            }
        }

        return result;
    }
}


{


"Test1" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 7, 6, 4, 50);)
    },
    "post" : {
        "mem" :  #exists("sum", 65)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; -1, 6, 4, 50);)
    },
    "post" : {
        "mem" :  #exists("sum", 0)
    }
},

"Test3" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 7, -2, 4, 50);)
    },
    "post" : {
        "mem" :  #exists("sum", 36)
    }
},

"Test4" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 7, 6, 4, 100);)
    },
    "post" : {
        "mem" :  #exists("sum", 116)
    }
}


}