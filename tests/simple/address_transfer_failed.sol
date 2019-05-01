contract Test {
    int a;
    uint b = 5;
    bool c =false;

    function f (int x, int m) public returns (int y)  {
        int sum;

        if (x < 0 ) {
            sum = 0;
        }
        else {
            sum = x + f(x - 1, m);
            b = b + 1;
        }

        return sum;
    }
}

contract Move {
    address payable target;
    uint transferedMondy;
    bool executed;

    constructor(address addr) public {
        target = addr;
        transferedMondy = 0;
        executed = false;
    }

    function transferTest(int amount) public {
        target.transfer(amount);
        transferedMondy = transferedMondy + amount;
        executed = true;
    }
}


{


"Test1" : {
	"exec" : {
	    "code" : #solidity(
            address payable addr = new Test();
            addr.transfer(100);

            address payable addr2 = new Move(addr);
            addr2.transfer(200);

            Move t2 = Move(addr2);
            t2.transferTest(10);
        )
	},
    "post" : {
        #Account(addr) : {  #balance(110) },
        #Account(addr2) : { #exists("transferedMondy", 10),  #balance(190), #exists("executed", true) }
    }
},


"Test2" : {
	"exec" : {
	    "code" : #solidity(
            address payable addr = new Test();
            addr.transfer(100);

            address payable addr2 = new Move(addr);
            addr2.transfer(200);

            Move t2 = Move(addr2);
            t2.transferTest(300);
        )
	},
    "post" : {
        #Account(addr) : {  #balance(100) },
        #Account(addr2) : { #exists("transferedMondy", 0),  #balance(200) , #exists("executed", false) }
    }
}


}
