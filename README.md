coffeetypes
===========

Some basic type checking for coffeescript (at runtime)

How to use:

    add = T.def
      in: TArray.of(TNumber)
      out: TNumber
      (x,y) -> x + y

You can do more complex things:

    make_bigrams = T.def
      in: {file: TString, data: TArray.of({verb: TString, object: TString, count: TNumber})}
      out: TArray.of({v1:TString, o1:TString, v2:TString, o2:TString, count:TNumber}) 
      (obj) -> ...

Inspired by contracts.coffee, among other things
