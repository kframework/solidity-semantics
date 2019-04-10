contract C {
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


{

"Test1" : {
	"exec" : {
	    "code" : #solidity(
            address addr = new C();
            addr.transfer(100);
            int balance1 = addr.balance;

            C t1 = C(addr);
            int sum = t1.f(2,1);

            address addr2 = new C();
            addr2.transfer(200);
            int balance2 = addr2.balance;

            C t2 = C(addr2);
            int sum2 = t2.f(2,1);
        )
	},
	"post" : {
	    "mem" :  #exists("sum",3),
        "mem" :  #exists("sum2",3),
        "mem" :  #exists("balance1", 100),
        "mem" :  #exists("balance2", 200)
	}
   }
}
