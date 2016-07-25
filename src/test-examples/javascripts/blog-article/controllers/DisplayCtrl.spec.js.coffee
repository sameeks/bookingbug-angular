'use strict';

describe 'bbTe.blogArticle, BbTeBaDisplayCtrl', () ->
  $controller = null
  $rootScope = null

  controllerInstance = null
  $scope = null

  setup = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      $controller = $injector.get '$controller'
      $rootScope = $injector.get '$rootScope'
      $scope = $rootScope.$new()
      return

    return

  beforeEach setup

  it 'initialise controller', () ->
    controllerInstance = $controller(
      'BbTeBaDisplayCtrl'
      '$scope': $scope
    )
    return


