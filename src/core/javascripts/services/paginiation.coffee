angular.module('BB.Services').factory "PaginationService", () ->

  initialise: (options) ->
    return if !options
    paginator = {current_page: 1, page_size: options.page_size, num_pages: null, max_size: options.max_size, num_items: null}
    return paginator 


  update: (paginator, length) ->
    return if !paginator or !length
    paginator.num_items = length
    start = ((paginator.page_size - 1) * paginator.current_page) - ((paginator.page_size - 1) - paginator.current_page)
    end   = paginator.current_page * paginator.page_size
    total = if end < paginator.page_size then end else length
    end = if end > total then total else end
    total = if total >= 100 then "100+" else total
    paginator.summary =  "#{start} - #{end} of #{total}"


  checkItems: (paginator, items_loaded) ->

    # determine if we need to load more items

    remaining_items = paginator.num_items - items_loaded
    items_traversed = (paginator.current_page - 1) * paginator.page_size


    # if 15 a page and loading 20 at a time, 2 page would need to make request to get more
    # 15 


    # items loaded 20
    # 20 - 15 = 5 LOAD MORE

    # items loaded 15
    # 15 - 15 = 0 LOAD MORE


    # total entires - items loaded =   remaining items
        16                 10           6


    # page items
    10 

    # if remaning items greater than number displayed, load more!