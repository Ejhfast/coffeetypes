_ = require "underscore"

# Okay, so in the JavaScript ghetto types will be objects...
# Types respond to .is_type as a class method

class T
  @match: (t_obj, obj) ->
    if TArray.is_type(t_obj)
      if t_obj.length == obj.length
        parts = _.zip(t_obj, obj)
        _.every(parts, (x)->(T.match(x[0],x[1])))
      else
        false
    else if TObject.is_type(t_obj)
      t_lst = _.map(t_obj, (v,k) -> [v,k])
      o_lst = _.map(obj, (v,k) -> [v,k])
      T.match(t_lst, o_lst)
    else if (TString.is_type(t_obj) or TNumber.is_type(t_obj) or TBool.is_type(t_obj))
      t_obj is obj
    else
      t_obj.is_type(obj)
  @or: (tobj) ->
    class extends @
      @is_type: (e) ->
        super(e) or tobj.is_type(e)
  @def: (type, method) ->
          (args...) ->
            if T.match type.in, args
              value = method.apply @, args
              if T.match type.out, value
                value
              else
                throw "invalid output type\n\tneed:#{T.show(type.out)}\n\treturned:#{T.show(value)}"
            else
              throw "invalid input type\n\tneed: #{T.show(type.in)}\n\tgiven: #{T.show(args)}"
  @is_type: (e) -> false
  @show: (obj) ->
    if TArray.is_type(obj)
      "[#{_.map(obj, (x) -> T.show(x)).join(",")}]"
    else if TObject.is_type(obj)
      "{#{_.map(obj, (v,k) -> T.show(k)+":"+T.show(v))}}"
    else if TString.is_type(obj)
      obj
    else if TNumber.is_type(obj) or TBool.is_type(obj)
      obj.toString()
    else
      obj.show()

class TString extends T
  @is_type: (e) ->
    typeof(e) is "string"
  @show: () -> "String"

class TAny extends T
  @is_type: (e) -> true
  @show: () -> "Any"

class TNumber extends T
  @is_type: (e) ->
    typeof(e) is "number"
  @show: () -> "Number"

class TBool extends T
  @is_type: (e) ->
    typeof(e) is "boolean"
  @show: () -> "Bool"

class TObject extends T
  @has: (sub) ->
    class extends TObject
      @is_type: (e) ->
        if super e
          _.every(sub, (v,k)-> T.match(v,e[k]))
        else
          false
      @show: () -> "Object.has(#{T.show(sub)})"
  @only: (sub) ->
    class extends TObject
      @is_type: (e) ->
        if super e
          [ks1, ks2] = [_.keys(sub),_.keys(e)]
          if ks1.length is ks2.length and _.all(_.zip(ks1,ks2), ([x,y]) -> x is y)
            _.every(sub, (v,k)-> T.match(v,e[k]))
          else
            false
        else
          false
      @show: () -> "Object.only(#{T.show(sub)})"
  @is_type: (e) ->
    if typeof(e) is "object"
      if e instanceof Array then false else true
  @show: () -> "Object"

class TArray extends T
  # Optionally define the type of element in an array
  # E.g., TArray.of(TNumber) which is like [Number] in Haskell
  @of: (sub) ->
    class extends TArray
      @is_type: (e) ->
        if super e
          _.every(e, (x)->T.match(sub,x))
        else
          false
      @show: () -> "Array.of(#{T.show(sub)})"
  @exactly: (sub) ->
    class extends TArray
      @is_type: (e) ->
        if super e
          _.every(_.zip(sub,e), ([x,y])->T.match(x,y))
        else
          false
      @show: () -> "Array.exactly(#{T.show(sub)})"
  @is_type: (e) ->
    if typeof(e) is "object"
      if e instanceof Array then true else false
  @show: () -> "Array"

module.exports =
  def: T.def
  match: T.match
  string: TString
  number: TNumber
  bool: TBool
  array: TArray
  any: TAny
  object: TObject
