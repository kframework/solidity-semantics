contract Test {
    function f(uint x) returns(uint y) {
        while (x > 1) {
            if (x == 10) break;
                while (x > 5) {
                    if (x == 8) 
                        break;
                    x--;
                    if (x == 6) 
                        continue;
                    return x;
                }
                x--;
                if (x == 3) 
                    continue;
				break;
			}
			return x;
		}
}

contract main {
    function main() { 
          new Test(); 
          //functionCall(-1;0;f;0;msginfo(-1,0,2,2)); //expected result: x=0,y=0
          //functionCall(-1;0;f;1;msginfo(-1,0,2,2)); //expected result: x=1,y=0
          //functionCall(-1;0;f;2;msginfo(-1,0,2,2)); //expected result: x=1,y=0
          //functionCall(-1;0;f;3;msginfo(-1,0,2,2)); //expected result: x=2,y=0
          //functionCall(-1;0;f;4;msginfo(-1,0,2,2)); //expected result: x=2,y=0
          //functionCall(-1;0;f;5;msginfo(-1,0,2,2)); //expected result: x=4,y=0
          //functionCall(-1;0;f;6;msginfo(-1,0,2,2)); //expected result: x=5,y=0
          //functionCall(-1;0;f;7;msginfo(-1,0,2,2)); //expected result: x=5,y=0
          //functionCall(-1;0;f;8;msginfo(-1,0,2,2)); //expected result: x=7,y=0
          //functionCall(-1;0;f;9;msginfo(-1,0,2,2)); //expected result: x=8,y=0
          //functionCall(-1;0;f;10;msginfo(-1,0,2,2)); //expected result: x=10,y=0
          //functionCall(-1;0;f;11;msginfo(-1,0,2,2)); //expected result: x=10,y=0
          logValue(functionCall(-1;0;f;12;msginfo(-1,0,2,2))); //expected result: x=11,y=0
    }
}