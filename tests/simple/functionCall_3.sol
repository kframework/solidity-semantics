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
        "code" :
            #solidity(
                C c1 = new C();
                int sum = c1.f(3,1);
            )
    },
    "post" : {
        "mem" :  #exists("sum",6)
    }
}


}