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

    var $debounce, base64encode, broadcastItemUpdate, clearClient, companySet, connectionStarted, determineBBApiUrl,
        getPartial, getUrlParam, hideLoaderHandler, initWidget, initWidget2, initializeBBWidget, isAdmin, isAdminIFrame,
        isFirstCall, isMemberLoggedIn, locationChangeStartHandler, logout, redirectTo, reloadDashboard, scrollTo,
        setActiveCompany, setAffiliate, setBasicRoute, setClient, setCompany, setReadyToCheckout, setRoute,
        setUsingBasket, setupDefaults, showCheckout, showLoaderHandler, supportsTouch, widgetStarted;

    this.$scope = $scope;

    $scope.cid = "BBCtrl";
    $scope.controller = "public.controllers.BBCtrl";
    $scope.qs = QueryStringService;
    $scope.company_api_path = '/api/v1/company/{company_id}{?embed,category_id}';
    $scope.company_admin_api_path = '/api/v1/admin/{company_id}/company{?embed,category_id}';

    $rootScope.Route = $scope.Route = routeStates;

    this.$onInit = function () {
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


        $scope.setBasicRoute = setBasicRoute;
        $scope.isAdmin = isAdmin;
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
        $scope.setReadyToCheckout = setReadyToCheckout;
        $scope.setRoute = setRoute;
        $scope.setUsingBasket = setUsingBasket;
        $scope.showCheckout = showCheckout;


        initializeBBWidget();

        $rootScope.$on('show:loader', showLoaderHandler);
        $rootScope.$on('hide:loader', hideLoaderHandler);
        $scope.$on('$locationChangeStart', locationChangeStartHandler);
    };
    this.$postLink = function () {
        viewportSize.init();
    };

    initializeBBWidget = function () {
        $scope.bb = new BBWidget();
        AppConfig.uid = $scope.bb.uid;
        $scope.bb.stacked_items = [];
        $scope.bb.company_set = companySet;
        $scope.recordStep = $scope.bb.recordStep;
        determineBBApiUrl();
    };

    determineBBApiUrl = function () {
        var base, base1;
        if ($scope.apiUrl) {
            $scope.bb || ($scope.bb = {});
            $scope.bb.api_url = $scope.apiUrl;
        }
        if ($rootScope.bb && $rootScope.bb.api_url) {
            $scope.bb.api_url = $rootScope.bb.api_url;
            if (!$rootScope.bb.partial_url) {
                $scope.bb.partial_url = "";
            } else {
                $scope.bb.partial_url = $rootScope.bb.partial_url;
            }
        }
        if ($location.port() !== 80 && $location.port() !== 443) {
            (base = $scope.bb).api_url || (base.api_url = $location.protocol() + "://" + $location.host() + ":" + $location.port());
        } else {
            (base1 = $scope.bb).api_url || (base1.api_url = $location.protocol() + "://" + $location.host());
        }
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
    showCheckout = function () {
        return $scope.bb.current_item.ready;
    };
    setReadyToCheckout = function (ready) {
        return $scope.bb.confirmCheckout = ready;
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
    setBasicRoute = function (routes) {
        return $scope.bb.setBasicRoute(routes);
    };

    setUsingBasket = function (usingBasket) {
        return $scope.bb.usingBasket = usingBasket;
    }.bind(this);


    getUrlParam = function (param) {
        return $window.getURIparam(param);
    }.bind(this);

    base64encode = function (param) {
        return $window.btoa(param);
    }.bind(this);

    broadcastItemUpdate = function () {
        return $scope.$broadcast("currentItemUpdate", $scope.bb.current_item);
    }.bind(this);

    companySet = function () {
        return $scope.bb.company_id != null;
    };

    isAdmin = function () {
        return $scope.bb.isAdmin;
    };

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
