angular.module('BB.Services').factory "ProductService", ($q, $window, halClient, UriTemplate) ->

  getProduct: (prms) ->
    deferred = $q.defer()
    href = prms.api_url + "/api/v1/{company_id}/products/{id}"
    uri = new UriTemplate(href).fillFromObject({company_id: prms.company_id, id: prms.product_id})
    halClient.$get(uri, {}).then (product) ->
      deferred.resolve(product)
    , (err) =>
      deferred.reject(err)
    deferred.promise