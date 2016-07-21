directive = () ->
  'ngInject'

  templateUrl = (tElem, tAttrs) ->
    defaultTemplateUrl = '/templates/blog-article/display.html'
    if angular.isString tAttrs.templateUrl
      return tAttrs.templateUrl
    defaultTemplateUrl

  restrict: 'EA'
  templateUrl: templateUrl

angular
.module('bbTe.blogArticle')
.directive('bbTeBlogArticleCustomizableTemplate', directive)
