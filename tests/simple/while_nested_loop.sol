
contract Test {
    function whileTest(int a, int b) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            result = result + index;

            int k = 0;

            while(k <= b){
                result = result + k;
                k = k + 1;
            }

            index = index + 1;
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
                int sum = t1.whileTest(4,2);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 25)
    }
},

"Test2" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(0,2);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 3)
    }
},

"Test3" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(-1,2);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 0)
    }
},

"Test4" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(9,9);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 495)
    }
}


}