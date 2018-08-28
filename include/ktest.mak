# path to the current makefile
MAKEFILE_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# path to the kompile binary of this distribuition
KOMPILE=kompile

# ditto for krun
KRUN=krun

# and kdep
KDEP=kdep

# and kprove
KPROVE=kprove

# path relative to current definition of test programs
TESTDIR?=tests

# path to put -kompiled directory in
DEFDIR?=.

# path relative to current definition of output/input files
RESULTDIR?=$(TESTDIR)

# all tests in test directory with matching file extension
TESTS=$(wildcard $(TESTDIR)/*.$(EXT))
PROOF_TESTS=$(wildcard $(TESTDIR)/*-spec.k)

CHECK=| diff -

.PHONY: kompile tests all clean update-results proofs

# run all tests
all: kompile tests proofs

# run only kompile
kompile: $(DEFDIR)/$(DEF)-kompiled/timestamp

$(DEFDIR)/%-kompiled/timestamp: %.k
	$(KOMPILE) $(KOMPILE_FLAGS) $(DEBUG) $< -d $(DEFDIR)
tests: $(TESTS)

proofs: $(PROOF_TESTS)

# run all tests and regenerate output files
update-results: tests proofs
update-results: CHECK=>

# run a single test. older versions of make run pattern rules in order, so
# if some programs should be run with different options their rule should be
# specified in the makefile prior to including ktest.mak.
%.$(EXT): kompile
ifeq ($(TESTDIR),$(RESULTDIR))
	-cat $@.in 2>/dev/null | $(KRUN) $@ $(KRUN_FLAGS) $(DEBUG) -d $(DEFDIR) $(CHECK) $@.out
else
	-cat $(RESULTDIR)/$(notdir $@).in 2>/dev/null | $(KRUN) $@ $(KRUN_FLAGS) $(DEBUG) -d $(DEFDIR) $(CHECK) $(RESULTDIR)/$(notdir $@).out
endif

%-spec.k: kompile
	$(KPROVE) -d $(DEFDIR) --z3-executable $@ $(CHECK) $@.out

clean:
	rm -rf $(DEFDIR)/$(DEF)-kompiled

.depend:
	@$(KDEP) $(DEF).k > .depend-tmp
	@mv .depend-tmp .depend

-include .depend
