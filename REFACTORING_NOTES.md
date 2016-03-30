# Steps of Refactoring

### Step 1 -- Making the Test suite to pass
The first step of a proper refactoring is to build a solid set of tests so after each burst of refactoring ( Refactoring should be done in small Bursts, courtesy of the book Refactoring working effectively with legacy code from Martin Fowler) we can run the test suite like a litmus test to check if we broke anything.

Fortunately we already have a good set of tests which is our specification of how the program should work. But it's not passing.

So the first step is to find the missing piece so the tests suite passes. After doing a bit of tinkering around the codebase, I found some clue which clearly showed we are only interested in files with extension ```.life```. 

The things that contributed to this decision are:

1. [This commit](https://github.com/joycse06/trike-refactoring-test/commit/304c2a02c495b98eb42677d07ecefcd02ea5ae57)    
2. running ```find spec/fixtures/Life\ on\ Earth -name '*.life' | wc -l``` returns 7 which is the same number of file with ```.life``` extension in the commit above.
3. and finally this assertion [here](https://github.com/joycse06/trike-refactoring-test/blob/master/spec/tree_of_life_spec.rb#L25) proved that I should only be looking at files with extension ```.life```

so the next logical step is to change the find command pattern to ```%x[find '#{path}' -name '*.life']``` which will just find the files with extension ```.life```

And it made the tests passing. First step done. We are good to go ahead and start refacroring confidently now. :)

### Step 2 -- extracting some heper methods

The Single ```TreeOfLife``` class is doing too much which is breaking the first of the ```SOLID``` prnciples a.k.a ```The Single Responsibility Principle``` which states that **a class should have one and only one reason to change**.

From a quick look at the public interfaces of the ```TreeOfLife``` class we can see that all of them are validating the argument the same way which is duplication of the logic and can be a nightmare for future changes if **we want to validate the args using a different logic in future**.
We are also doing a lots of ```case-insensitive``` string comparison which we can extract to a method.

Checking if a string is empty or two are same are clearly not the responsibility of the ```TreeOfLife``` class, they call for a Helper class or even better a Module which can be ```Mixed-In``` into our current class. Lets do it.



