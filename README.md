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
	     need: [Number,Number]
	     given: [3,s]

You can do more complex things:

    word_in_set = T.def
      in: [T.string]
      out: T.array.exactly([true, T.number]).or T.array.exactly([false, T.string])
      (word) ->
        set = {"book":100, "chair":200, "dog":600, "what":"s"}
        if word in _.keys(set)
          [true, set[word]]
        else
          [false, "not in set"]

If you call:

    word_in_set "what"

You'll get the error:

    invalid output type
	     need:TArray.exactly([true,Number])
	     returned:[true,s]

Inspired by contracts.coffee, among other projects
