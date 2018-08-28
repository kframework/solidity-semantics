
contract Test {
   function f(uint n) returns (uint r)
		{
			uint i = 1;
			uint k = 0;
			for (i *= 5; k < n; i *= 7)
			{
				k++;
				i += 4;
				if (n % 3 == 0)
					break;
				i += 9;
				if (n % 2 == 0)
					continue;
				i += 19;
			}
			return i;
		}
}

contract main {

    function main() { 
          new Test(); 
          //functionCall(-1;0;f;0;msginfo(-1,0,2,2)); //expected result: r=0,i=5,k=0
          //functionCall(-1;0;f;1;msginfo(-1,0,2,2)); //expected result: r=0,i=259,k=1  
          //functionCall(-1;0;f;2;msginfo(-1,0,2,2)); //expected result: r=0,i=973,k=2 
          //functionCall(-1;0;f;3;msginfo(-1,0,2,2)); //expected result: r=0,i=9,k=1
          //functionCall(-1;0;f;4;msginfo(-1,0,2,2)); //expected result: r=0,i=48405,k=4
          //functionCall(-1;0;f;5;msginfo(-1,0,2,2)); //expected result: r=0,i=711459,k=5
          //functionCall(-1;0;f;6;msginfo(-1,0,2,2)); //expected result: r=0,i=9,k=1
          //functionCall(-1;0;f;7;msginfo(-1,0,2,2)); //expected result: r=0,i=34863283,k=7
          //functionCall(-1;0;f;8;msginfo(-1,0,2,2)); //expected result: r=0,i=116256805,k=8
          //functionCall(-1;0;f;9;msginfo(-1,0,2,2)); //expected result: r=0,i=9,k=1
          logValue(functionCall(-1;0;f;10;msginfo(-1,0,2,2))); //expected result: r=0,i= 5696584173 ,k=10
          
}

}
