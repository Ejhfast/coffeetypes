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

Base Types
----------

* T.string: A string. For example, "string".
* T.number: A number. For example, 23 or 2.5.
* T.bool: A boolean value. For example, true.
* T.any: Matches with anything.
* T.array: An array. For example, [1,2,3].
* T.object: An object. For example, {firstname:"Ethan", lastname:"Fast"}.

Type constructors:
------------------

* T.or: The union of two types. For example, T.number.or(T.bool).
* T.object.has: An object containing the specified keys. For example, T.object.has({firstname:T.string}).
* T.object.exactly: An object with exactly the set of keys defined. For example, T.object.exactly({firstname:T.string, lastname:T.string}).
* T.array.of: An array of some type of value. For example, T.array.of(T.string). This approximates [String] in Haskell.
* T.array.exactly: An array (or tuple) containing exactly some sequence of values. For example, T.array.exactly([T.number, T.number]) might describe an array of x-y coordinate values.


Inspired by contracts.coffee, among other projects
