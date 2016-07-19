directive = () ->
  controller: 'BbTeBlogArticleControllerAsCtrl'
  controllerAs: 'vm'
  restrict: 'E'
  scope:
    someData: '='
  templateUrl: '/templates/blog-article/bindsToController.html'

angular
.module('bbTe.blogArticle')
.directive('bbTeBlogArticleControllerAs', directive)
