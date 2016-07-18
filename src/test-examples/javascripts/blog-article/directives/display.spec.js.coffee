'use strict';

describe 'bbTe.blogArticle, bbTeBlogArticleDisplay directive', () ->
  $compile = null
  $httpBackend = null
  $scope = null

  directiveDefaultTemplate = '/stylesheets/blog-article/display.html';
  directiveHtml = '<bb-te-blog-article-display some-data="testData"></bb-te-blog-article-display>'
  directive = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      $compile = $injector.get '$compile'
      $httpBackend = $injector.get '$httpBackend'
      $rootScope = $injector.get '$rootScope'
      $scope = $rootScope.$new()
      return

    $httpBackend.expectGET(directiveDefaultTemplate).respond(200)
    $scope.testData = {foo: 'bar'}

    return

  afterEachFn = () ->
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest()

  beforeEach beforeEachFn
  afterEach afterEachFn

  it 'binds required attribute to controller', () ->
    directive = $compile(directiveHtml)($scope)
    $httpBackend.flush()
    vm = directive.isolateScope().vm

    expect $scope.testData
    .toEqual vm.someData
    return

  return


