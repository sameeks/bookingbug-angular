
angular.module('BB.Services').factory "ItemService", ($q, BBModel, $rootScope) ->

  query: (prms) ->

    debugger

    deferred = $q.defer()

    extra = {}
    extra.resource_id = prms.cItem.resource.id if angular.isObject(prms.cItem.resource)
    extra.person_id = prms.cItem.person.id if angular.isObject(prms.cItem.person)
    extra.company_id = prms.cItem.company.id
    extra.service_id = prms.cItem.service.id

    # TODO items link is not templated - fix in backend
    # build url manually for now

    href = $rootScope.bb.api_url + "/api/v1/{company_id}/items?service_id={service_id}&resource_id={resource_id}&person_id={person_id}"

    uri = new UriTemplate(href).fillFromObject(extra || {})


    if prms.cItem.service && prms.item != 'service'
      if !prms.cItem.service.$has('items')
        prms.cItem.service.$get('item').then (base_item) =>
          @buildItems(base_item.$get('items', extra), prms, deferred)
      else
        @buildItems(prms.cItem.service.$get('items', extra), prms, deferred)
    else if prms.cItem.resource && !prms.cItem.anyResource() && prms.item != 'resource'
      if !prms.cItem.resource.$has('items')
        prms.cItem.resource.$get('item').then (base_item) =>
          @buildItems(base_item.$get('items'), prms, deferred)
      else
        @buildItems(prms.cItem.resource.$get('items'), prms, deferred)
    
    else if prms.cItem.person && !prms.cItem.anyPerson() && prms.item != 'person'
      if !prms.cItem.person.$has('items')
        prms.cItem.person.$get('item').then (base_item) =>
          @buildItems(base_item.$get('items'), prms, deferred)
      else
        @buildItems(prms.cItem.person.$get('items'), prms, deferred)
    else
      deferred.reject("No service link found")
  
    deferred.promise



  buildItems: (base_items, prms, deferred) ->

    wait_items = [base_items]

    if prms.wait
      wait_items.push(prms.wait)

    $q.all(wait_items).then (resources) =>

      resource = resources[0]  # the first one was my own data
      resource.$get('items').then (found) =>
        matching = []
        wlist = []
        for v in found
          if v.type == prms.item
            matching.push(new BBModel.BookableItem(v))
        
        $q.all((m.ready.promise for m in matching)).then () ->
          deferred.resolve(matching)

