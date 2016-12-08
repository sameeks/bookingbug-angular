angular.module('BBMember').directive 'bbMemberBooking', () ->
  templateUrl: '_member_booking.html'
  scope:
    booking: '=bbMemberBooking'
  require: ['^?bbMemberUpcomingBookings', '^?bbMemberPastBookings']
  link: (scope, element, attrs, controllers) ->

    scope.actions = []

    member_booking_controller = if controllers[0] then controllers[0] else controllers[1]
    time_now = moment()

    scope.actions.push({action: member_booking_controller.book, label: 'Book', translation_key: 'MEMBER_BOOKING_WAITLIST_ACCEPT', disabled: !scope.booking.settings.sent_waitlist}) if scope.booking.on_waitlist and !scope.booking.datetime.isBefore(time_now, 'day')
    
    scope.actions.push({action: member_booking_controller.move, label: 'Move', translation_key: 'MEMBER_BOOKING_MOVE'})

    scope.actions.push({action: member_booking_controller.pay, label: 'Pay'}) if scope.booking.paid < scope.booking.price and scope.booking.datetime.isAfter(time_now)

    scope.actions.push({action: member_booking_controller.edit, label: 'Details', translation_key: 'MEMBER_BOOKING_EDIT'})
    
    scope.actions.push({action: member_booking_controller.cancel, label: 'Cancel', translation_key: 'MEMBER_BOOKING_CANCEL'}) if !scope.booking.datetime.isBefore(time_now, 'day')
