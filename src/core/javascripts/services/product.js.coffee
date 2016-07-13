angular.module('BB.Services').factory "ProductService", ($q, $window,
  halClient, UriTemplate, BBModel, $log, $rootScope) ->

  getProduct: (prms) ->

    deferred = $q.defer()

    if prms.id
      href = $rootScope.bb.api_url + "/api/v1/{company_id}/products/{id}"
      uri  = new UriTemplate(href).fillFromObject({company_id: prms.company_id, id: prms.product_id})
    else if prms.sku
      href = $rootScope.bb.api_url + "/api/v1/{company_id}/products/find_by_sku/{sku}"
      uri  = new UriTemplate(href).fillFromObject({company_id: prms.company_id, sku: prms.sku})
    else
      $log.warn("id or sku is required")
      deferred.reject()

    halClient.$get(uri, {}).then (product) ->
      deferred.resolve(new BBModel.Product (product))
    , (err) =>
      deferred.reject(err)

    deferred.promise


  query: (company) ->

    deferred = $q.defer()

    if !company.$has('products')
      deferred.reject("No products found")
    else
      company.$get('products').then (resource) =>
        resource.$get('products').then (items) =>
          resources = []
          for i in items
            resources.push(new BBModel.Product(i))
          deferred.resolve(resources)
      , (err) =>
        deferred.reject(err)

    deferred.promise
