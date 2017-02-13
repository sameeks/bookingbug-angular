let directive = function() {
  'ngInject';

  let templateUrl = function(tElem, tAttrs) {
    let defaultTemplateUrl = '/templates/blog-article/display.html';
    if (angular.isString(tAttrs.templateUrl)) {
      return tAttrs.templateUrl;
    }
    return defaultTemplateUrl;
  };

  return {
    restrict: 'EA',
    templateUrl
  };
};

angular
.module('bbTe.blogArticle')
.directive('bbTeBaCustomizableTemplate', directive);
