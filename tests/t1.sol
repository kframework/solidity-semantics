
{
"Test1" : {
	"exec" : {
	    "code" : #solidity(int sum ; sum = 3 + 4;)
	},
	"post" : {
	    "mem" :  #exists("sum",7) 
	}
   }
}