(function () {
    'use strict';

    angular.module('BB').controller('BBPageCtrl', BBPageCtrl);

    function BBPageCtrl($scope, $q, ValidatorService, LoadingService) {
        'ngInject';

        this.$scope = $scope;

        function init() {
            $scope.$has_page_control = true;

            console.warn('Deprecation warning: validator.validateForm() will be removed from bbPage in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638');
            $scope.validator = ValidatorService;

            $scope.checkReady = checkReady;
            $scope.routeReady = routeReady;
        }

        function isScopeReady(childScope) {
            var readyList = [],
                children = [],
                child = childScope.$$childHead;

            while (child) {
                children.push(child);
                child = child.$$nextSibling;
            }

            children.sort(sortChildrenScopes);

            for (var i = 0; i < children.length; i++) {
                areChildrenScopesReady(children[i], readyList);
            }

            if (childScope.hasOwnProperty('setReady')) {
                readyList.push(childScope.setReady());
            }

            return readyList;
        }

        function areChildrenScopesReady(child, readyList) {
            var ready = isScopeReady(child);
            if (angular.isArray(ready)) {
                Array.prototype.push.apply(readyList, ready);
            } else {
                readyList.push(ready);
            }
        }

        function sortChildrenScopes(a, b) {
            if ((a.ready_order || 0) >= (b.ready_order || 0)) {
                return 1;
            } else {
                return -1;
            }
        }

        /**
         * @ngdoc method
         * @name checkReady
         * @methodOf BB.Directives:bbPage
         * @description
         * Check the page ready
         */
        function checkReady() {

            var readyList = isScopeReady($scope);
            var checkReadyDefer = $q.defer();
            $scope.$checkingReady = checkReadyDefer.promise;

            readyList = readyList.filter(filterOutTrueValues);
            if (!readyList && readyList.length === 0) {
                checkReadyDefer.resolve(); //all readyList elements were 'true' values
                return true;
            }

            angular.forEach(readyList, function (readyValue) {
                if ((typeof readyValue === 'boolean') && !readyValue) {
                    checkReadyDefer.reject(); // at least one readyList element was 'false' value
                    return false;
                }
            });

            var loader = LoadingService.$loader($scope).notLoaded();
            $q.all(readyList).then(function () {
                loader.setLoaded();
                checkReadyDefer.resolve();

            }, function (err) {
                loader.setLoaded();
            });

            return true;
        }

        function filterOutTrueValues(v) {
            return !( (typeof v === 'boolean') && v );
        }

        /**
         * @ngdoc method
         * @name routeReady
         * @methodOf BB.Directives:bbPage
         * @description
         *
         * @param {string=} route A specific route to load
         */
        function routeReady(route) {
            if (!$scope.$checkingReady) {
                return $scope.decideNextPage(route);
            } else {
                return $scope.$checkingReady.then(function () {
                    return $scope.decideNextPage(route);
                });
            }
        }

        init();
    }

})();
