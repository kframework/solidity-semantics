
contract Test {
    int sv;

    function whileTest(int a) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            result = result + index;
            index = index + 1;
        }

	    sv = 12;

        return result;
    }

    function argTest(address a, int x){
        a.transfer(x);
    }
}


{

"Test1" : {
    "pre"  : {
        "block.number" : 1,
        "block.timestamp" : 2,
        "msg.sender" : #(3, 4)
    },
    "exec" : {
        "code" :
        #solidity(
            address addr1 = new Test();     // deploy the first instance of Test
            addr1.transfer(4000);            // initialize the balance of the first instance

            address addr2 = new Test();     // deploy the second instance of Test
            addr2. transfer(4000);           // initialize the balance of the second instance

            Test t1 = Test(addr1);
            int sum = t1.whileTest(4);

            Test t2 = Test(addr2);
            int sum2 = t2.whileTest(5);

            addr2.argTest(addr1, 10);

            int balance1 = addr1.balance;
            int balance2 = addr2.balance;
        )
    },
    "post" : {
        "mem" : #exists("sum", 10) ,
        "mem" : #exists("balance1", 4010),
        "mem" : #exists("balance2", 3990),
	    #Account(addr1) : { #exists("sv", 12),  #balance(4010) },
        #Account(addr2) : { #balance(3990) }
    }
  }
}
