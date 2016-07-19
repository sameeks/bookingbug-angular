ServiceConstructor = (BbTeBlogArticleTextSanitizer, $http, $q) ->

  endpoint = 'http://some.endpoint.com'

  getArticles = () ->
    return

  getArticle = (articleId) ->

    defer = $q.defer()

    $http.get(endpoint + '/article/' + articleId)
    .then (response) ->
      article = BbTeBlogArticleTextSanitizer.sanitize response.data
      defer.resolve article
    .catch (response) ->
      defer.reject('could not load article with id:' + articleId )

    return defer.promise

  updateArticle = (article) ->
    return

  deleteArticle = (articleId) ->
    return

  getArticles: getArticles
  getArticle: getArticle
  updateArticle: updateArticle
  deleteArticle: deleteArticle

angular
.module('bbTe.blogArticle')
.service('BbTeBlogArticleGateway', ServiceConstructor)
