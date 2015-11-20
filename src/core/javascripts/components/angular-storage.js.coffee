# angular.module('ngStorage').factory "$fakeStorage", ($cookies) ->

#   #FakeStorage = undefined

#   FakeStorage = {}

#   FakeStorage::setItem = (key, value) ->
#     $cookies[key] = value

#   FakeStorage::getItem = (key) ->
#     if typeof $cookies[key] is "undefined"
#       null
#     else
#       $cookies[key]

#   FakeStorage::removeItem = (key) ->
#     $cookies[key] = undefined

#   FakeStorage::clear = ->
#     #key = undefined
#     for key of $cookies
#       if @hasOwnProperty(key)
#         @removeItem key
#         return

#   FakeStorage::key = (index) ->
#     Object.keys($cookies)[index]

#   return new FakeStorage



# angular.module('ngStorage').factory "$localStorage", ($window, $fakeStorage) ->

#   isStorageSupported = false
#   storage = (if isStorageSupported("localStorage") then $window.localStorage else $fakeStorage)

#   isStorageSupported = (storageName) ->
#     storage = undefined
#     error = undefined
#     testKey = undefined
#     testKey = "test"
#     storage = $window[storageName]
#     try
#       storage.setItem testKey, "1"
#       storage.removeItem testKey
#       return true
#     catch _error
#       error = _error
#       return false

#   setItem: (key, value) ->
#     storage.setItem key, value

#   getItem: (key, defaultValue) ->
#     storage.getItem(key) or defaultValue

#   setObject: (key, value) ->
#     storage.setItem key, JSON.stringify(value)

#   getObject: (key) ->
#     JSON.parse storage.getItem(key) or "{}"

#   removeItem: (key) ->
#     storage.removeItem key

#   clear: ->
#     storage.clear()

#   key: (index) ->
#     storage.key index



# angular.module('ngStorage').factory "$sessionStorage", ($window, $fakeStorage) ->

#   isStorageSupported = undefined
#   storage = undefined
#   storage = (if isStorageSupported("sessionStorage") then $window.sessionStorage else $fakeStorage)

#   isStorageSupported = (storageName) ->
#     storage = undefined
#     error = undefined
#     testKey = undefined
#     testKey = "test"
#     storage = $window[storageName]
#     try
#       storage.setItem testKey, "1"
#       storage.removeItem testKey
#       return true
#     catch _error
#       error = _error
#       return false

#   setItem: (key, value) ->
#     storage.setItem key, value

#   getItem: (key, defaultValue) ->
#     storage.getItem(key) or defaultValue

#   setObject: (key, value) ->
#     storage.setItem key, JSON.stringify(value)

#   getObject: (key) ->
#     JSON.parse storage.getItem(key) or "{}"

#   removeItem: (key) ->
#     storage.removeItem key

#   clear: ->
#     storage.clear()

#   key: (index) ->
#     storage.key index
