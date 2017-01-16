'use strict'

angular.module('BB.Services').factory "PaginationService", ($translate) ->

  initialise: (options) ->
    return if !options
    paginator =
      current_page: 1
      page_size: options.page_size
      num_pages: null
      max_size: options.max_size
      num_items: null
    return paginator


  update: (paginator, length) ->
    return if !paginator or !length?
    paginator.num_items = length
    start = ((paginator.page_size - 1) * paginator.current_page) - ((paginator.page_size - 1) - paginator.current_page)
    end   = paginator.current_page * paginator.page_size
    total = if end < paginator.page_size then end else length
    end = if end > total then total else end
    paginator.summary = $translate.instant('CORE.PAGINATION.SUMMARY', {start: start, end: end, total: total})

  checkItems: (paginator, items_loaded) ->

    # determine if we need to load more items from the API

    items_traversed = paginator.page_size * (paginator.current_page - 1)
    remaining_items = paginator.num_items - items_loaded

    return (items_loaded < (items_traversed + paginator.page_size)) and remaining_items > 0
