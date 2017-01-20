(function () {

    'use strict';

    angular.module('BB.Controllers').controller('BBCtrl', BBCtrl);

    function BBCtrl(routeStates, $scope, $rootScope, QueryStringService, LoadingService, viewportSize, bbWidgetBasket,
                    bbWidgetPage, bbWidgetStep, bbWidgetInit, bbWidgetUtilities) {

        bbWidgetBasket.setScope($scope);
        bbWidgetPage.setScope($scope);
        bbWidgetStep.setScope($scope);
        bbWidgetInit.setScope($scope);
        bbWidgetUtilities.setScope($scope);

        this.$scope = $scope;

        $scope.cid = "BBCtrl";
        $scope.qs = QueryStringService;
        $scope.company_api_path = '/api/v1/company/{company_id}{?embed,category_id}';
        $scope.company_admin_api_path = '/api/v1/admin/{company_id}/company{?embed,category_id}';
        $rootScope.Route = $scope.Route = routeStates;

        this.$onInit = function () {
            //Initialization
            bbWidgetInit.initializeBBWidget();
            $scope.initWidget = bbWidgetInit.initWidget;
            //Steps
            $scope.checkStepTitle = bbWidgetStep.checkStepTitle;
            $scope.getCurrentStepTitle = bbWidgetStep.getCurrentStepTitle;
            $scope.loadPreviousStep = bbWidgetStep.loadPreviousStep;
            $scope.loadStep = bbWidgetStep.loadStep;
            $scope.loadStepByPageName = bbWidgetStep.loadStepByPageName;
            $scope.reset = bbWidgetStep.reset;
            $scope.restart = bbWidgetStep.restart;
            $scope.setLastSelectedDate = bbWidgetStep.setLastSelectedDate;
            $scope.setStepTitle = bbWidgetStep.setStepTitle;
            $scope.skipThisStep = bbWidgetStep.skipThisStep;
            //Pages
            $scope.clearPage = bbWidgetPage.clearPage;
            $scope.decideNextPage = bbWidgetPage.decideNextPage;
            $scope.hidePage = bbWidgetPage.hidePage;
            $scope.isLoadingPage = bbWidgetPage.isLoadingPage;
            $scope.jumpToPage = bbWidgetPage.jumpToPage;
            $scope.setLoadingPage = bbWidgetPage.setLoadingPage;
            $scope.setPageLoaded = bbWidgetPage.setPageLoaded;
            $scope.setPageRoute = bbWidgetPage.setPageRoute;
            $scope.showPage = bbWidgetPage.showPage;
            //Basket
            $scope.addItemToBasket = bbWidgetBasket.addItemToBasket;
            $scope.clearBasketItem = bbWidgetBasket.clearBasketItem;
            $scope.deleteBasketItem = bbWidgetBasket.deleteBasketItem;
            $scope.deleteBasketItems = bbWidgetBasket.deleteBasketItems;
            $scope.emptyBasket = bbWidgetBasket.emptyBasket;
            $scope.moveToBasket = bbWidgetBasket.moveToBasket;
            $scope.quickEmptybasket = bbWidgetBasket.quickEmptybasket;
            $scope.setBasket = bbWidgetBasket.setBasket;
            $scope.setBasketItem = bbWidgetBasket.setBasketItem;
            $scope.updateBasket = bbWidgetBasket.updateBasket;
            $scope.setUsingBasket = bbWidgetBasket.setUsingBasket;

            $scope.setClient = bbWidgetInit.setClient;
            $scope.clearClient = bbWidgetInit.clearClient;
            $scope.setCompany = bbWidgetInit.setCompany;
            $scope.setAffiliate = bbWidgetInit.setAffiliate;
            $scope.setBasicRoute = $scope.bb.setBasicRoute;

            $scope.isAdmin = bbWidgetUtilities.isAdmin;
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
            $scope.setReadyToCheckout = bbWidgetBasket.setReadyToCheckout;
            $scope.setRoute = bbWidgetUtilities.setRoute;

            $scope.showCheckout = bbWidgetBasket.showCheckout;
            $rootScope.$on('show:loader', bbWidgetUtilities.showLoaderHandler);
            $rootScope.$on('hide:loader', bbWidgetUtilities.hideLoaderHandler);
            $scope.$on('$locationChangeStart', bbWidgetUtilities.locationChangeStartHandler);
        };

        this.$postLink = function () {
            viewportSize.init();
        };
    }

})();
