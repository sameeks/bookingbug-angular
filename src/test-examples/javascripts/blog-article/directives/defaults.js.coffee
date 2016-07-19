directive = () ->
  templateUrl: '/templates/blog-article/defaults.html'

angular
.module('bbTe.blogArticle')
.directive('bbTeBlogArticleDefaults', directive)
