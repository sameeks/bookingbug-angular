'use strict';

angular
  .module 'BB.uiSelect'
  .directive 'uiSelectChoicesLazyload', ($timeout, $parse, $compile, $document, $filter) ->
    (scope, elm, attr) ->

      scope.$on 'UISelect:CloseSelect', () ->
        scope.$select.close()

      raw = elm[0]
      scrollCompleted = true

      if !attr.allChoices
        throw new Error('ief:ui-select: Attribute all-choices is required in  ui-select-choices so that we can handle  pagination.')

      scope.pagingOptions = allOptions: scope.$eval(attr.allChoices)
      attr.refresh = 'addMoreItems()'
      refreshCallBack = $parse(attr.refresh)

      elm.bind('scroll', (event) ->
        remainingHeight = raw.offsetHeight - raw.scrollHeight
        scrollTop = raw.scrollTop
        percent = Math.abs(scrollTop / remainingHeight * 100)

        if percent >= 80
          if scrollCompleted
            scrollCompleted = false
            event.preventDefault()
            event.stopPropagation()
            callback = () ->
              scope.addingMore = true
              refreshCallBack scope, $event: event
              scrollCompleted = true
              return

            $timeout(callback, 100)
        return
      )

      scope.addMoreItems = (doneCalBack) ->
        $select = scope.$select
        allItems = scope.pagingOptions.allOptions
        moreItems = []
        itemsThreshold = 100
        search = $select.search

        pagingOptions = $select.pagingOptions = $select.pagingOptions or
          page: 0
          pageSize: 20
          items: $select.items

        if pagingOptions.page == 0
          pagingOptions.items.length = 0

        if !pagingOptions.originalAllItems
          pagingOptions.originalAllItems = scope.pagingOptions.allOptions

        searchDidNotChange = search and pagingOptions.prevSearch and search == pagingOptions.prevSearch

        if pagingOptions.filteredItems and searchDidNotChange
          allItems = pagingOptions.filteredItems

        pagingOptions.prevSearch = search;

        if search and search.length > 0 and pagingOptions.items.length < allItems.length and !searchDidNotChange

          pagingOptions.filteredItems = null
          moreItems = $filter('filter')(pagingOptions.originalAllItems, search)

          if moreItems.length > itemsThreshold
            if !pagingOptions.filteredItems
              pagingOptions.page = 0
              pagingOptions.items.length = 0
            else

            pagingOptions.page = 0
            pagingOptions.items.length = 0
            allItems = pagingOptions.filteredItems = moreItems

          else
            allItems = moreItems
            pagingOptions.items.length = 0
            pagingOptions.filteredItems = null

        pagingOptions.page++;

        if pagingOptions.page * pagingOptions.pageSize < allItems.length
          moreItems = allItems.slice(pagingOptions.items.length, pagingOptions.page * pagingOptions.pageSize)
        else
          moreItems = allItems

        for k in [0...moreItems.length]
          if pagingOptions.items.indexOf(moreItems[k]) == -1
            pagingOptions.items.push moreItems[k]

        scope.calculateDropdownPos()
        scope.$broadcast('uis:refresh')

        if doneCalBack
          doneCalBack()

      scope.$on('$destroy', () ->
        elm.off('scroll');
        return
      )

      return
