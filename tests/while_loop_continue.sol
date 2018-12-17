contract Test {
    function whileTest(int a, int b) public returns (int) {
        int result = 0;
        int index = 0;

        while(index <= a){
            index = index + 1;

            if(index > b){
                continue;
            }

            result = result + index;
        }

        return result;
    }
}


{


"Test1" : {
    "exec" : {
        "code" : #solidity( int sum = functionCall(new Test(); whileTest; 7, 5);)
    },
    "post" : {
        "mem" :  #exists("sum", 15)
    }
}


}