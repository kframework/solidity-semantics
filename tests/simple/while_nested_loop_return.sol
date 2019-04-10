
contract Test {
    function whileTest(int a, int b, int c) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            index = index + 1;

            int k = 0;

            while(k <= b){
                k = k + 1;

                if(k > c){
                    return result;
                }

                result = result + k;
            }

            result = result + index;
        }

        return result;
    }
}


{


"Test1" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(7,6,4);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 10)
    }
},

"Test2" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(-7,6,4);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 0)
    }
},

"Test3" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(7,-6,4);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 36)
    }
},

"Test4" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(7,6,100);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 260)
    }
},

"Test5" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(7,6,-4);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 0)
    }
}


}