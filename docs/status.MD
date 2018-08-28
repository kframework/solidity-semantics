# Status

* Semantics covers most features, however it needs more testing; we expect additional issues (or missing cases) to arise once we start running tests systematically. 

* Recently implemented basic test harness, based on the `ktest` scripts included in K5. See `README.MD` for details, and see the `tests` folder for example of tests. Still a work in progress at the time of writing, so testing is not complete yet. 

## Resources

* Trello board (not very actively used): https://trello.com/b/kqfWwSsk/solidity-semantics

## Known issues (style etc.)

* Separation of files (`statement.k`, `function.k` etc.) probably does not reflect the content anymore. Should figure out how we want to separate the files. 
* Several names (of cells, terms etc.) are still a bit cryptic
* no comments/documentation
    * shall we use markdown as in IELE and KEVM?

## Known issues (semantics)

* Several rules with missing side conditions e.g. case 1 for an empty list (`.List`) and case 2 for a non-empty one, but missing the side condition (potentially allowing both empty and non-empty lists to match, although this usually doesn't happen because of the order the rules are written and picked by the tool). Many of those cases have been fixed, but there may be some still out there. 

* Recently found issue w variable scope; should be fixed as hi priority

* ambiguities in the grammar. Most of those should be fixed, but it's still something to be aware of. 

## Other thoughts

* internal, semantic-level constructs (e.g. `functionCall`) are mixed together with actual language expressions, statements etc. Not sure if this is a problem or not (and, actually, such a thing can be useful for testing)