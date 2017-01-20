'use strict';
var BBCtrl;

BBCtrl = function (routeStates, $scope, $location, $rootScope, halClient, $window, $http, BasketService,
                   LoginService, AlertService, BBWidget,
                   SSOService, ErrorService, AppConfig, QueryStringService, $bbug, LoadingService,
                   viewportSize, widgetBasket, widgetPage, widgetStep, widgetInit,bbWidgetUtilities) {


    widgetBasket.setScope($scope);
    widgetPage.setScope($scope);
    widgetStep.setScope($scope);
    widgetInit.setScope($scope);
    bbWidgetUtilities.setScope($scope);

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

        $scope.setClient = widgetInit.setClient;
        $scope.clearClient = widgetInit.clearClient;
        $scope.setCompany = widgetInit.setCompany;
        $scope.setAffiliate = widgetInit.setAffiliate;
        $scope.setBasicRoute = $scope.bb.setBasicRoute;

        $scope.isAdmin =  bbWidgetUtilities.isAdmin;
        $scope.isAdminIFrame = bbWidgetUtilities.isAdminIFrame;
        $scope.base64encode = bbWidgetUtilities.base64encode;
        $scope.$debounce = bbWidgetUtilities.$debounce;
        $scope.parseDate = moment;
        $scope.supportsTouch = bbWidgetUtilities.supportsTouch;
        $scope.scrollTo = bbWidgetUtilities.scrollTo;
        $scope.redirectTo = bbWidgetUtilities.redirectTo;
        $scope.areScopesLoaded = LoadingService.areScopesLoaded;

        $scope.broadcastItemUpdate = bbWidgetUtilities.broadcastItemUpdate;
        $scope.getPartial = bbWidgetUtilities.getPartial;
        $scope.getUrlParam = bbWidgetUtilities.getUrlParam;
        $scope.setLoaded = LoadingService.setLoaded;
        $scope.setLoadedAndShowError = LoadingService.setLoadedAndShowError;
        $scope.isMemberLoggedIn = bbWidgetUtilities.isMemberLoggedIn;
        $scope.logout = bbWidgetUtilities.logout;
        $scope.notLoaded = LoadingService.notLoaded;
        $scope.reloadDashboard = bbWidgetUtilities.reloadDashboard;
        $scope.setReadyToCheckout = widgetBasket.setReadyToCheckout;
        $scope.setRoute = bbWidgetUtilities.setRoute;

        $scope.showCheckout = widgetBasket.showCheckout;
        $rootScope.$on('show:loader', bbWidgetUtilities.showLoaderHandler);
        $rootScope.$on('hide:loader', bbWidgetUtilities.hideLoaderHandler);
        $scope.$on('$locationChangeStart', bbWidgetUtilities.locationChangeStartHandler);
    };
    this.$postLink = function () {
        viewportSize.init();
    };


};

angular.module('BB.Controllers').controller('BBCtrl', BBCtrl);
