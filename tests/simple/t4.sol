
{
"Test1" : {
	"exec" : {
	    "code" : #solidity(int sum ; int b; int a; a = 3; b = 4; sum = a * b;)
	},
	"post" : {
	    "mem" :  #exists("sum",12) #exists("a",3) #exists("b", 4)
	}
   }
}