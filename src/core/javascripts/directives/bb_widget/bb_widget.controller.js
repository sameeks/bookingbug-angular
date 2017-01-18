'use strict';
var BBCtrl;

BBCtrl = function(routeStates, $scope, $location, $rootScope, halClient, $window, $http, $q, $timeout, BasketService, LoginService, AlertService, $sce, $element, $compile, $sniffer, $uibModal, $log, BBModel, BBWidget, SSOService, ErrorService, AppConfig, QueryStringService, QuestionService, PurchaseService, $sessionStorage, $bbug, AppService, UriTemplate, LoadingService, $anchorScroll, $localStorage, $document, CompanyStoreService, viewportSize,basketRelated) {
  'ngInject';

  basketRelated.setScope($scope);
  basketRelated.first('Hello');
  var $debounce,  base64encode, broadcastItemUpdate, checkStepTitle, clearClient, clearPage, companySet, connectionStarted, decideNextPage, determineBBApiUrl, getCurrentStepTitle, getPartial, getUrlParam, hideLoaderHandler, hidePage, initWidget, initWidget2, initializeBBWidget, isAdmin, isAdminIFrame, isFirstCall, isLoadingPage, isMemberLoggedIn, jumpToPage, loadPreviousStep, loadStep, loadStepByPageName, locationChangeStartHandler, logout, redirectTo, reloadDashboard, reset, restart, scrollTo, setActiveCompany, setAffiliate, setBasicRoute,setClient, setCompany, setLastSelectedDate, setLoadingPage, setPageLoaded, setPageRoute, setReadyToCheckout, setRoute, setStepTitle, setUsingBasket, setupDefaults, showCheckout, showLoaderHandler, showPage, skipThisStep, supportsTouch, widgetStarted;

  $scope.cid = "BBCtrl";
  $scope.controller = "public.controllers.BBCtrl";
  $scope.qs = QueryStringService;
  $scope.company_api_path = '/api/v1/company/{company_id}{?embed,category_id}';
  $scope.company_admin_api_path = '/api/v1/admin/{company_id}/company{?embed,category_id}';
  isFirstCall = true;
  connectionStarted = $q.defer();
  $rootScope.connection_started = connectionStarted.promise;
  widgetStarted = $q.defer();
  $rootScope.widget_started = widgetStarted.promise;
  $rootScope.Route = $scope.Route = routeStates;
  this.$onInit = function() {
    $scope.addItemToBasket = basketRelated.addItemToBasket;
    $scope.areScopesLoaded = LoadingService.areScopesLoaded;
    $scope.base64encode = base64encode;
    $scope.broadcastItemUpdate = broadcastItemUpdate;
    $scope.clearPage = clearPage;
    $scope.clearBasketItem = basketRelated.clearBasketItem;
    $scope.clearClient = clearClient;
    $scope.checkStepTitle = checkStepTitle;
    $scope.$debounce = $debounce;
    $scope.decideNextPage = decideNextPage;
    $scope.deleteBasketItem = basketRelated.deleteBasketItem;
    $scope.deleteBasketItems = basketRelated.deleteBasketItems;
    $scope.emptyBasket = basketRelated.emptyBasket;
    $scope.getCurrentStepTitle = getCurrentStepTitle;
    $scope.getPartial = getPartial;
    $scope.getUrlParam = getUrlParam;
    $scope.hidePage = hidePage;
    $scope.isAdmin = isAdmin;
    $scope.isAdminIFrame = isAdminIFrame;
    $scope.initWidget = initWidget;
    $scope.initWidget2 = initWidget2;
    $scope.isLoadingPage = isLoadingPage;
    $scope.isMemberLoggedIn = isMemberLoggedIn;
    $scope.jumpToPage = jumpToPage;
    $scope.loadPreviousStep = loadPreviousStep;
    $scope.loadStep = loadStep;
    $scope.loadStepByPageName = loadStepByPageName;
    $scope.logout = logout;
    $scope.moveToBasket = basketRelated.moveToBasket;
    $scope.notLoaded = LoadingService.notLoaded;
    $scope.parseDate = moment;
    $scope.quickEmptybasket = basketRelated.quickEmptybasket;
    $scope.redirectTo = redirectTo;
    $scope.reloadDashboard = reloadDashboard;
    $scope.reset = reset;
    $scope.restart = restart;
    $scope.scrollTo = scrollTo;
    $scope.setAffiliate = setAffiliate;
    $scope.setBasicRoute = setBasicRoute;
    $scope.setBasket = basketRelated.setBasket;
    $scope.setBasketItem = basketRelated.setBasketItem;
    $scope.setClient = setClient;
    $scope.setCompany = setCompany;
    $scope.setLastSelectedDate = setLastSelectedDate;
    $scope.setLoaded = LoadingService.setLoaded;
    $scope.setLoadedAndShowError = LoadingService.setLoadedAndShowError;
    $scope.setLoadingPage = setLoadingPage;
    $scope.setPageLoaded = setPageLoaded;
    $scope.setPageRoute = setPageRoute;
    $scope.setReadyToCheckout = setReadyToCheckout;
    $scope.setRoute = setRoute;
    $scope.setStepTitle = setStepTitle;
    $scope.setUsingBasket = setUsingBasket;
    $scope.skipThisStep = skipThisStep;
    $scope.showCheckout = showCheckout;
    $scope.supportsTouch = supportsTouch;
    $scope.showPage = showPage;
    $scope.updateBasket = basketRelated.updateBasket;
    initializeBBWidget();
    $rootScope.$on('show:loader', showLoaderHandler);
    $rootScope.$on('hide:loader', hideLoaderHandler);
    $scope.$on('$locationChangeStart', locationChangeStartHandler);
  };
  this.$postLink = function() {
    viewportSize.init();
  };
  initializeBBWidget = function() {
    $scope.bb = new BBWidget();
    AppConfig.uid = $scope.bb.uid;
    $scope.bb.stacked_items = [];
    $scope.bb.company_set = companySet;
    $scope.recordStep = $scope.bb.recordStep;
    determineBBApiUrl();
  };
  determineBBApiUrl = function() {
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
  showLoaderHandler = function() {
    $scope.loading = true;
  };
  hideLoaderHandler = function() {
    $scope.loading = false;
  };
  locationChangeStartHandler = function(angular_event, new_url, old_url) {
    var step_number;
    if (!$scope.bb.routeFormat) {
      return;
    }
    if (!$scope.bb.routing || AppService.isModalOpen()) {
      step_number = $scope.bb.matchURLToStep();
      if (step_number > $scope.bb.current_step) {
        loadStep(step_number);
      } else if (step_number < $scope.bb.current_step) {
        loadPreviousStep('locationChangeStart');
      }
    }
    $scope.bb.routing = false;
  };
  initWidget = (function(_this) {
    return function(prms) {
      var url;
      if (prms == null) {
        prms = {};
      }
      _this.$init_prms = prms;
      connectionStarted = $q.defer();
      $rootScope.connection_started = connectionStarted.promise;
      if ((($sniffer.webkit && $sniffer.webkit < 537) || ($sniffer.msie && $sniffer.msie <= 9)) && isFirstCall) {
        if ($scope.bb.api_url) {
          url = document.createElement('a');
          url.href = $scope.bb.api_url;
          if (url.host === '' || url.host === $location.host() || url.host === (($location.host()) + ":" + ($location.port()))) {
            initWidget2();
            return;
          }
        }
        if ($rootScope.iframe_proxy_ready) {
          initWidget2();
        } else {
          $scope.$on('iframe_proxy_ready', function(event, args) {
            if (args.iframe_proxy_ready) {
              return initWidget2();
            }
          });
        }
      } else {
        initWidget2();
      }
    };
  })(this);
  initWidget2 = (function(_this) {
    return function() {
      var aff_promise, comp_category_id, comp_def, comp_promise, comp_url, company_id, embed_params, get_total, k, match, options, params, prms, ref, setup_promises, setup_promises2, sso_admin_login, sso_member_login, total_id, v;
      $scope.init_widget_started = true;
      prms = _this.$init_prms;
      if (prms.query) {
        ref = prms.query;
        for (k in ref) {
          v = ref[k];
          prms[k] = QueryStringService(v);
        }
      }
      if (prms.custom_partial_url) {
        $scope.bb.custom_partial_url = prms.custom_partial_url;
        $scope.bb.partial_id = prms.custom_partial_url.substring(prms.custom_partial_url.lastIndexOf("/") + 1);
        if (prms.update_design) {
          $scope.bb.update_design = prms.update_design;
        }
      } else if (prms.design_mode) {
        $scope.bb.design_mode = prms.design_mode;
      }
      company_id = $scope.bb.company_id;
      if (prms.company_id) {
        company_id = prms.company_id;
      }
      if (prms.affiliate_id) {
        $scope.bb.affiliate_id = prms.affiliate_id;
        $rootScope.affiliate_id = prms.affiliate_id;
      }
      if (prms.api_url) {
        $scope.bb.api_url = prms.api_url;
      }
      if (prms.partial_url) {
        $scope.bb.partial_url = prms.partial_url;
      }
      if (prms.page_suffix) {
        $scope.bb.page_suffix = prms.page_suffix;
      }
      if (prms.admin) {
        $scope.bb.isAdmin = prms.admin;
      }
      if (prms.auth_token) {
        $sessionStorage.setItem("auth_token", prms.auth_token);
      }
      $scope.bb.app_id = 1;
      $scope.bb.app_key = 1;
      $scope.bb.clear_basket = true;
      if (prms.basket) {
        $scope.bb.clear_basket = false;
      }
      if (prms.clear_basket === false) {
        $scope.bb.clear_basket = false;
      }
      if ($window.bb_setup || prms.client) {
        prms.clear_member || (prms.clear_member = true);
      }
      $scope.bb.client_defaults = prms.client || {};
      if (prms.client_defaults) {
        if (prms.client_defaults.membership_ref) {
          $scope.bb.client_defaults.membership_ref = prms.client_defaults.membership_ref;
        }
      }
      if ($scope.bb.client_defaults && $scope.bb.client_defaults.name) {
        match = $scope.bb.client_defaults.name.match(/^(\S+)(?:\s(\S+))?/);
        if (match) {
          $scope.bb.client_defaults.first_name = match[1];
          if (match[2] != null) {
            $scope.bb.client_defaults.last_name = match[2];
          }
        }
      }
      if (prms.clear_member) {
        $scope.bb.clear_member = prms.clear_member;
        $sessionStorage.removeItem('login');
      }
      if (prms.app_id) {
        $scope.bb.app_id = prms.app_id;
      }
      if (prms.app_key) {
        $scope.bb.app_key = prms.app_key;
      }
      if (prms.on_conflict) {
        $scope.bb.on_conflict = prms.on_conflict;
      }
      if (prms.item_defaults) {
        $scope.bb.original_item_defaults = prms.item_defaults;
        $scope.bb.item_defaults = angular.copy($scope.bb.original_item_defaults);
      } else if ($scope.bb.original_item_defaults) {
        $scope.bb.item_defaults = angular.copy($scope.bb.original_item_defaults);
      }
      if ($scope.bb.selected_service && $scope.bb.selected_service.company_id === company_id) {
        $scope.bb.item_defaults.service = $scope.bb.selected_service.id;
      }
      if (prms.route_format) {
        $scope.bb.setRouteFormat(prms.route_format);
        if ($scope.bb_route_init) {
          $scope.bb_route_init();
        }
      }
      if (prms.hide === true) {
        $scope.hide_page = true;
      } else {
        $scope.hide_page = false;
      }
      if (prms.from_datetime) {
        $scope.bb.from_datetime = prms.from_datetime;
      }
      if (prms.to_datetime) {
        $scope.bb.to_datetime = prms.to_datetime;
      }
      if (prms.min_date) {
        $scope.bb.min_date = prms.min_date;
      }
      if (prms.max_date) {
        $scope.bb.max_date = prms.max_date;
      }
      if (prms.hide_block) {
        $scope.bb.hide_block = prms.hide_block;
      }
      if (!prms.custom_partial_url) {
        $scope.bb.path_setup = true;
      }
      if (prms.extra_setup) {
        $scope.bb.extra_setup = prms.extra_setup;
        if (prms.extra_setup.step) {
          $scope.bb.starting_step_number = parseInt(prms.extra_setup.step);
        }
        if (prms.extra_setup.return_url) {
          $scope.bb.return_url = prms.extra_setup.return_url;
        }
        if (prms.extra_setup.destination) {
          $scope.bb.destination = prms.extra_setup.destination;
        }
      }
      if (prms.booking_settings) {
        $scope.bb.booking_settings = prms.booking_settings;
      }
      if (prms.template) {
        $scope.bb.template = prms.template;
      }
      if (prms.login_required) {
        $scope.bb.login_required = true;
      }
      if (prms.private_note) {
        $scope.bb.private_note = prms.private_note;
      }
      if (prms.qudini_booking_id) {
        $scope.bb.qudini_booking_id = prms.qudini_booking_id;
      }
      _this.waiting_for_conn_started_def = $q.defer();
      $scope.waiting_for_conn_started = _this.waiting_for_conn_started_def.promise;
      if (company_id || $scope.bb.affiliate_id) {
        $scope.waiting_for_conn_started = $rootScope.connection_started;
      } else {
        _this.waiting_for_conn_started_def.resolve();
      }
      widgetStarted.resolve();
      setup_promises2 = [];
      setup_promises = [];
      if ($scope.bb.affiliate_id) {
        aff_promise = halClient.$get($scope.bb.api_url + '/api/v1/affiliates/' + $scope.bb.affiliate_id);
        setup_promises.push(aff_promise);
        aff_promise.then(function(affiliate) {
          var comp_p, comp_promise;
          if ($scope.bb.$wait_for_routing) {
            setup_promises2.push($scope.bb.$wait_for_routing.promise);
          }
          setAffiliate(new BBModel.Affiliate(affiliate));
          $scope.bb.item_defaults.affiliate = $scope.affiliate;
          if (prms.company_ref) {
            comp_p = $q.defer();
            comp_promise = $scope.affiliate.getCompanyByRef(prms.company_ref);
            setup_promises2.push(comp_p.promise);
            return comp_promise.then(function(company) {
              return setCompany(company, prms.keep_basket).then(function(val) {
                return comp_p.resolve(val);
              }, function(err) {
                return comp_p.reject(err);
              });
            }, function(err) {
              return comp_p.reject(err);
            });
          }
        });
      }
      if (company_id) {
        if (prms.embed) {
          embed_params = prms.embed;
        }
        embed_params || (embed_params = null);
        comp_category_id = null;
        if ($scope.bb.item_defaults.category != null) {
          if ($scope.bb.item_defaults.category.id != null) {
            comp_category_id = $scope.bb.item_defaults.category.id;
          } else {
            comp_category_id = $scope.bb.item_defaults.category;
          }
        }
        comp_def = $q.defer();
        comp_promise = comp_def.promise;
        options = {};
        if ($sessionStorage.getItem('auth_token')) {
          options.auth_token = $sessionStorage.getItem('auth_token');
        }
        if ($scope.bb.isAdmin) {
          comp_url = new UriTemplate($scope.bb.api_url + $scope.company_admin_api_path).fillFromObject({
            company_id: company_id,
            category_id: comp_category_id,
            embed: embed_params
          });
          halClient.$get(comp_url, options).then(function(company) {
            return comp_def.resolve(company);
          }, function(err) {
            comp_url = new UriTemplate($scope.bb.api_url + $scope.company_api_path).fillFromObject({
              company_id: company_id,
              category_id: comp_category_id,
              embed: embed_params
            });
            return halClient.$get(comp_url, options).then(function(company) {
              return comp_def.resolve(company);
            }, function(err) {
              return comp_def.reject(err);
            });
          });
        } else {
          comp_url = new UriTemplate($scope.bb.api_url + $scope.company_api_path).fillFromObject({
            company_id: company_id,
            category_id: comp_category_id,
            embed: embed_params
          });
          halClient.$get(comp_url, options).then(function(company) {
            if (company) {
              return comp_def.resolve(company);
            } else {
              return comp_def.reject("Invalid company ID " + company_id);
            }
          }, function(err) {
            return comp_def.reject(err);
          });
        }
        setup_promises.push(comp_promise);
        comp_promise.then(function(company) {
          var child, comp, cprom, parent_company;
          if ($scope.bb.$wait_for_routing) {
            setup_promises2.push($scope.bb.$wait_for_routing.promise);
          }
          comp = new BBModel.Company(company);
          cprom = $q.defer();
          setup_promises2.push(cprom.promise);
          child = null;
          if (comp.companies && $scope.bb.item_defaults.company) {
            child = comp.findChildCompany($scope.bb.item_defaults.company);
          }
          if (child) {
            parent_company = comp;
            return halClient.$get($scope.bb.api_url + '/api/v1/company/' + child.id).then(function(company) {
              comp = new BBModel.Company(company);
              setupDefaults(comp.id);
              $scope.bb.parent_company = parent_company;
              return setCompany(comp, prms.keep_basket).then(function() {
                return cprom.resolve();
              }, function(err) {
                return cprom.reject();
              });
            }, function(err) {
              return cprom.reject();
            });
          } else {
            setupDefaults(comp.id);
            return setCompany(comp, prms.keep_basket).then(function() {
              return cprom.resolve();
            }, function(err) {
              return cprom.reject();
            });
          }
        });
        if (prms.member_sso) {
          params = {
            company_id: company_id,
            root: $scope.bb.api_url,
            member_sso: prms.member_sso
          };
          sso_member_login = SSOService.memberLogin(params).then(function(client) {
            return setClient(client);
          });
          setup_promises.push(sso_member_login);
        }
        if (prms.admin_sso) {
          params = {
            company_id: prms.parent_company_id ? prms.parent_company_id : company_id,
            root: $scope.bb.api_url,
            admin_sso: prms.admin_sso
          };
          sso_admin_login = SSOService.adminLogin(params).then(function(admin) {
            return $scope.bb.admin = admin;
          });
          setup_promises.push(sso_admin_login);
        }
        if ($scope.bb.item_defaults && $scope.bb.item_defaults.purchase_total_long_id) {
          total_id = $scope.bb.item_defaults.purchase_total_long_id;
        } else {
          total_id = QueryStringService('total_id');
        }
        if (total_id) {
          params = {
            purchase_id: total_id,
            url_root: $scope.bb.api_url
          };
          get_total = PurchaseService.query(params).then(function(total) {
            $scope.bb.total = total;
            if (total.paid > 0) {
              return $scope.bb.payment_status = 'complete';
            }
          });
          setup_promises.push(get_total);
        }
      }
      $scope.isLoaded = false;
      return $q.all(setup_promises).then(function() {
        return $q.all(setup_promises2).then(function() {
          var base, clear_prom, def_clear;
          if (!$scope.bb.basket) {
            (base = $scope.bb).basket || (base.basket = new BBModel.Basket(null, $scope.bb));
          }
          if (!$scope.client) {
            clearClient();
          }
          def_clear = $q.defer();
          clear_prom = def_clear.promise;
          if (!$scope.bb.current_item) {
            clear_prom = basketRelated.clearBasketItem();
          } else {
            def_clear.resolve();
          }
          return clear_prom.then(function() {
            var page;
            if (!$scope.client_details) {
              $scope.client_details = new BBModel.ClientDetails();
            }
            if (!$scope.bb.stacked_items) {
              $scope.bb.stacked_items = [];
            }
            if ($scope.bb.company || $scope.bb.affiliate) {
              connectionStarted.resolve();
              $scope.done_starting = true;
              if (!prms.no_route) {
                page = null;
                if (isFirstCall && $bbug.isEmptyObject($scope.bb.routeSteps)) {
                  page = $scope.bb.firstStep;
                }
                if (prms.first_page) {
                  page = prms.first_page;
                }
                isFirstCall = false;
                return decideNextPage(page);
              }
            }
          });
        }, function(err) {
          connectionStarted.reject("Failed to start widget");
          return LoadingService.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
        });
      }, function(err) {
        connectionStarted.reject("Failed to start widget");
        return LoadingService.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
      });
    };
  })(this);
  setupDefaults = (function(_this) {
    return function(company_id) {
      var category, clinic, def, event, event_chain, event_group, k, person, ref, resource, service, v;
      def = $q.defer();
      if (isFirstCall || ($scope.bb.orginal_company_id && $scope.bb.orginal_company_id !== company_id)) {
        $scope.bb.orginal_company_id = company_id;
        $scope.bb.default_setup_promises = [];
        if ($scope.bb.item_defaults.query) {
          ref = $scope.bb.item_defaults.query;
          for (k in ref) {
            v = ref[k];
            $scope.bb.item_defaults[k] = QueryStringService(v);
          }
        }
        if ($scope.bb.item_defaults.resource) {
          if ($scope.bb.isAdmin) {
            resource = halClient.$get($scope.bb.api_url + '/api/v1/admin/' + company_id + '/resources/' + $scope.bb.item_defaults.resource);
          } else {
            resource = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/resources/' + $scope.bb.item_defaults.resource);
          }
          $scope.bb.default_setup_promises.push(resource);
          resource.then(function(res) {
            return $scope.bb.item_defaults.resource = new BBModel.Resource(res);
          });
        }
        if ($scope.bb.item_defaults.person) {
          if ($scope.bb.isAdmin) {
            person = halClient.$get($scope.bb.api_url + '/api/v1/admin/' + company_id + '/people/' + $scope.bb.item_defaults.person);
          } else {
            person = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/people/' + $scope.bb.item_defaults.person);
          }
          $scope.bb.default_setup_promises.push(person);
          person.then(function(res) {
            return $scope.bb.item_defaults.person = new BBModel.Person(res);
          });
        }
        if ($scope.bb.item_defaults.person_ref) {
          if ($scope.bb.isAdmin) {
            person = halClient.$get($scope.bb.api_url + '/api/v1/admin/' + company_id + '/people/find_by_ref/' + $scope.bb.item_defaults.person_ref);
          } else {
            person = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/people/find_by_ref/' + $scope.bb.item_defaults.person_ref);
          }
          $scope.bb.default_setup_promises.push(person);
          person.then(function(res) {
            return $scope.bb.item_defaults.person = new BBModel.Person(res);
          });
        }
        if ($scope.bb.item_defaults.service) {
          if ($scope.bb.isAdmin) {
            service = halClient.$get($scope.bb.api_url + '/api/v1/admin/' + company_id + '/services/' + $scope.bb.item_defaults.service);
          } else {
            service = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/services/' + $scope.bb.item_defaults.service);
          }
          $scope.bb.default_setup_promises.push(service);
          service.then(function(res) {
            return $scope.bb.item_defaults.service = new BBModel.Service(res);
          });
        }
        if ($scope.bb.item_defaults.service_ref) {
          if ($scope.bb.isAdmin) {
            service = halClient.$get($scope.bb.api_url + '/api/v1/admin/' + company_id + '/services?api_ref=' + $scope.bb.item_defaults.service_ref);
          } else {
            service = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/services?api_ref=' + $scope.bb.item_defaults.service_ref);
          }
          $scope.bb.default_setup_promises.push(service);
          service.then(function(res) {
            return $scope.bb.item_defaults.service = new BBModel.Service(res);
          });
        }
        if ($scope.bb.item_defaults.event_group) {
          if ($scope.bb.isAdmin) {
            event_group = halClient.$get($scope.bb.api_url + '/api/v1/admin/' + company_id + '/event_groups/' + $scope.bb.item_defaults.event_group);
          } else {
            event_group = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/event_groups/' + $scope.bb.item_defaults.event_group);
          }
          $scope.bb.default_setup_promises.push(event_group);
          event_group.then(function(res) {
            return $scope.bb.item_defaults.event_group = new BBModel.EventGroup(res);
          });
        }
        if ($scope.bb.item_defaults.event) {
          if ($scope.bb.isAdmin) {
            event = halClient.$get($scope.bb.api_url + '/api/v1/admin/' + company_id + '/event_chains/' + $scope.bb.item_defaults.event_chain + '/events/' + $scope.bb.item_defaults.event);
          } else {
            event = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/events/' + $scope.bb.item_defaults.event);
          }
          $scope.bb.default_setup_promises.push(event);
          event.then(function(res) {
            return $scope.bb.item_defaults.event = new BBModel.Event(res);
          });
        }
        if ($scope.bb.item_defaults.event_chain) {
          if ($scope.bb.isAdmin) {
            event_chain = halClient.$get($scope.bb.api_url + '/api/v1/admin/' + company_id + '/event_chains/' + $scope.bb.item_defaults.event_chain);
          } else {
            event_chain = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/event_chains/' + $scope.bb.item_defaults.event_chain);
          }
          $scope.bb.default_setup_promises.push(event_chain);
          event_chain.then(function(res) {
            return $scope.bb.item_defaults.event_chain = new BBModel.EventChain(res);
          });
        }
        if ($scope.bb.item_defaults.category) {
          category = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/categories/' + $scope.bb.item_defaults.category);
          $scope.bb.default_setup_promises.push(category);
          category.then(function(res) {
            return $scope.bb.item_defaults.category = new BBModel.Category(res);
          });
        }
        if ($scope.bb.item_defaults.clinic) {
          clinic = halClient.$get($scope.bb.api_url + '/api/v1/' + company_id + '/clinics/' + $scope.bb.item_defaults.clinic);
          $scope.bb.default_setup_promises.push(clinic);
          clinic.then(function(res) {
            return $scope.bb.item_defaults.clinic = new BBModel.Clinic(res);
          });
        }
        if ($scope.bb.item_defaults.duration) {
          $scope.bb.item_defaults.duration = parseInt($scope.bb.item_defaults.duration);
        }
        $q.all($scope.bb.default_setup_promises)['finally'](function() {
          return def.resolve();
        });
      } else {
        def.resolve();
      }
      return def.promise;
    };
  })(this);
  setLoadingPage = (function(_this) {
    return function(val) {
      return $scope.loading_page = val;
    };
  })(this);
  isLoadingPage = (function(_this) {
    return function() {
      return $scope.loading_page;
    };
  })(this);
  showPage = (function(_this) {
    return function(route, dont_record_page) {
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
    };
  })(this);
  jumpToPage = (function(_this) {
    return function(route) {
      $scope.current_page = route;
      $scope.jumped = true;
      return $scope.bb_main = $sce.trustAsResourceUrl($scope.partial_url + route + $scope.page_suffix);
    };
  })(this);
  clearPage = function() {
    return $scope.bb_main = "";
  };
  getPartial = function(file) {
    return $scope.bb.pageURL(file);
  };
  setPageLoaded = function() {
    return LoadingService.setLoaded($scope);
  };
  setPageRoute = (function(_this) {
    return function(route) {
      $scope.bb.current_page_route = route;
      if ($scope.bb.routeSteps && $scope.bb.routeSteps[route]) {
        showPage($scope.bb.routeSteps[route]);
        return true;
      }
      return false;
    };
  })(this);
  decideNextPage = function(route) {
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
  showCheckout = function() {
    return $scope.bb.current_item.ready;
  };

  setReadyToCheckout = function(ready) {
    return $scope.bb.confirmCheckout = ready;
  };



  logout = function(route) {
    if ($scope.client && $scope.client.valid()) {
      return LoginService.logout({
        root: $scope.bb.api_url
      }).then(function() {
        $scope.client = new BBModel.Client();
        return decideNextPage(route);
      });
    } else if ($scope.member) {
      return LoginService.logout({
        root: $scope.bb.api_url
      }).then(function() {
        $scope.member = new BBModel.Member.Member();
        return decideNextPage(route);
      });
    }
  };
  setAffiliate = function(affiliate) {
    $scope.bb.affiliate_id = affiliate.id;
    $scope.bb.affiliate = affiliate;
    $scope.affiliate = affiliate;
    return $scope.affiliate_id = affiliate.id;
  };

  setCompany = function(company, keep_basket) {
    var defer;
    defer = $q.defer();
    $scope.bb.company_id = company.id;
    $scope.bb.company = company;
    $scope.bb.item_defaults.company = $scope.bb.company;
    if (company.$has('settings')) {
      company.getSettings().then((function(_this) {
        return function(settings) {
          $scope.bb.company_settings = settings;
          setActiveCompany(company, settings);
          if ($scope.bb.company_settings.merge_resources) {
            $scope.bb.item_defaults.merge_resources = true;
          }
          if ($scope.bb.company_settings.merge_people) {
            $scope.bb.item_defaults.merge_people = true;
          }
          $rootScope.bb_currency = $scope.bb.company_settings.currency;
          $scope.bb.currency = $scope.bb.company_settings.currency;
          $scope.bb.has_prices = $scope.bb.company_settings.has_prices;
          if (!$scope.bb.basket || ($scope.bb.basket.company_id !== $scope.bb.company_id && !keep_basket)) {
            return basketRelated.restoreBasket().then(function() {
              defer.resolve();
              return $scope.$emit('company:setup');
            });
          } else {
            defer.resolve();
            return $scope.$emit('company:setup');
          }
        };
      })(this));
    } else {
      if (!$scope.bb.basket || ($scope.bb.basket.company_id !== $scope.bb.company_id && !keep_basket)) {
        basketRelated.restoreBasket().then(function() {
          defer.resolve();
          return $scope.$emit('company:setup');
        });
      } else {
        defer.resolve();
        $scope.$emit('company:setup');
      }
      setActiveCompany(company);
    }
    return defer.promise;
  };
  setActiveCompany = function(company, settings) {
    CompanyStoreService.currency_code = !settings ? company.currency_code : settings.currency;
    CompanyStoreService.time_zone = company.timezone;
    CompanyStoreService.country_code = company.country_code;
    return CompanyStoreService.settings = settings;
  };
  setStepTitle = function(title) {
    return $scope.bb.steps[$scope.bb.current_step - 1].title = title;
  };
  getCurrentStepTitle = function() {
    var steps;
    steps = $scope.bb.steps;
    if (!_.compact(steps).length || steps.length === 1 && steps[0].number !== $scope.bb.current_step) {
      steps = $scope.bb.allSteps;
    }
    if ($scope.bb.current_step) {
      return steps[$scope.bb.current_step - 1].title;
    }
  };
  checkStepTitle = function(title) {
    if ($scope.bb.steps[$scope.bb.current_step - 1] && !$scope.bb.steps[$scope.bb.current_step - 1].title) {
      return setStepTitle(title);
    }
  };
  loadStep = function(step) {
    var j, len, prev_step, ref, st;
    if (step === $scope.bb.current_step) {
      return;
    }
    $scope.bb.calculatePercentageComplete(step);
    st = $scope.bb.steps[step];
    prev_step = $scope.bb.steps[step - 1];
    if (st && !prev_step) {
      prev_step = st;
    }
    if (!st) {
      st = prev_step;
    }
    if (st && !$scope.bb.last_step_reached) {
      if (!st.stacked_length || st.stacked_length === 0) {
        $scope.bb.stacked_items = [];
      }
      $scope.bb.current_item.loadStep(st.current_item);
      if ($scope.bb.steps.length > 1) {
        $scope.bb.steps.splice(step, $scope.bb.steps.length - step);
      }
      $scope.bb.current_step = step;
      showPage(prev_step.page, true);
    }
    if ($scope.bb.allSteps) {
      ref = $scope.bb.allSteps;
      for (j = 0, len = ref.length; j < len; j++) {
        step = ref[j];
        step.active = false;
        step.passed = step.number < $scope.bb.current_step;
      }
      if ($scope.bb.allSteps[$scope.bb.current_step - 1]) {
        return $scope.bb.allSteps[$scope.bb.current_step - 1].active = true;
      }
    }
  };

  /***
  * @ngdoc method
  * @name loadPreviousStep
  * @methodOf BB.Directives:bbWidget
  * @description
  * Loads the previous unskipped step
  *
  * @param {integer} steps_to_go_back: The number of steps to go back
  * @param {string} caller: The method that called this function
   */
  loadPreviousStep = function(caller) {
    var last_step, pages_to_remove_from_history, past_steps, step_to_load;
    past_steps = _.reject($scope.bb.steps, function(s) {
      return s.number >= $scope.bb.current_step;
    });
    step_to_load = 0;
    while (past_steps[0]) {
      last_step = past_steps.pop();
      if (!last_step) {
        break;
      }
      if (!last_step.skipped) {
        step_to_load = last_step.number;
        break;
      }
    }
    if ($scope.bb.routeFormat) {
      pages_to_remove_from_history = step_to_load === 0 ? $scope.bb.current_step + 1 : $scope.bb.current_step - step_to_load;
      if (caller === "locationChangeStart") {
        pages_to_remove_from_history--;
      }
      if (pages_to_remove_from_history > 0) {
        window.history.go(pages_to_remove_from_history * -1);
      }
    }
    if (step_to_load > 0) {
      return loadStep(step_to_load);
    }
  };
  loadStepByPageName = function(page_name) {
    var j, len, ref, step;
    ref = $scope.bb.allSteps;
    for (j = 0, len = ref.length; j < len; j++) {
      step = ref[j];
      if (step.page === page_name) {
        return loadStep(step.number);
      }
    }
    return loadStep(1);
  };
  reset = function() {
    $rootScope.$broadcast('clear:formData');
    $rootScope.$broadcast('widget:restart');
    setLastSelectedDate(null);
    if (!LoginService.isLoggedIn()) {
      $scope.client = new BBModel.Client();
    }
    $scope.bb.last_step_reached = false;
    return $scope.bb.steps.splice(1);
  };
  restart = function() {
    reset();
    return loadStep(1);
  };
  setRoute = function(rdata) {
    return $scope.bb.setRoute(rdata);
  };
  setBasicRoute = function(routes) {
    return $scope.bb.setBasicRoute(routes);
  };

  /***
  * @ngdoc method
  * @name skipThisStep
  * @methodOf BB.Directives:bbWidget
  * @description
  * Marks the current step as skipped
   */
  skipThisStep = function() {
    if ($scope.bb.steps[$scope.bb.steps.length - 1]) {
      return $scope.bb.steps[$scope.bb.steps.length - 1].skipped = true;
    }
  };
  setUsingBasket = (function(_this) {
    return function(usingBasket) {
      return $scope.bb.usingBasket = usingBasket;
    };
  })(this);
  setClient = (function(_this) {
    return function(client) {
      $scope.client = client;
      if (client.postcode && !$scope.bb.postcode) {
        return $scope.bb.postcode = client.postcode;
      }
    };
  })(this);
  clearClient = (function(_this) {
    return function() {
      $scope.client = new BBModel.Client();
      if ($window.bb_setup) {
        $scope.client.setDefaults($window.bb_setup);
      }
      if ($scope.bb.client_defaults) {
        return $scope.client.setDefaults($scope.bb.client_defaults);
      }
    };
  })(this);
  getUrlParam = (function(_this) {
    return function(param) {
      return $window.getURIparam(param);
    };
  })(this);
  base64encode = (function(_this) {
    return function(param) {
      return $window.btoa(param);
    };
  })(this);
  setLastSelectedDate = (function(_this) {
    return function(date) {
      return $scope.last_selected_date = date;
    };
  })(this);
  broadcastItemUpdate = (function(_this) {
    return function() {
      return $scope.$broadcast("currentItemUpdate", $scope.bb.current_item);
    };
  })(this);
  hidePage = function() {
    return $scope.hide_page = true;
  };
  companySet = function() {
    return $scope.bb.company_id != null;
  };
  isAdmin = function() {
    return $scope.bb.isAdmin;
  };
  isAdminIFrame = function() {
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
  reloadDashboard = function() {
    return $window.parent.reload_dashboard();
  };
  $debounce = function(tim) {
    if ($scope._debouncing) {
      return false;
    }
    tim || (tim = 100);
    $scope._debouncing = true;
    return $timeout(function() {
      return $scope._debouncing = false;
    }, tim);
  };
  supportsTouch = function() {
    return Modernizr.touch;
  };
  isMemberLoggedIn = function() {
    return LoginService.isLoggedIn();
  };
  scrollTo = function(id) {
    $location.hash(id);
    return $anchorScroll();
  };
  redirectTo = function(url) {
    return $window.location.href = url;
  };
};

angular.module('BB.Controllers').controller('BBCtrl', BBCtrl);

// ---
// generated by coffee-script 1.9.2
