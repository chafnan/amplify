getType = (obj) ->
  if obj is undefined or not obj?
    return String obj
  classToType =
    '[object Boolean]': 'boolean'
    '[object Number]': 'number'
    '[object String]': 'string'
    '[object Function]': 'function'
    '[object Array]': 'array'
    '[object Date]': 'date'
    '[object RegExp]': 'regexp'
    '[object Object]': 'object'
  return classToType[Object.prototype.toString.call(obj)]

exports.getType = getType

isType = (obj, type) ->
  getType(obj) is type

exports.isType = isType

isEmptyObject = (obj) ->
  return false for name of obj
  return true

exports.isEmptyObject = isEmptyObject