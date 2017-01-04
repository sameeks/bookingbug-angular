'use strict';

angular
  .module 'BB.uiSelect'
  .directive 'uiSelectChoicesLazyload', ($timeout, $parse, $compile, $document, $filter) ->
    (scope, elm, attr) ->

      scope.$on 'close-select', () ->
        scope.$select.close()

      raw = elm[0]
      scrollCompleted = true

      if !attr.allChoices
        throw new Error('ief:ui-select: Attribute all-choices is required in  ui-select-choices so that we can handle  pagination.')

      scope.pagingOptions =
        allOptions: scope.$eval(attr.allChoices)

      attr.refresh = 'addMoreItems()';

      refreshCallBack = $parse(attr.refresh);

      elm.bind('scroll', (event) ->
        remainingHeight = raw.offsetHeight - raw.scrollHeight;
        scrollTop = raw.scrollTop;
        percent = Math.abs((scrollTop / remainingHeight) * 100);

        if percent >= 80
          if scrollCompleted
            scrollCompleted = false
            event.preventDefault()
            event.stopPropagation()
            callback = () ->
              scope.addingMore = true
              refreshCallBack(scope,
                $event: event
              )
              scrollCompleted = true

            $timeout(callback, 100)
      )

      closeDestroyer = scope.$on('uis:close', () ->
        pagingOptions = scope.$select.pagingOptions || {}
        pagingOptions.filteredItems = undefined
        pagingOptions.page = 0
      )

      scope.addMoreItems = (doneCalBack) ->
        console.log('new addMoreItems')
        $select = scope.$select
        allItems = scope.pagingOptions.allOptions
        moreItems = []
        itemsThreshold = 100
        search = $select.search

        pagingOptions = $select.pagingOptions = $select.pagingOptions ||
          page: 0,
          pageSize: 20,
          items: $select.items

        if pagingOptions.page == 0
          pagingOptions.items.length = 0

        if !pagingOptions.originalAllItems
          pagingOptions.originalAllItems = scope.pagingOptions.allOptions

        console.log('search term=' + search)
        console.log('prev search term=' + pagingOptions.prevSearch)

        searchDidNotChange = search && pagingOptions.prevSearch && search == pagingOptions.prevSearch
        console.log('isSearchChanged=' + searchDidNotChange)

        if pagingOptions.filteredItems && searchDidNotChange
          allItems = pagingOptions.filteredItems

        pagingOptions.prevSearch = search;

        if search && search.length > 0 && pagingOptions.items.length < allItems.length && !searchDidNotChange

          if !pagingOptions.filteredItems
            console.log('previous ' + pagingOptions.filteredItems)

          pagingOptions.filteredItems = undefined
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
            pagingOptions.filteredItems = undefined

        else
          console.log('plain paging')

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

        # if doneCalBack
        #   doneCalBack()

      scope.$on('$destroy', () ->
        elm.off('scroll');
        closeDestroyer();
      )

      return
