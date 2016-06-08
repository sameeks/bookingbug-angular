angular.module('BB.Services').factory "PurchaseService", ($q, halClient, BBModel, $window, UriTemplate) ->

  query: (params) ->
    defer = $q.defer()
    uri = params.url_root+"/api/v1/purchases/"+params.purchase_id
    halClient.$get(uri, params).then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) ->
      defer.reject(err)
    defer.promise


  bookingRefQuery: (params) ->
    defer = $q.defer()
    uri = new UriTemplate(params.url_root + "/api/v1/purchases/booking_ref/{booking_ref}{?raw}").fillFromObject(params)
    halClient.$get(uri, params).then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) ->
      defer.reject(err)
    defer.promise


  update: (params) ->
    defer = $q.defer()

    if !params.purchase
      defer.reject("No purchase present")
      return defer.promise

    # only send email on the last item we're moving - otherwise we'll send an email on each item!
    data = {}

    if params.bookings
      bdata = []
      for booking in params.bookings
        bdata.push(booking.getPostData())
      data.bookings = bdata

    params.purchase.$put('self', {}, data).then (purchase) =>
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) =>
      defer.reject(err)
    defer.promise


   bookWaitlistItem: (params) ->

    debugger

    defer = $q.defer()

    if !params.purchase and !params.purchase_id
      defer.reject("No purchase or purchase_id present")

    data = {}
    #data.booking = params.booking.getPostData() if params.booking
    data.booking_id = params.booking.id

    if params.purchase

      params.purchase.$put('book_waitlist_item', {}, data).then (purchase) =>
        purchase = new BBModel.Purchase.Total(purchase)
        defer.resolve(purchase)
      , (err) ->
        defer.reject(err)
    
    else if params.purchase_id and params.url_root

      uri = params.url_root + "/api/v1/purchases/" + params.purchase_id + '/book_waitlist_item'
      
      halClient.$put(uri, {}, data).then (purchase) ->
        purchase = new BBModel.Purchase.Total(purchase)
        defer.resolve(purchase)
      , (err) ->
        defer.reject(err)
    
    return defer.promise


  deleteAll: (purchase) ->

    defer = $q.defer()

    if !purchase
      defer.reject("No purchase present")
      return defer.promise

    purchase.$del('self').then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) =>
      defer.reject(err)

    defer.promise


  deleteItem: (params) ->
    defer = $q.defer()
    uri = params.api_url + "/api/v1/purchases/" + params.long_id + "/purchase_item/" + params.purchase_item_id
    halClient.$del(uri, {}).then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) ->
      defer.reject(err)
    defer.promise
