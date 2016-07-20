'use strict';

describe 'bbTe.blogArticle, BbTeBlogArticleGateway service', () ->
  endpoint = 'http://some.endpoint.com'

  ArticleGateway = null
  TextSanitizer = null
  $http = null
  $httpBackend = null
  $log = null

  articleMock = {
    id: 1,
    title: 'some title',
    content: ' sOmE Sample content of Article  '
  }

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      ArticleGateway = $injector.get 'BbTeBlogArticleGateway'
      TextSanitizer = $injector.get 'BbTeBlogArticleTextSanitizer'
      $http = $injector.get '$http'
      $httpBackend = $injector.get '$httpBackend'
      $log = $injector.get '$log'
      return

    spyOn TextSanitizer, 'sanitize'
    .and.callThrough()

    return

  beforeEach beforeEachFn


  describe '"getArticles" method', ->
    getArticlesEndpoint = endpoint + '/article'

    articlesMock = [
      {content: '  somE Random Article'}
      {content: 'test'}
      {content: 'test'}
      {content: 'test'}
    ]

    beforeEachFnLvl2 = ->
      return

    beforeEach beforeEachFnLvl2

    it 'load articles & resolves promise', () ->
      $httpBackend.expectGET(getArticlesEndpoint).respond(200, articlesMock)

      articlesPromise = ArticleGateway.getArticles()
      testArticles = null

      articlesPromise
      .then (articles) ->
        testArticles = articles
        return

      $httpBackend.flush()

      expect testArticles.length
      .toBe 4

      expect TextSanitizer.sanitize
      .toHaveBeenCalledTimes 4

      return

    it 'reject promise if server error occurred', () ->
      $httpBackend.expectGET(getArticlesEndpoint).respond(500)
      articlesPromise = ArticleGateway.getArticles()

      rejectionMsg = null

      articlesPromise
      .catch (data) ->
        rejectionMsg = data

      $httpBackend.flush()

      expect rejectionMsg
      .toMatch /could not load articles/

      expect TextSanitizer.sanitize
      .not.toHaveBeenCalled

      return

    return

  describe '"getArticle" method', ->
    articleId = 1
    getArticleEndpoint = endpoint + '/article/' + articleId

    it 'load article and resolves promise', () ->
      $httpBackend.expectGET(getArticleEndpoint).respond(200, articleMock)

      expectedArticle = null
      ArticleGateway.getArticle(1)
      .then (response) ->
        expectedArticle = response

      $httpBackend.flush()

      expect typeof expectedArticle
      .toBe 'object'

      expect TextSanitizer.sanitize
      .toHaveBeenCalledTimes 1

      return

    it 'server fails and promise gets rejected', () ->
      $httpBackend.expectGET(getArticleEndpoint).respond(500)

      expectedMsg = null
      ArticleGateway.getArticle(1)
      .catch (msg) ->
        expectedMsg = msg

      $httpBackend.flush()

      expect expectedMsg
      .toMatch /could not load (.*) id:1/

      expect TextSanitizer.sanitize
      .not.toHaveBeenCalled()

      return
    return

  describe '"deleteArticle" method', ->
    articleId = 1
    getArticleEndpoint = endpoint + '/article/' + articleId

    beforeEachFnLvl2 = ->
      spyOn $log, 'error'

      return

    beforeEach beforeEachFnLvl2

    it 'delete article & resolves promise', () ->
      $httpBackend.expectDELETE(getArticleEndpoint).respond(200, 'OK')

      isDeleted = null
      ArticleGateway.deleteArticle(articleId)
      .then (response) ->
        isDeleted = response
      .catch (response) ->
        isDeleted = response

      $httpBackend.flush()

      expect isDeleted
      .toBe true

      expect $log.error
      .not.toHaveBeenCalled()

      return

    it 'does not delete article if 500 returend from server', () ->
      $httpBackend.expectDELETE(getArticleEndpoint).respond(500, 'some reason of failure')

      isDeleted = null
      promise = ArticleGateway.deleteArticle(articleId)

      promise
      .then (response) ->
        isDeleted = response
        return
      .catch (response) ->
        isDeleted = response
        return

      $httpBackend.flush()

      expect isDeleted
      .toBe false

      expect $log.error
      .toHaveBeenCalledWith jasmine.stringMatching(/could not/), jasmine.stringMatching(/reaso/)

      return


    it 'does not delete article if unexpected message returned', () ->
      $httpBackend.expectDELETE(getArticleEndpoint).respond(200, 'NOT OK')
      ArticleGateway.deleteArticle(articleId)
      $httpBackend.flush()

      expect $log.error
      .toHaveBeenCalledWith jasmine.stringMatching(/could not/), jasmine.stringMatching(/NOT/)

      return

    return

  return


