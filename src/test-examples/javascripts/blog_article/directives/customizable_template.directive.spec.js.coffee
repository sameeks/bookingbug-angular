'use strict';

describe 'bbTe.blogArticle, bbTeBaCustomizableTemplate directive', () ->
  $compile = null
  $httpBackend = null
  $scope = null

  directive = null

  directiveDefaultTemplatePath = '/templates/blog-article/display.html';
  directiveDefaultHtml = '<bb-te-ba-customizable-template some-data="anyData"></bb-te-ba-customizable-template>'

  directiveCustomizedTemplatePath = '/templates/blog-article/display-customized.html';
  directiveCustomizedHtml = '<bb-te-ba-customizable-template template-url="' + directiveCustomizedTemplatePath + '"></bb-te-ba-customizable-template>'

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      $compile = $injector.get '$compile'
      $httpBackend = $injector.get '$httpBackend'
      $scope = $injector.get('$rootScope').$new()
      return

    $httpBackend.whenGET(directiveDefaultTemplatePath).respond(200, '<span>directive default content!</span>')
    $httpBackend.whenGET(directiveCustomizedTemplatePath).respond(200, '<span>directive customized content!</span>')

    return

  afterEachFn = () ->
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest()

  beforeEach beforeEachFn
  afterEach afterEachFn

  it 'use default template', () ->
    directive = $compile(directiveDefaultHtml)($scope);

    $httpBackend.flush()

    expect(directive.html()).toContain('directive default content!');
    return

  it 'use customized template', () ->
    directive = $compile(directiveCustomizedHtml)($scope);

    $httpBackend.flush()

    expect(directive.html()).toContain('directive customized content!');
    return

  return


