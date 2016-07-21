directive = () ->
  'ngInject'

  link = (scope, element, attrs, ctrls) ->
    ###some dome manipulation###
    return

  controller: 'BbTeBlogArticleControllerAsCtrl'
  controllerAs: 'vm'
  link: link
  restrict: 'E'
  scope:
    someData: '='
  templateUrl: '/templates/blog-article/bindsToController.html'

angular
.module('bbTe.blogArticle')
.directive('bbTeBlogArticleControllerAs', directive)
