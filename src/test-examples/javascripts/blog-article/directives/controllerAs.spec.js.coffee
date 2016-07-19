'use strict';

describe 'bbTe.blogArticle, bbTeBlogArticleControllerAs directive', () ->
  $compile = null
  $httpBackend = null
  $rootScope = null

  compiled = null

  directiveDefaultTemplatePath = '/templates/blog-article/bindsToController.html';
  directiveDefaultHtml = '<bb-te-blog-article-controller-as some-data="anyData"></bb-te-blog-article-controller-as>'

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      $compile = $injector.get '$compile'
      $httpBackend = $injector.get '$httpBackend'
      $rootScope = $injector.get '$rootScope'
      return

    $httpBackend.whenGET(directiveDefaultTemplatePath).respond(200, '<span>test</span>')

    return

  afterEachFn = () ->
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest()

  beforeEach beforeEachFn
  afterEach afterEachFn

  it 'expose "vm" object on isolated scope', () ->

    $rootScope.anyData = {foo: 'bar'}

    compiled = $compile(directiveDefaultHtml)($rootScope);
    $httpBackend.flush()
    isolatedScope = compiled.isolateScope()

    expect isolatedScope.vm.someTextValue
    .toBe 'random text'

    expect isolatedScope.vm.someNumber
    .toBe 7

    expect isolatedScope.vm.someData
    .toBe $rootScope.anyData

    expect isolatedScope.vm.prepareMessage ' test'
    .toBe 'test!'

    return

  return


