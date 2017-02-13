let directive = function() {
  'ngInject';

  return {templateUrl: '/templates/blog-article/defaults.html'};
};

angular
.module('bbTe.blogArticle')
.directive('bbTeBaDefaults', directive);
