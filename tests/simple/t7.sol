
{
"Test1" : {
	"exec" : {
	    "code" : #solidity(int s ; int b; int a; a = 3; b = 4; s = 7 * a / b;)
	},
	"post" : {
	    "mem" :  #exists("s",5) #exists("a",3) #exists("b", 4)
	}
   }
}