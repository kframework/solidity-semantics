contract Test {

    int foo = 123;

    function f(uint n) returns(uint nfac) {
        nfac = 1;
        var i = 2;
        do { nfac *= i++; } while (i <= n);
        return nfac;
    }

    function g(uint n1) returns(uint nfac1) {
       i = 999;
    }
}

contract main 
{
    function main() { 
        new Test();   
     
        logValue(functionCall(-1; 0; f; 6; msginfo(-1,0,2,2))); // 720
    }
}