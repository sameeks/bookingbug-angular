angular.module('BB.Controllers').controller('BasketList', function($scope, $rootScope,
  $element, $attrs, $q, AlertService, FormDataStoreService, LoginService,
  LoadingService, BBModel) {

  let params;
  $scope.setUsingBasket(true);
  let loader = LoadingService.$loader($scope);
  $scope.show_wallet = $scope.bb.company_settings.hasOwnProperty('has_wallets') && $scope.bb.company_settings.has_wallets && $scope.client.valid() && LoginService.isLoggedIn() && (LoginService.member().id === $scope.client.id) && $scope.client.has_active_wallet;

  // bb.basket.options - added 10-11-2015 @16:19
  // For ex. bb-basket-list="{requires_deal: true}"
  $scope.bb.basket.setSettings($scope.$eval($attrs.bbBasketList) || {});


  $rootScope.connection_started.then(function() {

    if ($scope.client) { $scope.bb.basket.setClient($scope.client); }
    if ($scope.client.$has('pre_paid_bookings') && ($scope.bb.basket.timeItems().length > 0)) {

      loader.notLoaded();
      let promises = [];

      for (var basket_item of Array.from($scope.bb.basket.timeItems())) {
        let params = {event_id: basket_item.getEventId()};
        promises.push($scope.client.$getPrePaidBookings(params));
      }

      return $q.all(promises).then(function(result) {
        let prepaid_booking;
        let booking_left = {};

        //populate the prepaid_booking available for all the bookings
        for (basket_item of Array.from(result)) {
          for (prepaid_booking of Array.from(basket_item)) {
            booking_left[prepaid_booking.id] = prepaid_booking.number_of_bookings_remaining;
          }
        }

        let iterable = $scope.bb.basket.timeItems();
        for (let index = 0; index < iterable.length; index++) {
          basket_item = iterable[index];
          let prepaid_bookings = result[index];
          if ($scope.bb.basket.settings && $scope.bb.basket.settings.auto_use_prepaid_bookings && (prepaid_bookings.length > 0) && (basket_item.price > 0)) {
            for (index = 0; index < prepaid_bookings.length; index++) {
              prepaid_booking = prepaid_bookings[index];
              if (booking_left[prepaid_booking.id] > 0) {
                basket_item.setPrepaidBooking(prepaid_booking);
                booking_left[prepaid_booking.id] -= 1;
                break;
              }
            }
          }
        }

        if ($scope.bb.basket.settings.auto_use_prepaid_bookings) {
          return $scope.updateBasket().then(() => groupBasketItems($scope.bb.basket.timeItems())
          , err => loader.setLoaded());
        } else {
          return groupBasketItems($scope.bb.basket.timeItems());
        }
      });

    } else {
      return groupBasketItems($scope.bb.basket.timeItems());
    }
  });



  $scope.deleteGroupItem = items => {
    $scope.deleteBasketItems(items);
    return $scope.multi_basket_grouping = _.without($scope.multi_basket_grouping, items);
  };

  $scope.editGroupItem = (items, route) => {
    $scope.bb.current_item = items[0];
    return $scope.decideNextPage(route);
  };


  $scope.groupPrice = function(items) {
    let group_price = 0;
    for (let item of Array.from(items)) { group_price += item.total_price; }
    return group_price;
  };


  $scope.groupTicketQty = function(items) {
    let group_ticket_qty = 0;
    for (let item of Array.from(items)) { group_ticket_qty += item.tickets.qty; }
    return group_ticket_qty;
  };


  var groupBasketItems = function(items) {
    // TODO only group events
    $scope.multi_basket_grouping = _.groupBy($scope.bb.basket.timeItems(), 'event_id');
    // (item) -> "#{item.event.date.unix()}_#{item.event_id}"
    $scope.multi_basket_grouping = _.values($scope.multi_basket_grouping);
    return loader.setLoaded();
  };

  let updateLocalBasket = function(basket) {
    for (let item of Array.from(basket.items)) {
      item.storeDefaults($scope.bb.item_defaults);
    }
    basket.setSettings($scope.bb.basket.settings);
    return $scope.setBasket(basket);
  };

  /***
  * @ngdoc method
  * @name addAnother
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Add another basket item in acording of route parameter
  *
  * @param {string} route A route of the added another item
  */
  // THIS IS FOR SORTING FOR MULTI EVENTS

  $scope.addAnother = route => {
    $scope.clearBasketItem();
    $scope.bb.emptyStackedItems();
//    $scope.bb.current_item.setCompany($scope.bb.company)
    return $scope.decideNextPage(route);
  };

  /***
  * @ngdoc method
  * @name checkout
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Reset the basket to the last item whereas the curren_item is not complete and should not be in the basket and that way, we can proceed to checkout instead of hard-coding it on the html page.
  *
  * @param {string} route A route of the added another item
  */
  $scope.checkout = route => {

    if ($scope.bb.basket.settings && $scope.bb.basket.settings.requires_deal && !$scope.bb.basket.hasDeal()) {
      AlertService.raise('GIFT_CERTIFICATE_REQUIRED');
      return false;
    }

    if ($scope.bb.basket.items.length > 0) {
      $scope.setReadyToCheckout(true);
      if ($scope.$parent.$has_page_control) {
        return true;
      } else {
        return $scope.decideNextPage(route);
      }
    } else {
      AlertService.raise('EMPTY_BASKET_FOR_CHECKOUT');
      return false;
    }
  };


  /***
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Set this page section as ready
  */
  $scope.setReady = () => $scope.checkout();

  /***
  * @ngdoc method
  * @name applyCoupon
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Apply the coupon of basket item in according of coupon parameter
  *
  * @param {string} coupon The applied coupon
  */
  $scope.applyCoupon = coupon => {
    AlertService.clear();
    loader.notLoaded();
    params = {bb: $scope.bb, coupon };

    // first update the basket item on the server
    return BBModel.Basket.$updateBasket($scope.bb.company, params.bb.basket).then(() =>
      BBModel.Basket.$applyCoupon($scope.bb.company, params).then(function(basket) {
        updateLocalBasket(basket);
        return loader.setLoaded();
      }
      , function(err) {
        if (err && err.data && err.data.error) {
          AlertService.clear();
          AlertService.raise('COUPON_APPLY_FAILED');
        }
        return loader.setLoaded();
      })
    );
  };

  /***
  * @ngdoc method
  * @name applyDeal
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Apply the coupon of basket item in according of deal code parameter
  *
  * @param {string} deal code The deal code
  */
  $scope.applyDeal = deal_code => {
    AlertService.clear();
    if ($scope.client) {
      params = {bb: $scope.bb, deal_code, member_id: $scope.client.id};
    } else {
      params = {bb: $scope.bb, deal_code, member_id: null};
    }

    // first update the basket item on the server
    return BBModel.Basket.$updateBasket($scope.bb.company, params.bb.basket).then(() =>
      BBModel.Basket.$applyDeal($scope.bb.company, params).then(function(basket) {
        updateLocalBasket(basket);
        $scope.items = $scope.bb.basket.items;
        return $scope.deal_code = null;
      }
      , function(err) {
        if (err && err.data && err.data.error) {
          AlertService.clear();
          return AlertService.raise('DEAL_APPLY_FAILED');
        }
      })
    );
  };

  /***
  * @ngdoc method
  * @name removeDeal
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Remove the deal in according of deal code parameter
  *
  * @param {string} deal code The deal code
  */
  $scope.removeDeal = deal_code => {
    params = {bb: $scope.bb, deal_code_id: deal_code.id };

    // first update the basket item on the server
    return BBModel.Basket.$updateBasket($scope.bb.company, params.bb.basket).then(() =>
      BBModel.Basket.$removeDeal($scope.bb.company, params).then(function(basket) {
        updateLocalBasket(basket);
        return $scope.items = $scope.bb.basket.items;
      }
      , function(err) {
        if (err && err.data && err.data.error) {
          AlertService.clear();
          return AlertService.raise('DEAL_REMOVE_FAILED');
        }
      })
    );
  };


  return $scope.topUpWallet = () => $scope.decideNextPage("basket_wallet");
});
