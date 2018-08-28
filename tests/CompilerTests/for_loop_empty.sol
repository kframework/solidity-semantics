contract Test {
	function f() returns(uint ret) {
		ret = 1;
		for (;;) {
			ret += 1;
			if (ret >= 10) 
				break;
		}
		return ret;
	}
}

contract main {
	function main() { 
		new Test(); 
		logValue(functionCall(-1;0;f;;msginfo(-1,0,2,2))); //expected result: ret=10
	}
}
