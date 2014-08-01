_ = require "underscore"

# Okay, so in the JavaScript ghetto types will be objects...
# Types respond to .is_type as a class method

class T
  @match: (t_obj, obj) ->
    if TArray.is_type(t_obj)
      if t_obj.length == obj.length
        parts = _.zip(t_obj, obj)
        try_parts = _.map(parts, (x)->(T.match(x[0],x[1])))
        _.reduce(try_parts, ((x,y)->x and y), true)
      else
        false
    else if TObject.is_type(t_obj)
      t_lst = _.map(t_obj, (v,k) -> [v,k])
      o_lst = _.map(obj, (v,k) -> [v,k])
      T.match(t_lst, o_lst)
    else if (TString.is_type(t_obj) or TNumber.is_type(t_obj))
      t_obj is obj
    else
      t_obj.is_type(obj)
  @def: (type, method) ->
          (args...) ->
            if T.match type.in, args
              value = method.apply @, args
              if T.match type.out, value
                value
              else
                {fail: "invalid output type", need:T.show(type.out), returned:value}
            else
              {fail: "invalid input type", need:T.show(type.in), given:args}
  @is_type: (e) -> false
  @show: (obj) ->
    if TArray.is_type(obj)
      "[#{_.map(obj, (x) -> T.show(x)).join(",")}]"
    else if TObject.is_type(obj)
      "{#{_.map(obj, (v,k) -> T.show(k)+":"+T.show(v))}}"
    else if TString.is_type(obj)
      obj
    else if TNumber.is_type(obj)
      obj.toString()
    else
      obj.show()

class TString extends T
  @is_type: (e) ->
    typeof(e) is "string"
  @show: () -> "TString"

class TNumber extends T
  @is_type: (e) ->
    typeof(e) is "number"
  @show: () -> "TNumber"

class TObject extends T
  @is_type: (e) ->
    if typeof(e) is "object"
      if e instanceof Array then false else true
  @show: () -> "TObject"

class TArray extends T
  # Optionally define the type of element in an array
  # E.g., TArray.of(TNumber) which is like [Number] in Haskell
  @of: (sub) ->
    class extends TArray
      @is_type: (e) ->
        if super e
          check_elements = _.map(e, (x)->T.match(sub,x))
          _.reduce(check_elements, ((x,y)->x and y), true)
        else
          false
      @show: () -> "TArray.of(#{T.show(sub)})"
  @is_type: (e) ->
    if typeof(e) is "object"
      if e instanceof Array then true else false
  @show: () -> "TArray"

module.exports =
  def: T.def
  match: T.match
  string: TString
  number: TNumber
  array: TArray
  object: TObject
