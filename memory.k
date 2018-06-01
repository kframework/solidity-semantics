

module MEMORY

/*@*****************************************
	The syntax of address
********************************************/

syntax Address
       ::= ...

syntax MemOp
       ::= read(Id)
       	 | write(Id,Value)
	 | allocateM(Int)		//allocate a block of memory of size INT
	 | allocateS(Int)		
	 | append(Address,Value)	//allocate a block of memory of size INT
         | allocate(Id,Int)
         
	 

endmodule
