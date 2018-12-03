#!/usr/bin/env python3

from kninja import *

# Project Definition
# ==================
#

proj = KProject()
driver = proj.source('driver.k').then(proj.kompile(backend = 'java')
                                          .variables(directory = '.build/driver')
                                          .implicit([ 'configuration.k'
                                                    , 'contract.k'
                                                    , 'expression.k'
                                                    , 'function.k'
                                                    , 'solidity-syntax.k'
                                                    , 'solidity.k'
                                                    , 'statement.k'
                                                    ])
                                     )

def do_test(file):
    proj.source(file) \
        .then(driver.krun()) \
        .then(proj.check(proj.source('tests/expected'))
                     .variables(flags = '--ignore-all-space')) \
        .default()

do_test('tests/functionCall.sol')
do_test('tests/functionCall_2.sol')
do_test('tests/functionCall_3.sol')
do_test('tests/t1.sol')
do_test('tests/t2.sol')
do_test('tests/t3.sol')
do_test('tests/t4.sol')
do_test('tests/t5.sol')
do_test('tests/t6.sol')
do_test('tests/t7.sol')
do_test('tests/t8.sol')
