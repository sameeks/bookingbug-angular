'use strict';
var WidgetPage;

WidgetPage = function(AlertService, BBModel, LoadingService, LoginService, $rootScope, $sce) {
  'ngInject';
  var $scope, clearPage, decideNextPage, guardScope, hidePage, isLoadingPage, jumpToPage, setLoadingPage, setPageLoaded, setPageRoute, setScope, showPage;
  $scope = null;
  setScope = function($s) {
    $scope = $s;
  };
  guardScope = function() {
    if ($scope === null) {
      throw new Error('please set scope');
    }
  };
  clearPage = function() {
    guardScope();
    return $scope.bb_main = "";
  };
  hidePage = function() {
    guardScope();
    return $scope.hide_page = true;
  };
  jumpToPage = function(route) {
      guardScope();
      $scope.current_page = route;
      $scope.jumped = true;
      return $scope.bb_main = $sce.trustAsResourceUrl($scope.partial_url + route + $scope.page_suffix);
  }
  setLoadingPage =  function(val) {
      guardScope();
      return $scope.loading_page = val;
  }
  isLoadingPage = function() {
      guardScope();
      return $scope.loading_page;
  }
  setPageRoute = function(route) {
      guardScope();
      $scope.bb.current_page_route = route;
      if ($scope.bb.routeSteps && $scope.bb.routeSteps[route]) {
        showPage($scope.bb.routeSteps[route]);
        return true;
      }
      return false;
  }
  showPage =  function(route, dont_record_page) {
      guardScope();
      $scope.bb.updateRoute(route);
      $scope.jumped = false;
      if (isLoadingPage()) {
        return;
      }
      setLoadingPage(true);
      if ($scope.bb.current_page === route) {
        $scope.bb_main = "";
        setTimeout(function() {
          $scope.bb_main = $sce.trustAsResourceUrl($scope.bb.pageURL(route));
          return $scope.$apply();
        }, 0);
      } else {
        AlertService.clear();
        $scope.bb.current_page = route;
        if (!dont_record_page) {
          $scope.bb.recordCurrentPage();
        }
        LoadingService.notLoaded($scope);
        $scope.bb_main = $sce.trustAsResourceUrl($scope.bb.pageURL(route));
      }
      return $rootScope.$broadcast("page:loaded");
  }
  setPageLoaded = function() {
    return LoadingService.setLoaded($scope);
  };
  decideNextPage = function(route) {
    guardScope();
    if (route) {
      if (route === 'none') {
        return;
      } else {
        if ($scope.bb.total && $scope.bb.payment_status === 'complete') {
          if (setPageRoute($rootScope.Route.Confirmation)) {
            return;
          }
          return showPage('confirmation');
        } else {
          return showPage(route);
        }
      }
    }
    if ($scope.bb.nextSteps && $scope.bb.current_page && $scope.bb.nextSteps[$scope.bb.current_page] && !$scope.bb.routeSteps) {
      return showPage($scope.bb.nextSteps[$scope.bb.current_page]);
    }
    if (!$scope.client.valid() && LoginService.isLoggedIn()) {
      $scope.client = new BBModel.Client(LoginService.member()._data);
    }
    if (($scope.bb.company && $scope.bb.company.companies) || (!$scope.bb.company && $scope.affiliate)) {
      if (setPageRoute($rootScope.Route.Company)) {
        return;
      }
      return showPage('company_list');
    } else if ($scope.bb.total && $scope.bb.payment_status === "complete") {
      if (setPageRoute($rootScope.Route.Confirmation)) {
        return;
      }
      return showPage('confirmation');
    } else if ($scope.bb.total && $scope.bb.payment_status === "pending") {
      return showPage('payment');
    } else if (($scope.bb.company.$has('event_groups') && !$scope.bb.current_item.event_group && !$scope.bb.current_item.service && !$scope.bb.current_item.product && !$scope.bb.current_item.deal) || ($scope.bb.company.$has('events') && $scope.bb.current_item.event_group && ($scope.bb.current_item.event == null) && !$scope.bb.current_item.product && !$scope.bb.current_item.deal)) {
      if (setPageRoute($rootScope.Route.Event)) {
        return;
      }
      return showPage('event_list');
    } else if ($scope.bb.company.$has('events') && $scope.bb.current_item.event && !$scope.bb.current_item.num_book && (!$scope.bb.current_item.tickets || !$scope.bb.current_item.tickets.qty) && !$scope.bb.current_item.product && !$scope.bb.current_item.deal) {
      return showPage('event');
    } else if ($scope.bb.company.$has('services') && !$scope.bb.current_item.service && ($scope.bb.current_item.event == null) && !$scope.bb.current_item.product && !$scope.bb.current_item.deal) {
      if (setPageRoute($rootScope.Route.Service)) {
        return;
      }
      return showPage('service_list');
    } else if ($scope.bb.company.$has('resources') && !$scope.bb.current_item.resource && ($scope.bb.current_item.event == null) && !$scope.bb.current_item.product && !$scope.bb.current_item.deal) {
      if (setPageRoute($rootScope.Route.Resource)) {
        return;
      }
      return showPage('resource_list');
    } else if ($scope.bb.company.$has('people') && !$scope.bb.current_item.person && ($scope.bb.current_item.event == null) && !$scope.bb.current_item.product && !$scope.bb.current_item.deal) {
      if (setPageRoute($rootScope.Route.Person)) {
        return;
      }
      return showPage('person_list');
    } else if (!$scope.bb.current_item.duration && ($scope.bb.current_item.event == null) && !$scope.bb.current_item.product && !$scope.bb.current_item.deal) {
      if (setPageRoute($rootScope.Route.Duration)) {
        return;
      }
      return showPage('duration_list');
    } else if ($scope.bb.current_item.days_link && !$scope.bb.current_item.date && ($scope.bb.current_item.event == null) && !$scope.bb.current_item.deal) {
      if ($scope.bb.company.$has('availability_slots')) {
        if (setPageRoute($rootScope.Route.Slot)) {
          return;
        }
        return showPage('slot_list');
      } else {
        if (setPageRoute($rootScope.Route.Date)) {
          return;
        }
        return showPage('calendar');
      }
    } else if ($scope.bb.current_item.days_link && !$scope.bb.current_item.time && ($scope.bb.current_item.event == null) && (!$scope.bb.current_item.service || $scope.bb.current_item.service.duration_unit !== 'day') && !$scope.bb.current_item.deal) {
      if (setPageRoute($rootScope.Route.Time)) {
        return;
      }
      return showPage('time');
    } else if ($scope.bb.moving_booking && (!$scope.bb.current_item.ready || !$scope.bb.current_item.move_done)) {
      return showPage('check_move');
    } else if (!$scope.client.valid()) {
      if (setPageRoute($rootScope.Route.Client)) {
        return;
      }
      return showPage('client');
    } else if ($scope.bb.current_item.item_details && $scope.bb.current_item.item_details.hasQuestions && !$scope.bb.current_item.asked_questions) {
      if (setPageRoute($rootScope.Route.Questions)) {
        return;
      }
      return showPage('check_items');
    } else if ($scope.bb.moving_booking && $scope.bb.basket.itemsReady()) {
      return showPage('purchase');
    } else if (!$scope.bb.basket.readyToCheckout()) {
      if (setPageRoute($rootScope.Route.Summary)) {
        return;
      }
      return showPage('basket_summary');
    } else if ($scope.bb.usingBasket && (!$scope.bb.confirmCheckout || $scope.bb.company_settings.has_vouchers || $scope.bb.company.$has('coupon'))) {
      if (setPageRoute($rootScope.Route.Basket)) {
        return;
      }
      return showPage('basket');
    } else if ($scope.bb.basket.readyToCheckout() && $scope.bb.payment_status === null && !$scope.bb.basket.waiting_for_checkout) {
      if (setPageRoute($rootScope.Route.Checkout)) {
        return;
      }
      return showPage('checkout');
    } else if ($scope.bb.payment_status === "complete") {
      if (setPageRoute($rootScope.Route.Confirmation)) {
        return;
      }
      return showPage('confirmation');
    }
  };
  return {
    clearPage: clearPage,
    decideNextPage: decideNextPage,
    hidePage: hidePage,
    isLoadingPage: isLoadingPage,
    jumpToPage: jumpToPage,
    setLoadingPage: setLoadingPage,
    setPageLoaded: setPageLoaded,
    setPageRoute: setPageRoute,
    setScope: setScope,
    showPage: showPage
  };
};

angular.module('BB').service('widgetPage', WidgetPage);
