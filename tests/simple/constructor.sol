
contract Test {
    int a;
    int b;
    int c;

    constructor(int a_, int b_, int c_) public {
        a = a_;
        b = b_;
        c = c_;
    }

    function getA() public returns (int) {
        return a;
    }

    function getB() public returns (int) {
        return b;
    }

    function getC() public returns (int) {
        return c;
    }

    function setA(int a_) public {
        a = a_;
    }

    function setB(int b_) public {
        b = b_;
    }

    function setC(int c_) public {
        c = c_;
    }

    function getSum() public returns (int) {
        return a + b + c;
    }
}


{

"Test1" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test(1,2,3);
                int a = t1.getA();
                int b = t1.getB();
                int c = t1.getC();
                int sum = t1.getSum();
            )
    },
    "post" : {
        "mem" :  #exists("a", 1),
        "mem" :  #exists("b", 2),
        "mem" :  #exists("c", 3),
        "mem" :  #exists("sum", 6)
    }
},

"Test2" : {
    "exec" : {
        "code" :
            #solidity(
                Test t1 = new Test(1,2,3);

                t1.setA(7);
                t1.setB(8);
                t1.setC(9);

                int a = t1.getA();
                int b = t1.getB();
                int c = t1.getC();
                int sum = t1.getSum();
            )
    },
    "post" : {
        "mem" :  #exists("a", 7),
        "mem" :  #exists("b", 8),
        "mem" :  #exists("c", 9),
        "mem" :  #exists("sum", 24)
    }
}


}
