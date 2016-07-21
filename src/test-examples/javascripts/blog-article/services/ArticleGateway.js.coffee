service = (BbTeBlogArticleTextSanitizer, $http, $log, $q) ->
  'ngInject'

  endpoint = 'http://some.endpoint.com'

  getArticles = () ->
    defer = $q.defer()

    $http.get(endpoint + '/article')
    .then (response) ->
      getArticlesSuccessHandler(defer, response)
      return
    .catch (response) ->
      defer.reject('could not load articles')
      return

    return defer.promise

  getArticlesSuccessHandler = (defer, response) ->
    articles = response.data

    for article in articles
      do (article) ->
        sanitizeArticle article
        return
    defer.resolve articles
    return

  getArticle = (articleId) ->
    defer = $q.defer()

    $http.get(endpoint + '/article/' + articleId)
    .then (response) ->
      article = response.data
      sanitizeArticle article
      defer.resolve article
      return
    .catch (response) ->
      defer.reject('could not load article with id:' + articleId)
      return

    return defer.promise

  deleteArticle = (articleId) ->
    defer = $q.defer()

    $http.delete(endpoint + '/article/' + articleId)
    .then (response) ->
      if response.data is 'OK'
        defer.resolve true
      else
        deleteArticleErrorLog articleId, response.data
        defer.reject false
      return
    .catch (response) ->
      deleteArticleErrorLog articleId, response.data
      defer.reject false
      return

    return defer.promise

  deleteArticleErrorLog = (articleId, responseData) ->
    $log.error 'could not remove article with id:' + articleId, responseData
    return

  sanitizeArticle = (article) ->
    article.content = BbTeBlogArticleTextSanitizer.sanitize article.content
    return

  return {
    getArticles: getArticles
    getArticle: getArticle
    deleteArticle: deleteArticle
  }

angular
.module('bbTe.blogArticle')
.service('BbTeBlogArticleGateway', service)

