coffeetypes
===========

Some basic type checking for coffeescript (at runtime)

How to use:

    T = require './type.coffee'

    add = T.def
      in: [T.number, T.number]
      out: T.number,
      (x,y) -> x + y

Try to run something like:

    add 3, "s"

And you get:

    invalid input type
	     need: [TNumber,TNumber]
	     given: [3,s]

You can do more complex things:

    make_bigrams = T.def
      in: [T.string, T.array.of({verb: T.string, object: T.string})]
      out: T.array.of({v1:T.string, o1:T.string, v2:T.string, o2:T.string, count:T.number}),
      (filename, tuples) -> ...

Inspired by contracts.coffee, among other projects
