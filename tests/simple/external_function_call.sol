
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

contract Agent {
    Test target;

    constructor (address addr) public {
        target = Test(addr);
    }

    function getA() public returns (int) {
        return target.getA();
    }

    function getB() public returns (int) {
        return target.getB();
    }

    function getC() public returns (int) {
        return target.getC();
    }

    function setA(int value) public {
        target.setA(value);
    }

    function setB(int value) public {
        target.setB(value);
    }

    function setC(int value) public {
        target.setC(value);
    }

    function getSum() public returns (int) {
        return target.getSum();
    }
}


{

"Test1" : {
    "exec" : {
        "code" :
            #solidity(
                address addr = new Test(1,2,3);
                Agent agt = new Agent(addr);

                int a = agt.getA();
                int b = agt.getB();
                int c = agt.getC();
                int sum = agt.getSum();
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
                address addr = new Test(1,2,3);
                Agent agt = new Agent(addr);

                agt.setA(7);
                agt.setB(8);
                agt.setC(9);

                Test t1 = Test(addr);

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
