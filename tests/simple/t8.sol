
{
"Test1" : {
	"exec" : {
	    "code" : #solidity(
	    	   bool s ; int b; int a; a = 3; b = 4; s = a > b;
		   )
	},
	"post" : {
	    "mem" :  #exists("s",false) #exists("a",3) #exists("b", 4)
	}
   }
}