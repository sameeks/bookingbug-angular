ControllerConstructor = ()->
  ###jshint validthis: true ###
  vm = @
  vm.someTextValue = 'someTextValue'
  vm.someNumber = 7
  #$log.info 'some sample info'
  return

directive = () ->
  templateUrl = (tElem, tAttrs) ->
    defaultTemplateUrl = '/stylesheets/blog-article/display.html'
    if angular.isString tAttrs.templateUrl
      return tAttrs.templateUrl
    defaultTemplateUrl

  scope:
    someData: '='
  templateUrl: templateUrl
  controller: ControllerConstructor
  controllerAs: 'vm'
  bindToController: true


angular
.module('bbTe.blogArticle')
.directive('bbTeBlogArticleDisplay', directive)
