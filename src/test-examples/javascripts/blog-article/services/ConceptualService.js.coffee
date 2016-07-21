service = ($log) ->
  'ngInject'

  @sayHello = (name) ->
    return "Hi " + name + "!"

  return # it's important in this example to not return anything as a service function is in fact a constructor function

angular
.module('bbTe.blogArticle')
.service('BbTeBlogArticleConceptualService', service)
