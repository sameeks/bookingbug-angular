'use strict';

angular.module('BB.Models').service("BBWidget", function($q, BBModel, BasketService, $urlMatcherFactory, $location,
                                                         BreadcrumbService, $window, $rootScope, PathHelper, GeneralOptions)
  {


    function Widget() {
      this.uid = _.uniqueId('bbwidget_');
      this.page_suffix = "";
      this.steps = [];
      this.allSteps = [];
      this.item_defaults = {};
      this.usingBasket = false;
      this.confirmCheckout = false;
      this.isAdmin = false;
      this.payment_status = null;
    }

    Widget.prototype.pageURL = function(route) {
      return route + '.html';
    };
    Widget.prototype.updateRoute = function(page) {
      var company, date, event, event_group, pattern, prms, service_name, time, url;
      if (!this.routeFormat) {
        return;
      }
      page || (page = this.current_page);
      pattern = $urlMatcherFactory.compile(this.routeFormat);
      service_name = "-";
      event_group = "-";
      event = "-";
      if (this.current_item) {
        if (this.current_item.service) {
          service_name = this.convertToDashSnakeCase(this.current_item.service.name);
        }
        if (this.current_item.event_group) {
          event_group = this.convertToDashSnakeCase(this.current_item.event_group.name);
        }
        if (this.current_item.event) {
          event = this.current_item.event.id;
        }
        if (this.current_item.date) {
          date = this.current_item.date.date;
        }
        if (date && moment.isMoment(date)) {
          date = date.toISODate();
        }
        if (this.current_item.time) {
          time = this.current_item.time.time;
        }
        if (this.current_item.company) {
          company = this.convertToDashSnakeCase(this.current_item.company.name);
        } else {
          console.log('%c bb_warning: Make sure you are using a valid company_id', 'background: #c0392b; color: #fff');
        }
      }
      if (this.route_values) {
        prms = angular.copy(this.route_values);
      }
      prms || (prms = {});
      angular.extend(prms, {
        page: page,
        company: company,
        service: service_name,
        event_group: event_group,
        date: date,
        time: time,
        event: event
      });
      url = pattern.format(prms);
      url = url.replace(/\/+$/, "");
      $location.path(url);
      this.routing = true;
      return url;
    };
    Widget.prototype.setRouteFormat = function(route) {
      var match;
      this.routeFormat = route;
      if (!this.routeFormat) {
        return;
      }
      this.routing = true;
      match = PathHelper.matchRouteToPath(this.routeFormat);
      if (match) {
        if (match.company) {
          this.item_defaults.company = decodeURIComponent(match.company);
        }
        if (match.service && match.service !== "-") {
          this.item_defaults.service = decodeURIComponent(match.service);
        }
        if (match.event_group && match.event_group !== "-") {
          this.item_defaults.event_group = match.event_group;
        }
        if (match.event && match.event !== "-") {
          this.item_defaults.event = decodeURIComponent(match.event);
        }
        if (match.person) {
          this.item_defaults.person = decodeURIComponent(match.person);
        }
        if (match.resource) {
          this.item_defaults.resource = decodeURIComponent(match.resource);
        }
        if (match.resources) {
          this.item_defaults.resources = decodeURIComponent(match.resoures);
        }
        if (match.date) {
          this.item_defaults.date = match.date;
        }
        if (match.time) {
          this.item_defaults.time = parseInt(match.time);
        }
        return this.route_matches = match;
      }
    };
    Widget.prototype.matchURLToStep = function() {
      var page, step;
      page = PathHelper.matchRouteToPath(this.routeFormat, 'page');
      step = _.findWhere(this.allSteps, {
        page: page
      });
      if (step) {
        return step.number;
      } else {
        return null;
      }
    };
    Widget.prototype.convertToDashSnakeCase = function(str) {
      str = str.toLowerCase();
      str = $.trim(str);
      str = str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '');
      str = str.replace(/\s{2,}/g, ' ');
      str = str.replace(/\s/g, '-');
      return str;
    };
    Widget.prototype.recordCurrentPage = function() {
      var j, k, l, len, len1, len2, match, ref, ref1, ref2, setDocumentTitle, step, title;
      setDocumentTitle = function(title) {
        if (GeneralOptions.update_document_title && title) {
          return document.title = title;
        }
      };
      if (!this.current_step) {
        this.current_step = 0;
      }
      match = false;
      if (this.allSteps) {
        ref = this.allSteps;
        for (j = 0, len = ref.length; j < len; j++) {
          step = ref[j];
          if (step.page === this.current_page) {
            this.current_step = step.number;
            setDocumentTitle(step.title);
            match = true;
          }
        }
      }
      if (!match) {
        ref1 = this.steps;
        for (k = 0, len1 = ref1.length; k < len1; k++) {
          step = ref1[k];
          if (step && step.page === this.current_page) {
            this.current_step = step.number;
            setDocumentTitle(step.title);
            match = true;
          }
        }
      }
      if (!match) {
        this.current_step += 1;
      }
      title = "";
      if (this.allSteps) {
        ref2 = this.allSteps;
        for (l = 0, len2 = ref2.length; l < len2; l++) {
          step = ref2[l];
          step.active = false;
          step.passed = step.number < this.current_step;
        }
        if (this.allSteps[this.current_step - 1]) {
          this.allSteps[this.current_step - 1].active = true;
          title = this.allSteps[this.current_step - 1].title;
        }
      }
      return this.recordStep(this.current_step, title);
    };
    Widget.prototype.recordStep = function(step_number, title) {
      var j, len, ref, step;
      this.steps[step_number - 1] = {
        url: this.updateRoute(this.current_page),
        current_item: this.current_item.getStep(),
        page: this.current_page,
        number: step_number,
        title: title,
        stacked_length: this.stacked_items.length
      };
      BreadcrumbService.setCurrentStep(step_number);
      ref = this.steps;
      for (j = 0, len = ref.length; j < len; j++) {
        step = ref[j];
        if (step) {
          step.passed = step.number < this.current_step;
          step.active = step.number === this.current_step;
        }
        if (step && step.number === step_number) {
          this.calculatePercentageComplete(step.number);
        }
      }
      if ((this.allSteps && this.allSteps.length === step_number) || this.current_page === 'checkout') {
        return this.last_step_reached = true;
      } else {
        return this.last_step_reached = false;
      }
    };
    Widget.prototype.calculatePercentageComplete = function(step_number) {
      return this.percentage_complete = step_number && this.allSteps ? step_number / this.allSteps.length * 100 : 0;
    };
    Widget.prototype.setRoute = function(rdata) {
      var i, j, k, len, len1, ref, route, step;
      this.allSteps.length = 0;
      this.nextSteps = {};
      if (!(rdata === void 0 || rdata === null || rdata[0] === void 0)) {
        this.firstStep = rdata[0].page;
      }
      for (i = j = 0, len = rdata.length; j < len; i = ++j) {
        step = rdata[i];
        if (step.disable_breadcrumbs) {
          this.disableGoingBackAtStep = i + 1;
        }
        if (rdata[i + 1]) {
          this.nextSteps[step.page] = rdata[i + 1].page;
        }
        this.allSteps.push({
          number: i + 1,
          title: step.title,
          page: step.page
        });
        if (step.when) {
          this.routeSteps || (this.routeSteps = {});
          ref = step.when;
          for (k = 0, len1 = ref.length; k < len1; k++) {
            route = ref[k];
            this.routeSteps[route] = step.page;
          }
        }
      }
      if (this.$wait_for_routing) {
        return this.$wait_for_routing.resolve();
      }
    };
    Widget.prototype.setBasicRoute = function(routes) {
      var i, j, len, step;
      this.nextSteps = {};
      this.firstStep = routes[0];
      for (i = j = 0, len = routes.length; j < len; i = ++j) {
        step = routes[i];
        this.nextSteps[step] = routes[i + 1];
      }
      if (this.$wait_for_routing) {
        return this.$wait_for_routing.resolve();
      }
    };
    Widget.prototype.waitForRoutes = function() {
      if (!this.$wait_for_routing) {
        return this.$wait_for_routing = $q.defer();
      }
    };
    Widget.prototype.stackItem = function(item) {
      this.stacked_items.push(item);
      this.sortStackedItems();
      if (this.stacked_items.length === 1) {
        return this.current_item = item;
      }
    };
    Widget.prototype.setStackedItems = function(items) {
      this.stacked_items = items;
      return this.sortStackedItems();
    };
    Widget.prototype.sortStackedItems = function() {
      var arr, item, j, len, ref;
      arr = [];
      ref = this.stacked_items;
      for (j = 0, len = ref.length; j < len; j++) {
        item = ref[j];
        arr = arr.concat(item.promises);
      }
      return $q.all(arr)['finally']((function(_this) {
        return function() {
          return _this.stacked_items = _this.stacked_items.sort(function(a, b) {
            var ref1, ref2;
            if (a.time && b.time) {
              return (ref1 = a.time.time > b.time.time) != null ? ref1 : {
                1: -1
              };
            } else if (a.service.category && !b.service.category) {
              return 1;
            } else if (b.service.category && !a.service.category) {
              return -1;
            } else if (!b.service.category && !a.service.category) {
              return 1;
            } else {
              return (ref2 = a.service.category.order > b.service.category.order) != null ? ref2 : {
                1: -1
              };
            }
          });
        };
      })(this));
    };
    Widget.prototype.deleteStackedItem = function(item) {
      if (item && item.id) {
        BBModel.Basket.$deleteItem(item, this.company, {
          bb: this
        });
      }
      return this.stacked_items = this.stacked_items.filter(function(i) {
        return i !== item;
      });
    };
    Widget.prototype.removeItemFromStack = function(item) {
      return this.stacked_items = this.stacked_items.filter(function(i) {
        return i !== item;
      });
    };
    Widget.prototype.deleteStackedItemByService = function(item) {
      var i, j, len, ref;
      ref = this.stacked_items;
      for (j = 0, len = ref.length; j < len; j++) {
        i = ref[j];
        if (i && i.service && i.service.self === item.self && i.id) {
          BBModel.Basket.$deleteItem(i, this.company, {
            bb: this
          });
        }
      }
      return this.stacked_items = this.stacked_items.filter(function(i) {
        return i && i.service && i.service.self !== item.self;
      });
    };
    Widget.prototype.emptyStackedItems = function() {
      return this.stacked_items = [];
    };
    Widget.prototype.pushStackToBasket = function() {
      var i, j, len, ref;
      this.basket || (this.basket = new BBModel.Basket(null, this));
      ref = this.stacked_items;
      for (j = 0, len = ref.length; j < len; j++) {
        i = ref[j];
        this.basket.addItem(i);
      }
      return this.emptyStackedItems();
    };
    Widget.prototype.totalStackedItemsDuration = function() {
      var duration, item, j, len, ref;
      duration = 0;
      ref = this.stacked_items;
      for (j = 0, len = ref.length; j < len; j++) {
        item = ref[j];
        if (item.service && item.service.listed_duration) {
          duration += item.service.listed_duration;
        }
      }
      return duration;
    };
    Widget.prototype.clearStackedItemsDateTime = function() {
      var item, j, len, ref, results;
      ref = this.stacked_items;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        item = ref[j];
        results.push(item.clearDateTime());
      }
      return results;
    };
    Widget.prototype.clearAddress = function() {
      delete this.address1;
      delete this.address2;
      delete this.address3;
      delete this.address4;
      return delete this.address5;
    };

    return Widget;



});
