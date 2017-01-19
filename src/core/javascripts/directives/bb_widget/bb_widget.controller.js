'use strict';
var BBCtrl;

BBCtrl = function (routeStates, $scope, $location, $rootScope, halClient, $window, $http, $q, $timeout, BasketService,
                   LoginService, AlertService, $sce, $element, $compile, $sniffer, $uibModal, $log, BBModel, BBWidget,
                   SSOService, ErrorService, AppConfig, QueryStringService, QuestionService, PurchaseService, $sessionStorage,
                   $bbug, AppService, UriTemplate, LoadingService, $anchorScroll, $localStorage, $document, CompanyStoreService,
                   viewportSize, widgetBasket, widgetPage, widgetStep, widgetInit,bb_widget_Utilities_Service) {
    'ngInject';

    widgetBasket.setScope($scope);
    widgetPage.setScope($scope);
    widgetStep.setScope($scope);
    widgetInit.setScope($scope);
    bb_widget_Utilities_Service.setScope($scope);

    this.$scope = $scope;
    $scope.cid = "BBCtrl";
    $scope.controller = "public.controllers.BBCtrl";
    $scope.qs = QueryStringService;

    $scope.company_api_path = '/api/v1/company/{company_id}{?embed,category_id}';
    $scope.company_admin_api_path = '/api/v1/admin/{company_id}/company{?embed,category_id}';
    $rootScope.Route = $scope.Route = routeStates;

    this.$onInit = function () {
        //Initialization
        widgetInit.initializeBBWidget();
        $scope.initWidget = widgetInit.initWidget;
        //Basket
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
        $scope.setUsingBasket = widgetBasket.setUsingBasket;
        //Pages
        $scope.clearPage = widgetPage.clearPage;
        $scope.decideNextPage = widgetPage.decideNextPage;
        $scope.hidePage = widgetPage.hidePage;
        $scope.isLoadingPage = widgetPage.isLoadingPage;
        $scope.jumpToPage = widgetPage.jumpToPage;
        $scope.setLoadingPage = widgetPage.setLoadingPage;
        $scope.setPageLoaded = widgetPage.setPageLoaded;
        $scope.setPageRoute = widgetPage.setPageRoute;
        $scope.showPage = widgetPage.showPage;
        //Steps
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

        $scope.setClient = widgetInit.setClient;
        $scope.clearClient = widgetInit.clearClient;
        $scope.setCompany = widgetInit.setCompany;
        $scope.setAffiliate = widgetInit.setAffiliate;
        $scope.setBasicRoute = $scope.bb.setBasicRoute;

        $scope.isAdmin =  bb_widget_Utilities_Service.isAdmin;
        $scope.isAdminIFrame = bb_widget_Utilities_Service.isAdminIFrame;
        $scope.base64encode = bb_widget_Utilities_Service.base64encode;
        $scope.$debounce = bb_widget_Utilities_Service.$debounce;
        $scope.parseDate = moment;
        $scope.supportsTouch = bb_widget_Utilities_Service.supportsTouch;
        $scope.scrollTo = bb_widget_Utilities_Service.scrollTo;
        $scope.redirectTo = bb_widget_Utilities_Service.redirectTo;
        $scope.areScopesLoaded = LoadingService.areScopesLoaded;
        $scope.broadcastItemUpdate = bb_widget_Utilities_Service.broadcastItemUpdate;
        $scope.getPartial = bb_widget_Utilities_Service.getPartial;
        $scope.getUrlParam = bb_widget_Utilities_Service.getUrlParam;
        $scope.setLoaded = LoadingService.setLoaded;
        $scope.setLoadedAndShowError = LoadingService.setLoadedAndShowError;
        $scope.isMemberLoggedIn = bb_widget_Utilities_Service.isMemberLoggedIn;
        $scope.logout = bb_widget_Utilities_Service.logout;
        $scope.notLoaded = LoadingService.notLoaded;
        $scope.reloadDashboard = bb_widget_Utilities_Service.reloadDashboard;
        $scope.setReadyToCheckout = widgetBasket.setReadyToCheckout;
        $scope.setRoute = bb_widget_Utilities_Service.setRoute;

        $scope.showCheckout = widgetBasket.showCheckout;
        $rootScope.$on('show:loader', bb_widget_Utilities_Service.showLoaderHandler);
        $rootScope.$on('hide:loader', bb_widget_Utilities_Service.hideLoaderHandler);
        $scope.$on('$locationChangeStart', bb_widget_Utilities_Service.locationChangeStartHandler);
    };
    this.$postLink = function () {
        viewportSize.init();
    };


};

angular.module('BB.Controllers').controller('BBCtrl', BBCtrl);
