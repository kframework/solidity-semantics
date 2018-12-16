
contract Test {
    function whileTest(int a, int b) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            result = result + index;

            int k = 0;

            while(k <= b){
                result = result + k;
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
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 4, 2);)
    },
    "post" : {
        "mem" :  #exists("sum", 25)
    }
}


}