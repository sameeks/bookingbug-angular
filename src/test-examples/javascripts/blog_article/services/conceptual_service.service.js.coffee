service = ($log) ->
  'ngInject'

  @sayHello = (name) ->
    return "Hi " + name + "!"

  return # it's important in this example that this function doesn't return anything as in fact it's a constructor function

angular
.module('bbTe.blogArticle')
.service('bbTeBaConceptualService', service)
