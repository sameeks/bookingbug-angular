angular.module('BBMember').directive 'bbMemberBooking', () ->
  templateUrl: '_member_booking.html'
  scope:
    booking: '=bbMemberBooking'
  require: ['^?bbMemberUpcomingBookings', '^?bbMemberPastBookings']
  link: (scope, element, attrs, controllers) ->
    memberBookingController = if controllers[0] then controllers[0] else controllers[1]

    init = () ->
      scope.actions = []
      timeNow = moment()
      booking = scope.booking
      setBookingActions(booking, timeNow)

    setBookingActions = (booking, timeNow) ->

      if booking.on_waitlist and booking.datetime.isAfter(timeNow, 'day')
        scope.actions.push
          action: memberBookingController.book, 
          label: 'Book', 
          translation_key: 'MEMBER_BOOKING_WAITLIST_ACCEPT',
          disabled: !booking.settings.sent_waitlist

      if booking.paid < booking.price and booking.datetime.isAfter(timeNow)   
        scope.actions.push
          action: memberBookingController.pay, 
          label: 'Pay'

      if booking.min_cancellation_time.isAfter(timeNow)
        scope.actions.push
          action: memberBookingController.move, 
          label: 'Move', 
          translation_key: 'MEMBER_BOOKING_MOVE'

      scope.actions.push
        action: memberBookingController.edit, 
        label: 'Details', 
        translation_key: 'MEMBER_BOOKING_EDIT'

      if booking.min_cancellation_time.isAfter(timeNow)
        scope.actions.push
          action: memberBookingController.cancel, 
          label: 'Cancel', 
          translation_key: 'MEMBER_BOOKING_CANCEL'

    init()
