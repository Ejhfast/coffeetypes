coffeetypes
===========

Some basic type checking for coffeescript (at runtime)

How to use:

    add = T.def
      in: [TNumber, TNumber]
      out: TNumber
      (x,y) -> x + y

You can do more complex things:

    make_bigrams = T.def
      in: [TString, TArray.of({verb: TString, object: TString})]
      out: TArray.of({v1:TString, o1:TString, v2:TString, o2:TString, count:TNumber}) 
      (filename, tuples) -> ...

Inspired by contracts.coffee, among other things
