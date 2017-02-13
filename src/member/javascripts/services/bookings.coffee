angular.module('BBMember.Services').factory "MemberBookingService", ($q, SpaceCollections, $rootScope, MemberService, BBModel) ->

  query: (member, params) ->
    deferred = $q.defer()
    params ||= {}
    params.no_cache = true
    if !member.$has('bookings')
      deferred.reject("member does not have bookings")
    else
      member.$get('bookings', params).then (bookings) =>
        if angular.isArray bookings
          # bookings embedded in member
          bookings = (new BBModel.Member.Booking(booking) for booking in bookings)
          deferred.resolve(bookings)
        else
          params.no_cache = false
          bookings.$get('bookings', params).then (bookings) =>
            bookings = (new BBModel.Member.Booking(booking) for booking in bookings)
            deferred.resolve(bookings)
          , (err) ->
            deferred.reject(err)
      , (err) ->
        deferred.reject(err)
    deferred.promise

  cancel: (member, booking) ->
    deferred = $q.defer()
    booking.$del('self').then (b) =>
      booking.deleted = true
      b = new BBModel.Member.Booking(b)
      BBModel.Member.Member.$refresh(member).then (member) =>
        member = member
      , (err) =>
      deferred.resolve(b)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  update: (booking) ->
    deferred = $q.defer()
    booking.$put('self', {}, booking).then (booking) =>
      book = new BBModel.Member.Booking(booking)
      SpaceCollections.checkItems(book)
      deferred.resolve(book)
    , (err) =>
      _.each booking, (value, key, booking) ->
        if key != 'data' && key != 'self'
          booking[key] = booking.data[key]
      deferred.reject(err, new BBModel.Member.Booking(booking))
    deferred.promise

  flush: (member, params) ->
    if member.$has('bookings')
      member.$flush('bookings', params)
