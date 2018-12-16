contract Test {
    function whileTest(int a) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            result = result + factorial(index);

            index = index + 1;
        }

        return result;
    }

    function factorial(int n) public returns (int){
        int index = 1;
        int result = 1;

        while(index <= n){
            result = result * index;

            index = index + 1;
        }

        return result;
    }
}


{


"Test1" : {
    "exec" : {
        "code" : #solidity( int result = functionCall(new Test(); whileTest; 4);)
    },
    "post" : {
        "mem" :  #exists("result", 34)
    }
}


}