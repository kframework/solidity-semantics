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
            address payable addr = new C();
            bool result1 = addr.send(100);

            address payable addr2 = new C();
            bool result2 = addr2.send(200);

            address payable addr3 = new C();
            bool result3 = addr3.send(1000000);
        )
	},
	"post" : {
	    "mem" :  #exists("result1", true),
        "mem" :  #exists("result2", true),
        "mem" :  #exists("result3", false),
        #Account(addr) : { #balance(100) },
        #Account(addr2) : { #balance(200) },
        #Account(addr3) : { #balance(0) }
	}
   }
}
