
contract Test {
    function whileTest(int a, int b, int c, int d) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            index = index + 1;

            int k = 0;

            while(k <= b){
                k = k + 1;

                if(k > c){
                    continue;
                }

                result = result + k;
            }

            result = result + index;

            if(result > d){
                break;
            }
        }

        return result;
    }
}


{


"Test1" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 5, 4, 3, 20);)
    },
    "post" : {
        "mem" :  #exists("sum", 24)
    }
}


}