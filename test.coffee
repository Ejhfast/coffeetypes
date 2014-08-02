T = require "./type.coffee"
_ = require 'underscore'

# EXAMPLES

add = T.def
  in: [T.number, T.number]
  out: T.number,
  (x,y) -> x + y

add_age = T.def
  in: [{name:T.string, age:T.number}, {name:T.string, age:T.number}]
  out: T.number,
  (o1,o2) -> o1.age + o2.age

word_in_set = T.def
  in: [T.string]
  out: T.array.exactly([true, T.number]).or T.array.exactly([false, T.string])
  (word) ->
    set = {"book":100, "chair":200, "dog":600, "what":"s"}
    if word in _.keys(set)
      [true, set[word]]
    else
      [false, "not in set"]

# console.log word_in_set "what"
# console.log "It's ok to add 3 to 4"
# console.log add(3,4)
# console.log "\nBut not 3 to 's'"
# console.log add(3,"s")
# console.log "\nWe can add two ages"
# console.log add_age({name:"Ethan Fast", age:24}, {name:"Eric Fast", age:22})
# console.log "\nBut that won't work if an age doesn't exist"
# console.log add_age({name:"Ethan Fast", age:24},{name:"Eric Fast"})

tests = [
  T.match(T.number, 2) is true,
  T.match(T.number.or(T.string), "s") is true,
  T.match(T.number.or(T.string), 2) is true,
  T.match(T.array.of(T.number), [1,2,3]) is true,
  T.match({x:T.number, y:T.number}, {x:23,y:67}) is true,
  T.match({x:T.number, y:T.any}, {x:23,y:67}) is true,
  T.match({succeed:T.bool, y:T.number}, {succeed:true,y:67}) is true,
  T.match(T.object.only({x:T.number, y:T.number}), {x:23,y:67}) is true,
  T.match(T.array.exactly([T.number, T.string]), [2,"s"]) is true,
  T.match(T.object.has({x:T.number}), {x:23,y:67}) is true,
  T.match(
    {name:T.string, age:T.number, data:T.object},
    {name:"Ethan", age:24, data:{email:"ejhfast@gmail.com"}}) is true,
  T.match(
    T.array.of({name:T.string, age:T.number}),
    [{name:"Ethan",age:24}, {name:"Eric",age:22}]) is true,
  T.match(
    T.array.of({name:T.string, age:T.number}),
    [{gender:"male",age:24}, {gender:"male",age:22}]) is false,
  T.match(T.array.exactly([T.number, T.string]), [true,"s"]) is false,
  T.match(T.object.has({age:T.number}),{name:"Ethan"}) is false,
  T.match({gender:"male",age:T.number}, {gender:"male", age:24}) is true,
  T.match(T.object.only({x:T.number}), {x:23,y:67}) is false,
  T.match({gender:"male",age:T.number}, {gender:"female", age:24}) is false,
  T.match(T.array.of(T.string), [1,2,3]) is false,
  T.match({x:T.bool, y:T.number}, {x:23,y:67}) is false,
  T.match({x:T.string, y:T.number}, {x:23,y:67}) is false,
  T.match({x:T.string, w:T.number}, {x:23,y:67}) is false,
  T.match(T.array, {one:1,two:2}) is false
]

if _.reduce(tests, ((x,y)-> x and y), true)
  console.log("All tests pass.")
else
  console.log(tests)
