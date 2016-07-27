'use strict';

describe 'BB.Services, PathSvc service', () ->
  $sce = null
  AppConfig = null

  $http = null
  $httpBackend = null

  PathSvc = null

  appConfigMock = {
    partial_url: 'some-partial'
  }

  sampleFileName = 'some-filename'

  beforeEachFn = () ->
    module('BB')
    return

  beforeEach beforeEachFn

  injectDependencies = () ->
    inject ($injector) ->
      $sce = $injector.get '$sce'
      AppConfig = $injector.get 'AppConfig'
      $http = $injector.get '$http'
      $httpBackend = $injector.get '$httpBackend'
      PathSvc = $injector.get 'PathSvc'
      return

    spyOn($sce, 'trustAsResourceUrl').and.callThrough()

    return

  describe 'when "partial_url" is not defined in AppConfig', ()->
    beforeEach2LvlFn = ()->
      module ($provide) ->
        $provide.value 'AppConfig', {}
        return

      injectDependencies()

      return

    beforeEach beforeEach2LvlFn

    it 'proper url is used', () ->
      result = PathSvc.directivePartial sampleFileName

      expect $sce.trustAsResourceUrl
      .toHaveBeenCalledWith sampleFileName + '.html'

      expect result
      .toBeDefined()

      return
    return

  describe 'when "partial_url" is defined in AppConfig', ()->
    beforeEach2LvlFn = ()->
      module ($provide) ->
        $provide.value 'AppConfig', appConfigMock
        return

      injectDependencies()

      return

    beforeEach beforeEach2LvlFn

    it 'proper url is used', () ->
      result = PathSvc.directivePartial sampleFileName

      expect $sce.trustAsResourceUrl
      .toHaveBeenCalledWith appConfigMock['partial_url'] + '/' + sampleFileName + '.html'

      expect result
      .toBeDefined()

      return
    return

  return
