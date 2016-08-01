controller = ($scope) ->
  'ngInject'

  ###jshint validthis: true ###
  vm = @

  init = () ->
    vm.someTextValue = 'random text'
    vm.someNumber = 7
    vm.someData = $scope.someData
    vm.prepareMessage = prepareMessage

    return

  prepareMessage = (msg) ->
    return trimMessage(msg) + '!'

  trimMessage = (msg) ->
    return msg.trim()

  init()

  return

angular
.module('bbTe.blogArticle')
.controller('BbTeBaControllerAsController', controller)
