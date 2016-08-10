angular.module('BBMember.Services').factory "MemberBookingService", ($q, SpaceCollections, $rootScope, MemberService, BBModel) ->

  query: (member, params) ->
    deferred = $q.defer()
    params ||= {}
    params.no_cache = true
    if !member.$has('bookings')
      deferred.reject("member does not have bookings")
    else
      member.$get('bookings', params).then (resource) =>

        collection = new BBModel.Member.BookingCollection(resource)
        collection.promise.then (collection) ->
          deferred.resolve(collection)

    deferred.promise


  cancel: (member, booking) ->
    deferred = $q.defer()
    booking.$del('self').then (b) =>
      booking.deleted = true
      b = new BBModel.Member.Booking(b)
      MemberService.refresh(member).then (member) =>
        member = member
      , (err) =>
      deferred.resolve(b)
    , (err) =>
      deferred.reject(err)
    deferred.promise


  update: (booking) ->
    deferred = $q.defer()
    $rootScope.member.flushBookings()
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
