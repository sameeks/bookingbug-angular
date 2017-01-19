'use strict';
var BBCtrl;

BBCtrl = function (routeStates, $scope, $location, $rootScope, halClient, $window, $http, $q, $timeout, BasketService,
                   LoginService, AlertService, $sce, $element, $compile, $sniffer, $uibModal, $log, BBModel, BBWidget,
                   SSOService, ErrorService, AppConfig, QueryStringService, QuestionService, PurchaseService, $sessionStorage,
                   $bbug, AppService, UriTemplate, LoadingService, $anchorScroll, $localStorage, $document, CompanyStoreService,
                   viewportSize, widgetBasket, widgetPage, widgetStep, widgetInit) {
    'ngInject';

    widgetBasket.setScope($scope);
    widgetPage.setScope($scope);
    widgetStep.setScope($scope);
    widgetInit.setScope($scope);

    var $debounce, base64encode, broadcastItemUpdate, getPartial, getUrlParam, hideLoaderHandler,
        isAdminIFrame, isMemberLoggedIn, locationChangeStartHandler, logout, redirectTo, reloadDashboard, scrollTo,
        setRoute, showLoaderHandler, supportsTouch;

    this.$scope = $scope;
    $scope.cid = "BBCtrl";
    $scope.controller = "public.controllers.BBCtrl";
    $scope.qs = QueryStringService;
    $scope.company_api_path = '/api/v1/company/{company_id}{?embed,category_id}';
    $scope.company_admin_api_path = '/api/v1/admin/{company_id}/company{?embed,category_id}';
    $rootScope.Route = $scope.Route = routeStates;

    this.$onInit = function () {
        widgetInit.initializeBBWidget();
        $scope.addItemToBasket = widgetBasket.addItemToBasket;
        $scope.clearBasketItem = widgetBasket.clearBasketItem;
        $scope.deleteBasketItem = widgetBasket.deleteBasketItem;
        $scope.deleteBasketItems = widgetBasket.deleteBasketItems;
        $scope.emptyBasket = widgetBasket.emptyBasket;
        $scope.moveToBasket = widgetBasket.moveToBasket;
        $scope.quickEmptybasket = widgetBasket.quickEmptybasket;
        $scope.setBasket = widgetBasket.setBasket;
        $scope.setBasketItem = widgetBasket.setBasketItem;
        $scope.updateBasket = widgetBasket.updateBasket;
        $scope.clearPage = widgetPage.clearPage;
        $scope.decideNextPage = widgetPage.decideNextPage;
        $scope.hidePage = widgetPage.hidePage;
        $scope.isLoadingPage = widgetPage.isLoadingPage;
        $scope.jumpToPage = widgetPage.jumpToPage;
        $scope.setLoadingPage = widgetPage.setLoadingPage;
        $scope.setPageLoaded = widgetPage.setPageLoaded;
        $scope.setPageRoute = widgetPage.setPageRoute;
        $scope.showPage = widgetPage.showPage;
        $scope.checkStepTitle = widgetStep.checkStepTitle;
        $scope.getCurrentStepTitle = widgetStep.getCurrentStepTitle;
        $scope.loadPreviousStep = widgetStep.loadPreviousStep;
        $scope.loadStep = widgetStep.loadStep;
        $scope.loadStepByPageName = widgetStep.loadStepByPageName;
        $scope.reset = widgetStep.reset;
        $scope.restart = widgetStep.restart;
        $scope.setLastSelectedDate = widgetStep.setLastSelectedDate;
        $scope.setStepTitle = widgetStep.setStepTitle;
        $scope.skipThisStep = widgetStep.skipThisStep;
        $scope.initWidget = widgetInit.initWidget;
        $scope.setClient = widgetInit.setClient;
        $scope.clearClient = widgetInit.clearClient;
        $scope.setCompany = widgetInit.setCompany;
        $scope.setAffiliate = widgetInit.setAffiliate;
        $scope.setBasicRoute = $scope.bb.setBasicRoute;
        $scope.isAdmin =  isAdmin;
        $scope.isAdminIFrame = isAdminIFrame;
        $scope.base64encode = base64encode;
        $scope.$debounce = $debounce;
        $scope.parseDate = moment;
        $scope.supportsTouch = supportsTouch;
        $scope.scrollTo = scrollTo;
        $scope.redirectTo = redirectTo;
        $scope.areScopesLoaded = LoadingService.areScopesLoaded;
        $scope.broadcastItemUpdate = broadcastItemUpdate;
        $scope.getPartial = getPartial;
        $scope.getUrlParam = getUrlParam;
        $scope.setLoaded = LoadingService.setLoaded;
        $scope.setLoadedAndShowError = LoadingService.setLoadedAndShowError;
        $scope.isMemberLoggedIn = isMemberLoggedIn;
        $scope.logout = logout;
        $scope.notLoaded = LoadingService.notLoaded;
        $scope.reloadDashboard = reloadDashboard;
        $scope.setReadyToCheckout = widgetBasket.setReadyToCheckout;
        $scope.setRoute = setRoute;
        $scope.setUsingBasket = widgetBasket.setUsingBasket;
        $scope.showCheckout = widgetBasket.showCheckout;
        $rootScope.$on('show:loader', showLoaderHandler);
        $rootScope.$on('hide:loader', hideLoaderHandler);
        $scope.$on('$locationChangeStart', locationChangeStartHandler);
    };
    this.$postLink = function () {
        viewportSize.init();
    };

    isAdmin = function(){
      return $scope.bb.isAdmin;
    };
    showLoaderHandler = function () {
        $scope.loading = true;
    };
    hideLoaderHandler = function () {
        $scope.loading = false;
    };
    locationChangeStartHandler = function (angular_event, new_url, old_url) {
        var step_number;
        if (!$scope.bb.routeFormat) {
            return;
        }
        if (!$scope.bb.routing || AppService.isModalOpen()) {
            step_number = $scope.bb.matchURLToStep();
            if (step_number > $scope.bb.current_step) {
                widgetStep.loadStep(step_number);
            } else if (step_number < $scope.bb.current_step) {
                widgetStep.loadPreviousStep('locationChangeStart');
            }
        }
        $scope.bb.routing = false;
    };
    getPartial = function (file) {
        return $scope.bb.pageURL(file);
    };
    logout = function (route) {
        if ($scope.client && $scope.client.valid()) {
            return LoginService.logout({
                root: $scope.bb.api_url
            }).then(function () {
                $scope.client = new BBModel.Client();
                return widgetPage.decideNextPage(route);
            });
        } else if ($scope.member) {
            return LoginService.logout({
                root: $scope.bb.api_url
            }).then(function () {
                $scope.member = new BBModel.Member.Member();
                return widgetPage.decideNextPage(route);
            });
        }
    };
    setRoute = function (rdata) {
        return $scope.bb.setRoute(rdata);
    };
    getUrlParam = function (param) {
        return $window.getURIparam(param);
    }
    base64encode = function (param) {
        return $window.btoa(param);
    }
    broadcastItemUpdate = function () {
        return $scope.$broadcast("currentItemUpdate", $scope.bb.current_item);
    }
    isAdminIFrame = function () {
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
    reloadDashboard = function () {
        return $window.parent.reload_dashboard();
    };
    $debounce = function (tim) {
        if ($scope._debouncing) {
            return false;
        }
        tim || (tim = 100);
        $scope._debouncing = true;
        return $timeout(function () {
            return $scope._debouncing = false;
        }, tim);
    };
    supportsTouch = function () {
        return Modernizr.touch;
    };
    isMemberLoggedIn = function () {
        return LoginService.isLoggedIn();
    };
    scrollTo = function (id) {
        $location.hash(id);
        return $anchorScroll();
    };
    redirectTo = function (url) {
        return $window.location.href = url;
    };
};

angular.module('BB.Controllers').controller('BBCtrl', BBCtrl);
