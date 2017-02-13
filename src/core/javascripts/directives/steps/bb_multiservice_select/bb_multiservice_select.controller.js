angular.module('BB.Controllers').controller('MultiServiceSelect', function($scope, $rootScope, $q, $attrs, BBModel, $uibModal, $document, AlertService, FormDataStoreService, LoadingService) {

  FormDataStoreService.init('MultiServiceSelect', $scope, [
    'selected_category_name'
  ]);

  $scope.options                    = $scope.$eval($attrs.bbMultiServiceSelect) || {};
  $scope.options.max_services       = $scope.options.max_services || Infinity;
  $scope.options.ordered_categories = $scope.options.ordered_categories || false;
  $scope.options.services           = $scope.options.services || 'items';

  let loader = LoadingService.$loader($scope);

  $rootScope.connection_started.then(function() {
    if ($scope.bb.company.$has('parent') && !$scope.bb.company.$has('company_questions')) {
      $scope.bb.company.$getParent().then(function(parent) {
        $scope.company = parent;
        return initialise();
      });
    } else {
      $scope.company = $scope.bb.company;
    }

    // wait for services before we begin initialisation
    return $scope.$watch($scope.options.services, function(newval, oldval) {
      if (newval && angular.isArray(newval)) {
        $scope.items = newval;
        return initialise();
      }
    });
  });

  var initialise = function() {

    if (!$scope.items || !$scope.company) { return; }

    $scope.initialised = true;

    let promises = [];

    promises.push(BBModel.Category.$query($scope.bb.company));

    // company question promise
    if ($scope.company.$has('company_questions')) { promises.push($scope.company.$getCompanyQuestions()); }

    return $q.all(promises).then(function(result) {

      $scope.company_questions = result[1];

      initialiseCategories(result[0]);

      // if there's already some stacked items (i.e. we've come back to this page,
      // make sure they're selected)
      if ($scope.bb.stacked_items && ($scope.bb.stacked_items.length > 0)) {
        for (let stacked_item of Array.from($scope.bb.stacked_items)) {
          for (let item of Array.from($scope.items)) {
            if (item.self === stacked_item.service.self) {
              stacked_item.service = item;
              stacked_item.service.selected = true;
              break;
            }
          }
        }
      } else {
        // check item defaults
        checkItemDefaults();
      }

      // if we're moving the booking, just move to the next step
      if ($scope.bb.moving_booking) {
        $scope.nextStep();
      }


      $scope.$broadcast("multi_service_select:loaded");

      return loader.setLoaded();
    }

    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
  };

  /***
  * @ngdoc method
  * @name checkItemDefaults
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Check item defaults
  */
  var checkItemDefaults = function() {
    if (!$scope.bb.item_defaults.service) { return; }
    for (let service of Array.from($scope.items)) {
      if (service.self === $scope.bb.item_defaults.service.self) {
        $scope.addItem(service);
        return;
      }
    }
  };

  /***
  * @ngdoc method
  * @name initialiseCategories
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Initialize the categories in according of categories parameter
  *
  * @param {array} categories The categories of service
  */
  var initialiseCategories = function(categories) {

    // extract order from category name if we're using ordered categories
    let category;
    if ($scope.options.ordered_categories) {
      for (category of Array.from(categories)) {
        category.order = parseInt(category.name.slice(0,2));
        category.name  = category.name.slice(3);
      }
    }

    // index categories by their id
    $scope.all_categories = _.indexBy(categories, 'id');

    // group services by category id
    let all_categories = _.groupBy($scope.items, item => item.category_id);

    // find any sub categories
    let sub_categories = _.findWhere($scope.company_questions, {name: 'Extra Category'});
    if (sub_categories) { sub_categories = _.map(sub_categories.question_items, sub_category => sub_category.name); }

    // filter categories that have no services
    categories = {};
    for (let key of Object.keys(all_categories || {})) {
      let value = all_categories[key];
      if (value.length > 0) { categories[key] = value; }
    }

    // build the catagories array
    $scope.categories = [];

    return (() => {
      let result = [];
      for (let category_id in categories) {

        var category_details;
        let services = categories[category_id];
        let item;
        category = {};

        // group services by their subcategory
        let grouped_sub_categories = [];
        if (sub_categories) {
          for (var sub_category of Array.from(sub_categories)) {
            let grouped_sub_category = {
              name: sub_category,
              services: _.filter(services, service => service.extra.extra_category === sub_category)
            };

            // only add the sub category if it has some services
            if (grouped_sub_category.services.length > 0) { grouped_sub_categories.push(grouped_sub_category); }
          }
          category.sub_categories = grouped_sub_categories;
        } else {
          category.services = services;
        }

        // get the name and description
        if ($scope.all_categories[category_id]) { category_details = {name: $scope.all_categories[category_id].name, description: $scope.all_categories[category_id].description}; }

        // set the category
        category.name = category_details.name;
        category.description = category_details.description;

        // get the order if instruccted
        if ($scope.options.ordered_categories && $scope.all_categories[category_id]) { category.order = $scope.all_categories[category_id].order; }

        $scope.categories.push(category);

        // check it a category is already selected
        if ($scope.selected_category_name && ($scope.selected_category_name === category_details.name)) {
          item = $scope.selected_category = $scope.categories[$scope.categories.length - 1];
        // or if there's a default category
        } else if ($scope.bb.item_defaults.category && ($scope.bb.item_defaults.category.name === category_details.name) && !$scope.selected_category) {
          $scope.selected_category = $scope.categories[$scope.categories.length - 1];
          item = $scope.selected_category_name = $scope.selected_category.name;
        }
        result.push(item);
      }
      return result;
    })();
  };

  /***
  * @ngdoc method
  * @name changeCategory
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Change category in according of category name and services parameres
  *
  * @param {string} category_name The category name
  * @param {array} services The services array
  */
  $scope.changeCategory = function(category_name, services) {

    if (category_name && services) {
      $scope.selected_category = {
        name: category_name,
        sub_categories: services
      };
      $scope.selected_category_name = $scope.selected_category.name;
      return $rootScope.$broadcast("multi_service_select:category_changed");
    }
  };

  /***
  * @ngdoc method
  * @name changeCategoryName
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Change the category name
  */
  $scope.changeCategoryName = function() {
      $scope.selected_category_name = $scope.selected_category.name;
      return $rootScope.$broadcast("multi_service_select:category_changed");
    };

  /***
  * @ngdoc method
  * @name addItem
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Add item in according of item and duration parameters
  *
  * @param {array} item The item that been added
  * @param {date} duration The duration
  */
  $scope.addItem = function(item, duration) {
    if ($scope.bb.stacked_items.length < $scope.options.max_services) {
      $scope.bb.clearStackedItemsDateTime(); // clear any selected date/time as the selection has changed
      item.selected = true;
      let iitem = new BBModel.BasketItem(null, $scope.bb);
      iitem.setDefaults($scope.bb.item_defaults);
      iitem.setService(item);
      if (duration) { iitem.setDuration(duration); }
      iitem.setGroup(item.group);
      $scope.bb.stackItem(iitem);
      $rootScope.$broadcast("multi_service_select:item_added");
      if ($scope.options.raise_alerts) { return AlertService.info({msg: `${item.name} added to your treatment selection`, persist:false}); }
    } else {
      return Array.from($scope.items).map((i) =>
        (i.popover = `Sorry, you can only book a maximum of ${$scope.options.max_services} treatments`,
        i.popoverText = i.popover));
    }
  };

  /***
  * @ngdoc method
  * @name removeItem
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Remove item in according of item and options parameters
  *
  * @params {array} item The item that been removed
  * @params {array} options The options remove
  */
  $scope.removeItem = function(item, options) {
    item.selected = false;

    if (options && (options.type === 'BasketItem')) {
      $scope.bb.deleteStackedItem(item);
    } else {
      $scope.bb.deleteStackedItemByService(item);
    }

    $scope.bb.clearStackedItemsDateTime(); // clear any selected date/time as the selection has changed
    $rootScope.$broadcast("multi_service_select:item_removed");
    return (() => {
      let result = [];
      for (let i of Array.from($scope.items)) {
        let item1;
        if (i.self === item.self) {
          i.selected = false;
          break;
        }
        result.push(item1);
      }
      return result;
    })();
  };

  /***
  * @ngdoc method
  * @name removeStackedItem
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Removed stacked item whose type is 'BasketItem'
  *
  * @params {array} item The item that been removed
  */
  $scope.removeStackedItem = item => $scope.removeItem(item, {type: 'BasketItem'});

  /***
  * @ngdoc method
  * @name nextStep
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Next step to selected an basket item, if basket item is not selected she display an error message
  */
  $scope.nextStep = function() {
    if ($scope.bb.stacked_items.length > 1) {
      return $scope.decideNextPage();
    } else if ($scope.bb.stacked_items.length === 1) {
      // first clear anything already in the basket and then set the basket item
      if ($scope.bb.basket && ($scope.bb.basket.items.length > 0)) { $scope.quickEmptybasket({preserve_stacked_items: true}); }
      $scope.setBasketItem($scope.bb.stacked_items[0]);
      return $scope.decideNextPage();
    } else {
      AlertService.clear();
      return AlertService.add("danger", { msg: "You need to select at least one treatment to continue" });
    }
  };

  /***
  * @ngdoc method
  * @name addService
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Add service which add a new item
  */
  $scope.addService = () => $rootScope.$broadcast("multi_service_select:add_item");

  /***
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Set this page section as ready
  */
  $scope.setReady = function() {
    if ($scope.bb.stacked_items.length > 1) {
      return true;
    } else if ($scope.bb.stacked_items.length === 1) {
      // first clear anything already in the basket and then set the basket item
      if ($scope.bb.basket && ($scope.bb.basket.items.length > 0)) { $scope.quickEmptybasket({preserve_stacked_items: true}); }
      $scope.setBasketItem($scope.bb.stacked_items[0]);
      return true;
    } else {
      AlertService.clear();
      AlertService.add("danger", { msg: "You need to select at least one treatment to continue" });
      return false;
    }
  };

  /***
  * @ngdoc method
  * @name selectDuration
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Select duration in according of service parameter and display the modal
  *
  * @params {object} service The service
  */
  return $scope.selectDuration = function(service) {

    if (service.durations.length === 1) {
      return $scope.addItem(service);
    } else {

      let modalInstance = $uibModal.open({
        templateUrl: $scope.getPartial('_select_duration_modal'),
        scope: $scope,
        controller($scope, $uibModalInstance, service) {
          $scope.durations = service.durations;
          $scope.duration = $scope.durations[0];
          $scope.service = service;

          $scope.cancel = () => $uibModalInstance.dismiss('cancel');
          return $scope.setDuration = () => $uibModalInstance.close({service: $scope.service, duration: $scope.duration});
        },
        resolve: {
          service() {
            return service;
          }
        }
      });

      return modalInstance.result.then(result => $scope.addItem(result.service, result.duration));
    }
  };
});
