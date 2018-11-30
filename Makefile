
#MAKEFILE_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DEF=solidity
EXT=sol
TESTDIR=tests/*
KOMPILE_FLAGS=--backend java
KRUN_FLAGS=--output none

#include $(MAKEFILE_PATH)/include/ktest.mak

driver-kompiled: *.k
	kompile driver.k $(KOMPILE_FLAGS)


solidity-kompiled: *.k
	kompile solidity.k $(KOMPILE_FLAGS)

clean:
	rm -f *~

