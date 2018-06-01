
solidity-kompiled: solidity-syntax.k configuration.k mcontract.k function.k statement.k solidity.k 
	kompile solidity.k --backend java


clean:
	rm -f -r *~ tests/*~

cleanall:
	rm -f -r *~ *-kompiled

