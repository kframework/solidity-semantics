
{
"Test1" : {
	"exec" : {
	    "code" : #solidity(int sum ; int b; int a; a = 3; b = 4; sum = 7 + a * b;)
	},
	"post" : {
	    "mem" :  { #exists("sum",19), #exists("a",3), #exists("b", 4) }
	}
   }
}