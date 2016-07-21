factory = ($log) ->
  'ngInject'

  init = () ->
    return

  sayHello = (name) ->
    return "Hi " + name + "!"

  init()

  return {
    sayHello: sayHello
  } # it's important to return an object

angular
.module('bbTe.blogArticle')
.factory('bbTeBlogArticleConceptualFactory', factory)
