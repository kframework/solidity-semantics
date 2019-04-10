
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
        "code" :
            #solidity(
                Test t1 = new Test();
                int sum = t1.whileTest(4);
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
                int sum = t1.whileTest(0);
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
                int sum = t1.whileTest(-2);
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
                int sum = t1.whileTest(10);
            )
    },
    "post" : {
        "mem" :  #exists("sum", 55)
    }
}


}
