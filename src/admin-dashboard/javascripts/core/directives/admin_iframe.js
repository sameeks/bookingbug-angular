// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc directive
 * @name BBAdminDashboard.directive:adminIframe
 * @scope
 * @restrict A
 *
 * @description
 * Ensures iframe size is based on iframe content and that the iframe src is whitelisted
 *
 * @param {string}   path         A string that contains the iframe url
 * @param {string}   apiUrl       A string that contains the ApiUrl
 * @param {boolean}  fullHeight   A boolean that enables the iframe to take all available hight in the content area
 * @param {object}   extraParams  An object that contains extra params for the url (optional)
 * @param {function} onLoad       A callback function to be called after the iframed has finished loading (optional)
 */
angular.module('BBAdminDashboard').directive('adminIframe', ($window, $timeout) => {
        return {
            restrict: 'A',
            scope: {
                path: '=',
                apiUrl: '=',
                fullHeight: '=?',
                extraParams: '=?',
                onLoad: '=?'
            },
            templateUrl: 'core/admin-iframe.html',
            controller: ['$scope', '$sce', ($scope, $sce) => $scope.frameSrc = $sce.trustAsResourceUrl($scope.apiUrl + '/' + unescape($scope.path) + `?whitelabel=adminlte&uiversion=aphid&${$scope.extraParams ? $scope.extraParams : undefined}`)
            ],
            link(scope, element, attrs) {
                let calculateFullHeight = function (containerHeight) {

                    let heightToConsider = 0;
                    // Make sure we include the content container's padding in the calculation
                    let contentSection = angular.element(document.querySelectorAll('section.content'));
                    if (contentSection.length) {
                        contentSection = contentSection[0];
                        heightToConsider = heightToConsider + parseInt($window.getComputedStyle(contentSection, null).getPropertyValue('padding-top'));
                        heightToConsider = heightToConsider + parseInt($window.getComputedStyle(contentSection, null).getPropertyValue('padding-bottom'));
                    }

                    return (containerHeight - heightToConsider);
                };

                // Callback onload of the iframe
                element.find('iframe')[0].onload = function () {
                    scope.$emit('iframeLoaded', {});
                    if (typeof scope.onLoad === 'function') {
                        // moved this line from template to directive to work with IE & Firefox since onload was called before the iframe was entirely loaded.
                        this.style.display = 'block';
                        return scope.onLoad();
                    }
                };


                if (scope.fullHeight) {
                    // first load attempt
                    element.find('iframe').height(calculateFullHeight(angular.element(document.querySelector('#content-wrapper')).height()) + 'px');

                    // This will listen for resize events
                    scope.$on('content.changed', (event, data) => element.find('iframe').height(calculateFullHeight(data.height) + 'px'));

                } else {
                    $window.addEventListener('message', function (event) {
                        if (event.data.height) {
                            return element.find('iframe').height(event.data.height + 'px');
                        }
                    });
                }
            }
        };
    }
);
