// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
let directive = function () {
    'ngInject';

    let link = function (scope, element, attrs, ctrls) {
        /*some dome manipulation*/

    };

    return {
        controller: 'BbTeBaControllerAsController',
        controllerAs: 'vm',
        link,
        restrict: 'E',
        scope: {
            someData: '='
        },
        templateUrl: '/templates/blog-article/bindsToController.html'
    };
};

angular
    .module('bbTe.blogArticle')
    .directive('bbTeBaControllerAs', directive);
