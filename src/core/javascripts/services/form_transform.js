angular.module('BB.Services').provider 'FormTransform', () ->

  options = {new: {}, edit: {}}

  @getTransform = (type, model) ->
    options[type][model]

  @setTransform = (type, model, fn) ->
    options[type][model] = fn

  @$get = ->
    options

  return

