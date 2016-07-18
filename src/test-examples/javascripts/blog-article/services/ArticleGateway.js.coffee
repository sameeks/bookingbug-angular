ServiceConstructor = () ->
  init = ()->
    return

  someMethod1 = () ->
    return

  someMethod2 = () ->
    return

  init()

  someMethod1: someMethod1
  someMethod2: someMethod2

angular
.module('bbTe.blogArticle')
.service('BbTeBlogArticleGateway', ServiceConstructor)
