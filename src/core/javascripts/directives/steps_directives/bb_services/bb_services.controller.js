var BBServicesCtrl;

BBServicesCtrl = function($scope, $rootScope, $q, $attrs, $uibModal, $document, $filter, BBModel, FormDataStoreService, PageControllerService, ErrorService, LoadingService) {
  'ngInject';

  var checkIfSelectedService, filterServices, filterServicesWithSelectedItem, getCompanyServices, init, initCompany, initFilters, initOptions, preselectService, readyServicesWithOptions, resourceIsSelected, setReady, setServiceItem, setServicesDisplayName, updateFilteredItems;
  this.$scope = $scope;
  FormDataStoreService.init('ServiceList', $scope, ['service']);

  $rootScope.connection_started.then((function(_this) {
    return function() {
      if ($scope.bb.company) {
        return initCompany($scope.bb.company);
      }
    };
  })(this), function(err) {
    return this.loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
  });

  init = function() {
    this.items = [];
    this.loader = LoadingService.$loader($scope).notLoaded();
    angular.extend(this, new PageControllerService($scope, $q, LoadingService));
    initOptions();
    initFilters();
  };

  initOptions = function() {
    return this.filters = {
      categoryName: null,
      serviceName: null,
      price: {
        min: 0,
        max: 100
      },
      customArrayValue: null
    };
  };

  initFilters = function() {
    var options;
    this.showCustomArray = false;
    options = $scope.$eval($attrs.bbServices) || {};
    if ($attrs.bbItem) {
      this.bookingItem = $scope.$eval($attrs.bbItem);
    }
    if ($attrs.bbShowAll || options.showAll) {
      this.showAll = true;
    }
    if (options.allow_single_pick) { 
      this.allowSinglePick = true;
    }
    if (options.hideDisabled) {
      this.hideDisabled = true;
    }
    return $scope.price_options = {
      min: 0, 
      max: 100
    }; 
  };

  initCompany = function(comp) {
    var promises, servicePromise;
    this.bookingItem || (this.bookingItem = $scope.bb.current_item);
    if ($scope.bb.company.$has('named_categories')) {
      BBModel.Category.$query($scope.bb.company).then((function(_this) {
        return function(items) {
          return $scope.all_categories = items;
        };
      })(this), function(err) {
        return $scope.all_categories = [];
      });
    } else {
      $scope.all_categories = [];
    }
    if ($scope.service && $scope.service.company_id !== $scope.bb.company.id) {
      $scope.service = null;
    }
    promises = [];
    servicePromise = comp.$getServices();
    promises.push(servicePromise);
    return getCompanyServices(servicePromise, promises);
  }.bind(this);

  getCompanyServices = function(servicePromise, promises) {
    servicePromise.then((function(items) {
      return readyServicesWithOptions(items);
    }), function(err) {
      return this.loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
    });
    if ((this.bookingItem.person && !this.bookingItem.anyPerson()) || (this.bookingItem.resource && !this.bookingItem.anyResource())) {
      filterServicesWithSelectedItem(servicePromise, promises);
    }
    return $q.all(promises).then(function() {
      return this.loader.setLoaded();
    });
  }.bind(this);

  readyServicesWithOptions = function(items) {
    var filterItems;
    if (this.hideDisabled) {
      items = items.filter(function(x) {
        return !x.disabled && !x.deleted;
      });
    }
    filterItems = $scope.filterServices === 'false' ? false : true;
    if (filterItems) {
      if (this.bookingItem.service_ref && !this.showAll) {
        items = items.filter(function(x) {
          return x.api_ref === this.bookingItem.service_ref;
        });
      } else if (this.bookingItem.category && !this.showAll) {
        items = items.filter(function(x) {
          return x.$has('category') && x.$href('category') === this.bookingItem.category.self;
        });
      }
    }
    if (!$scope.showEventGroups) {
      items = items.filter(function(x) {
        return !x.is_event_group;
      });
    }
    if (items.length === 1 && !this.allowSinglePick) {
      if (!$scope.selectItem(items[0], $scope.nextRoute, {
        skip_step: true
      })) {
        setServiceItem(items);
      }
    } else {
      setServiceItem(items);
    }
    return checkIfSelectedService(items);
  }.bind(this);

  checkIfSelectedService = function(items) {
    var item, j, len;
    if (this.bookingItem.defaultService()) {
      for (j = 0, len = items.length; j < len; j++) {
        item = items[j];
        if (item.self === this.bookingItem.defaultService().self || (item.name === this.bookingItem.defaultService().name && !item.deleted)) {
          $scope.selectItem(item, $scope.nextRoute, {
            skip_step: true
          });
        }
      }
    }
    if (this.bookingItem.service) {
      preselectService(this.bookingItem, items);
    }
    if (resourceIsSelected(this.bookingItem)) {
      items = setServicesDisplayName(items);
      $scope.bookable_services = items;
    }
  }.bind(this);

  preselectService = function(bookingItem, items) {
    var item, j, len, results;
    results = [];
    for (j = 0, len = items.length; j < len; j++) {
      item = items[j];
      item.selected = false;
      if (item.self === bookingItem.service.self) {
        $scope.service = item;
        item.selected = true;
        results.push(bookingItem.setService($scope.service));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  resourceIsSelected = function(bookingItem) {
    var selected;
    selected = false;
    if (bookingItem.service || !((bookingItem.person && !bookingItem.anyPerson()) || (bookingItem.resource && !bookingItem.anyResource()))) {
      selected = true;
    }
    return selected;
  };

  filterServicesWithSelectedItem = function(servicePromise, promises) {
    var ispromise;
    ispromise = BBModel.BookableItem.$query({
      company: $scope.bb.company,
      cItem: this.bookingItem,
      wait: servicePromise,
      item: 'service'
    });
    promises.push(ispromise);
    ispromise.then((function(_this) {
      return function(items) {
        var i, services;
        if (_this.bookingItem.service_ref) {
          items = items.filter(function(x) {
            return x.api_ref === this.bookingItem.service_ref;
          });
        }
        if (_this.bookingItem.group) {
          items = items.filter(function(x) {
            return !x.group_id || x.group_id === this.bookingItem.group;
          });
        }
        if (_this.hideDisabled) {
          items = items.filter(function(x) {
            return (x.item == null) || (!x.item.disabled && !x.item.deleted);
          });
        }
        services = (function() {
          var j, len, results;
          results = [];
          for (j = 0, len = items.length; j < len; j++) {
            i = items[j];
            if (i.item != null) {
              results.push(i.item);
            }
          }
          return results;
        })();
        services = setServicesDisplayName(services);
        $scope.bookable_services = services;
        $scope.bookable_items = items;
        if (services.length === 1 && !_this.allowSinglePick) {
          if (!$scope.selectItem(services[0], $scope.nextRoute, {
            skip_step: true
          })) {
            return setServiceItem(services);
          }
        } else {
          return setServiceItem(services);
        }
      };
    })(this), function(err) {
      return this.loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
    });
  };

  setServicesDisplayName = function(items) {
    var item, j, len;
    for (j = 0, len = items.length; j < len; j++) {
      item = items[j];
      if (item.listed_durations && item.listed_durations.length === 1) {
        item.display_name = item.name + ' - ' + $filter('time_period')(item.duration);
      } else {
        item.display_name = item.name;
      }
    }
    return items;
  };

  setServiceItem = function(items) {
    this.items = items;
    this.filtered_items = this.items;
    if ($scope.service) {
      _.each(items, function(item) {
        if (item.id === $scope.service.id) {
          return $scope.service = item;
        } 
      });
    }
  }.bind(this);

  /**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbServices
  * @description
  * Select an item into the current booking journey and route on to the next page dpending on the current page control
  *
  * @param {object} item The Service or BookableItem to select
  * @param {string=} route A specific route to load
   */
  this.selectItem = function(item, route, options) {
    if (options == null) {
      options = {};
    }
    if ($scope.routed) {
      return true;
    }
    if ($scope.$parent.$has_page_control) {
      $scope.service = item;
      return false;
    } else if (item.is_event_group) {
      this.bookingItem.setEventGroup(item);
      if (options.skip_step) {
        $scope.skipThisStep();
      }
      $scope.decideNextPage(route);
      $scope.routed = true;
    } else {
      this.bookingItem.setService(item);
      $scope.bb.selected_service = this.bookingItem.service;
      if (options.skip_step) {
        $scope.skipThisStep();
      }
      $scope.decideNextPage(route);
      $scope.routed = true;
      return true;
    };
  }.bind(this);

  $scope.$watch('service', function(newval, oldval) {
    if ($scope.service && this.bookingItem) {
      if (!this.bookingItem.service || this.bookingItem.service.self !== $scope.service.self) {
        this.bookingItem.setService($scope.service);
        $scope.broadcastItemUpdate();
        return $scope.bb.selected_service = $scope.service;
      }
    }
  }.bind(this));

  /**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbServices
  * @description
  * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
   */
  setReady = function() {
    if ($scope.service) {
      this.bookingItem.setService($scope.service);
      return true;
    } else if ($scope.bb.stacked_items && $scope.bb.stacked_items.length > 0) {
      return true;
    } else {
      return false;
    }
  }.bind(this);

  /**
  * @ngdoc method
  * @name errorModal
  * @methodOf BB.Directives:bbServices
  * @description
  * Display error message in modal
   */
  $scope.errorModal = function() {
    var error_modal;
    return error_modal = $uibModal.open({
      templateUrl: $scope.getPartial('_error_modal'),
      controller: function($scope, $uibModalInstance) {
        $scope.message = ErrorService.getError('GENERIC').msg;
        return $scope.ok = function() {
          return $uibModalInstance.close();
        };
      }
    });
  };

  /**
  * @ngdoc method
  * @name filterServices
  * @methodOf BB.Directives:bbServices
  * @description
  * Filter service
   */
  filterServices = function(service) {
    if (!service) {
      return false;
    }
    $scope.service_array = [];
    $scope.custom_array = function(match) {
      var item, j, len, ref;
      if (!match) {
        return false;
      }
      if ($scope.customFilter) {
        match = match.toLowerCase();
        ref = service.extra[$scope.customFilter];
        for (j = 0, len = ref.length; j < len; j++) {
          item = ref[j];
          item = item.toLowerCase();
          if (item === match) {
            this.showCustomArray = true;
            return true;
          }
        }
        return false;
      }
    };
    $scope.service_name_include = function(match) {
      var item;
      if (!match) {
        return false;
      }
      if (match) {
        match = match.toLowerCase();
        item = service.name.toLowerCase();
        if (item.includes(match)) {
          return true;
        } else {
          return false;
        }
      }
    };
    return (!this.filters.categoryName || service.category_id === this.filters.categoryName.id) && (!this.filters.serviceName || $scope.serviceName_include(this.filters.serviceName)) && (!this.filters.customArrayValue || $scope.custom_array(this.filters.customArrayValue)) && (!service.price || (service.price >= this.filters.price.min * 100 && service.price <= this.filters.price.max * 100));
  };

  /**
  * @ngdoc method
  * @nam@Filters
  * @methodOf BB.Directives:bbServices
  * @description
  * Clear filters
   */
  $scope.filters = function() {
    if ($scope.clearResults) {
      this.showCustomArray = false;
    }
    this.filters.categoryName = null;
    this.filters.serviceName = null;
    this.filters.price.min = 0;
    this.filters.price.max = 100;
    this.filters.customArrayValue = null;
    return updateFilteredItems();
  };

  /**
  * @ngdoc method
  * @name updateFilteredItems
  * @methodOf BB.Directives:bbServices
  * @description
  * Filter changed
   */
  updateFilteredItems = function() {
    this.filtered_items = $filter('filter')(this.items, filterServices);
  };
  init();
};

angular.module('BB.Controllers').controller('BBServicesCtrl', BBServicesCtrl);
