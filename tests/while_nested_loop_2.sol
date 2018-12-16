contract Test {
    function whileTest(int a, int b, int c) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            result = result + index;

            int k = 0;

            while(k <= b){
                result = result + k;

                int t = 1;

                while(t <= c){
                    result = result * t;

                    t = t + 1;
                }

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
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 4, 2, 2);)
    },
    "post" : {
        "mem" :  #exists("sum", 42792)
    }
}


}