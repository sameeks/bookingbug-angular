'use strict';
angular.module('BB.uiSelect').directive('uiSelectChoicesLazyload', function($timeout, $parse, $compile, $document, $filter) {
  return function(scope, elm, attr) {
    var raw, refreshCallBack, scrollCompleted;
    scope.$on('UISelect:closeSelect', function() {
      return scope.$select.close();
    });
    raw = elm[0];
    scrollCompleted = true;
    if (!attr.allChoices) {
      throw new Error('ief:ui-select: Attribute all-choices is required in  ui-select-choices so that we can handle  pagination.');
    }
    scope.pagingOptions = {
      allOptions: scope.$eval(attr.allChoices)
    };
    attr.refresh = 'addMoreItems()';
    refreshCallBack = $parse(attr.refresh);
    elm.bind('scroll', function(event) {
      var callback, percent, remainingHeight, scrollTop;
      remainingHeight = raw.offsetHeight - raw.scrollHeight;
      scrollTop = raw.scrollTop;
      percent = Math.abs(scrollTop / remainingHeight * 100);
      if (percent >= 80) {
        if (scrollCompleted) {
          scrollCompleted = false;
          event.preventDefault();
          event.stopPropagation();
          callback = function() {
            scope.addingMore = true;
            refreshCallBack(scope, {
              $event: event
            });
            scrollCompleted = true;
          };
          $timeout(callback, 100);
        }
      }
    });
    scope.addMoreItems = function(doneCalBack) {
      var $select, allItems, i, itemsThreshold, k, moreItems, pagingOptions, ref, search, searchDidNotChange;
      $select = scope.$select;
      allItems = scope.pagingOptions.allOptions;
      moreItems = [];
      itemsThreshold = 100;
      search = $select.search;
      pagingOptions = $select.pagingOptions = $select.pagingOptions || {
        page: 0,
        pageSize: 20,
        items: $select.items
      };
      if (pagingOptions.page === 0) {
        pagingOptions.items.length = 0;
      }
      if (!pagingOptions.originalAllItems) {
        pagingOptions.originalAllItems = scope.pagingOptions.allOptions;
      }
      searchDidNotChange = search && pagingOptions.prevSearch && search === pagingOptions.prevSearch;
      if (pagingOptions.filteredItems && searchDidNotChange) {
        allItems = pagingOptions.filteredItems;
      }
      pagingOptions.prevSearch = search;
      if (search && search.length > 0 && pagingOptions.items.length < allItems.length && !searchDidNotChange) {
        pagingOptions.filteredItems = null;
        moreItems = $filter('filter')(pagingOptions.originalAllItems, search);
        if (moreItems.length > itemsThreshold) {
          if (!pagingOptions.filteredItems) {
            pagingOptions.page = 0;
            pagingOptions.items.length = 0;
          } else {

          }
          pagingOptions.page = 0;
          pagingOptions.items.length = 0;
          allItems = pagingOptions.filteredItems = moreItems;
        } else {
          allItems = moreItems;
          pagingOptions.items.length = 0;
          pagingOptions.filteredItems = null;
        }
      }
      pagingOptions.page++;
      if (pagingOptions.page * pagingOptions.pageSize < allItems.length) {
        moreItems = allItems.slice(pagingOptions.items.length, pagingOptions.page * pagingOptions.pageSize);
      } else {
        moreItems = allItems;
      }
      for (k = i = 0, ref = moreItems.length; 0 <= ref ? i < ref : i > ref; k = 0 <= ref ? ++i : --i) {
        if (pagingOptions.items.indexOf(moreItems[k]) === -1) {
          pagingOptions.items.push(moreItems[k]);
        }
      }
      scope.calculateDropdownPos();
      scope.$broadcast('uis:refresh');
      if (doneCalBack) {
        return doneCalBack();
      }
    };
    scope.$on('$destroy', function() {
      elm.off('scroll');
    });
  };
});