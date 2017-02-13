angular.module('BB.Services').factory("PaginationService", $translate =>

  ({
    initialise(options) {
      if (!options) { return; }
      let paginator = {
        current_page: 1,
        page_size: options.page_size,
        num_pages: null,
        max_size: options.max_size,
        num_items: null
      };
      return paginator;
    },


    update(paginator, length) {
      if (!paginator || (length == null)) { return; }
      paginator.num_items = length;
      let start = ((paginator.page_size - 1) * paginator.current_page) - ((paginator.page_size - 1) - paginator.current_page);
      let end   = paginator.current_page * paginator.page_size;
      let total = end < paginator.page_size ? end : length;
      end = end > total ? total : end;
      return paginator.summary = $translate.instant('CORE.PAGINATION.SUMMARY', {start, end, total});
    },

    checkItems(paginator, items_loaded) {

      // determine if we need to load more items from the API

      let items_traversed = paginator.page_size * (paginator.current_page - 1);
      let remaining_items = paginator.num_items - items_loaded;

      return (items_loaded < (items_traversed + paginator.page_size)) && (remaining_items > 0);
    }
  })
);
