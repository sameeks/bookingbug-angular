(function () {

    'use strict';

    angular.module('BB.Services').service('bbWidgetUtilities', BBWidgetUtilities);

    function BBWidgetUtilities($window, BBModel, bbWidgetPage, bbWidgetStep, AppService, $timeout, LoginService) {

        var $scope = null;
        var setScope = function ($s) {
            $scope = $s;
        };
        var guardScope = function () {
            if ($scope === null) {
                throw new Error('please provide scope');
            }
        };
        var isAdmin = function () {
            return $scope.bb.isAdmin;
        };
        var showLoaderHandler = function () {
            $scope.loading = true;
        };
        var hideLoaderHandler = function () {
            $scope.loading = false;
        };
        var locationChangeStartHandler = function (angular_event, new_url, old_url) {
            var step_number;
            if (!$scope.bb.routeFormat) {
                return;
            }
            if (!$scope.bb.routing || AppService.isModalOpen()) {
                step_number = $scope.bb.matchURLToStep();
                if (step_number > $scope.bb.current_step) {
                    bbWidgetStep.loadStep(step_number);
                } else if (step_number < $scope.bb.current_step) {
                    bbWidgetStep.loadPreviousStep('locationChangeStart');
                }
            }
            $scope.bb.routing = false;
        };
        var getPartial = function (file) {
            return $scope.bb.pageURL(file);
        };
        var logout = function (route) {
            if ($scope.client && $scope.client.valid()) {
                return LoginService.logout({
                    root: $scope.bb.api_url
                }).then(function () {
                    $scope.client = new BBModel.Client();
                    return bbWidgetPage.decideNextPage(route);
                });
            } else if ($scope.member) {
                return LoginService.logout({
                    root: $scope.bb.api_url
                }).then(function () {
                    $scope.member = new BBModel.Member.Member();
                    return bbWidgetPage.decideNextPage(route);
                });
            }
        };
        var setRoute = function (rdata) {
            return $scope.bb.setRoute(rdata);
        };
        var getUrlParam = function (param) {
            return $window.getURIparam(param);
        };
        var base64encode = function (param) {
            return $window.btoa(param);
        };
        var broadcastItemUpdate = function () {
            return $scope.$broadcast("currentItemUpdate", $scope.bb.current_item);
        };
        var isAdminIFrame = function () {
            var err, location;
            if (!$scope.bb.isAdmin) {
                return false;
            }
            try {
                location = $window.parent.location.href;
                if (location && $window.parent.reload_dashboard) {
                    return true;
                } else {
                    return false;
                }
            } catch (_error) {
                err = _error;
                return false;
            }
        };
        var reloadDashboard = function () {
            return $window.parent.reload_dashboard();
        };
        var $debounce = function (tim) {
            if ($scope._debouncing) {
                return false;
            }
            tim || (tim = 100);
            $scope._debouncing = true;
            return $timeout(function () {
                return $scope._debouncing = false;
            }, tim);
        };
        var supportsTouch = function () {
            return Modernizr.touch;
        };
        var isMemberLoggedIn = function () {
            return LoginService.isLoggedIn();
        };
        var scrollTo = function (id) {
            $location.hash(id);
            return $anchorScroll();
        };
        var redirectTo = function (url) {
            return $window.location.href = url;
        };

        return {
            setScope: setScope,
            isAdmin: isAdmin,
            showLoaderHandler: showLoaderHandler,
            hideLoaderHandler: hideLoaderHandler,
            locationChangeStartHandler: locationChangeStartHandler,
            getPartial: getPartial,
            logout: logout,
            setRoute: setRoute,
            getUrlParam: getUrlParam,
            base64encode: base64encode,
            broadcastItemUpdate: broadcastItemUpdate,
            isAdminIFrame: isAdminIFrame,
            reloadDashboard: reloadDashboard,
            $debounce: $debounce,
            supportsTouch: supportsTouch,
            isMemberLoggedIn: isMemberLoggedIn,
            scrollTo: scrollTo,
            redirectTo: redirectTo
        };
    }

})();
