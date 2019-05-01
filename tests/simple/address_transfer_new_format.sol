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

    constructor(address payable addr) public {
        target = addr;
    }

    function transferTest(int amount) public returns (bool result) {
        if(this.balance > amount){
            target.transfer(amount);
            return true;
        }
        else{
            return false;
        }
    }
}


{


"Test1" : {
	"exec" : {
	    "code" : #solidity(
            address payable addr = new Test();
            addr.transfer(100);
            int balance1 = addr.balance;

            address payable addr2 = new Move(addr);
            addr2.transfer(200);

            Move t2 = Move(addr2);
            bool result = t2.transferTest(10);
            int balance2 = addr.balance;
            int balance3 = addr2.balance;
        )
	},
    "post" : {
        "mem" :  {
            #exists("balance1", 100), #exists("balance2", 110),
            #exists("balance3", 190), #exists("result", true)
        }
    }
},


"Test2" : {
	"exec" : {
	    "code" : #solidity(
            address payable addr = new Test();
            addr.transfer(100);
            int balance1 = addr.balance;

            address payable addr2 = new Move(addr);
            addr2.transfer(200);

            Move t2 = Move(addr2);
            bool result = t2.transferTest(300);
            int balance2 = addr.balance;
            int balance3 = addr2.balance;
        )
	},
    "post" : {
        "mem" :  { #exists("balance1", 100), #exists("balance2", 100), #exists("balance3", 200), #exists("result", false) }
    }
}


}
