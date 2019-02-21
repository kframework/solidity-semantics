contract Test {
    function whileTest(int a, int b) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            index = index + 1;

            if(index > b){
                continue;
            }

            result = result + index;
        }

        return result;
    }
}


{


"Test1" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 7, 5);)
    },
    "post" : {
        "mem" :  #exists("sum", 15)
    }
},

"Test2" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 0, 8);)
    },
    "post" : {
        "mem" :  #exists("sum", 1)
    }
},

"Test3" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 10, 10);)
    },
    "post" : {
        "mem" :  #exists("sum", 55)
    }
},

"Test4" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 40, 20);)
    },
    "post" : {
        "mem" :  #exists("sum", 210)
    }
}

}
