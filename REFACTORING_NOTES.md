# Steps of Refactoring

### Step 1
The first step of a proper refactoring is to build a solid set of tests so after each burst of refactoring ( Refactoring should be done in small Bursts, courtesy of the book Refactoring working effectively with legacy code from Martin Fowler) we can run the test suite like a litmus test to check if we broke anything.

Fortunately we already have a good set of tests. But it's not passing.

So the first step was to find the missing piece so the tests suite passes. After doing a bit of tinkering around the codebase, I found some clue which clearly showed we are only interested in files with extension ```.life```. 

The things that contributed to this decision are:

1. [This commit](https://github.com/joycse06/trike-refactoring-test/commit/304c2a02c495b98eb42677d07ecefcd02ea5ae57)    
2. running ```find spec/fixtures/Life\ on\ Earth -name '*.life' | wc -l``` returns 7 which is the same number of file with ```.life``` extension in the commit above.
3. and finally this assertion [here](https://github.com/joycse06/trike-refactoring-test/blob/master/spec/tree_of_life_spec.rb#L25) proved that I should only be looking at files with extension ```.life```

so the next logical step is to change the find command pattern to ```%x[find '#{path}' -name '*.life']``` which will just find the files with extension ```.life```

