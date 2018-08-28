MAKEFILE_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DEF=solidity
EXT=sol
TESTDIR=tests/*
KOMPILE_FLAGS=--backend java
KRUN_FLAGS=--output none

include $(MAKEFILE_PATH)/include/ktest.mak
