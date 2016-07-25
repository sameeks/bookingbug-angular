directive = () ->
  'ngInject'

  link = (scope, element, attrs, ctrls) ->
    ###some dome manipulation###
    return

  controller: 'BbTeBaControllerAsCtrl'
  controllerAs: 'vm'
  link: link
  restrict: 'E'
  scope:
    someData: '='
  templateUrl: '/templates/blog-article/bindsToController.html'

angular
.module('bbTe.blogArticle')
.directive('bbTeBaControllerAs', directive)
