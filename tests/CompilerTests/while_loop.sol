contract Test {
    function f(uint n) returns(uint nfac) {
        nfac = 1;
        var i = 2;
        while (i <= n) 
            nfac *= i++;
        return nfac;
    }
}

contract main {
    function main() { 
        new Test(); 
        //functionCall(-1;0;f;0;msginfo(-1,0,2,2)); //expected result: i=2, nfac = 1
        //functionCall(-1;0;f;1;msginfo(-1,0,2,2)); //expected result: i=2, nfac = 1
        //functionCall(-1;0;f;2;msginfo(-1,0,2,2)); //expected result: i=3, nfac = 2
        //functionCall(-1;0;f;3;msginfo(-1,0,2,2)); //expected result: i=4, nfac = 6
        logValue(functionCall(-1;0;f;4;msginfo(-1,0,2,2))); //expected result: i=5, nfac = 24
        //functionCall(-1;0;f;5;msginfo(-1,0,2,2)); //expected result: i=6, nfac = 120
    }
}
