// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember').directive('bbMemberBooking', () => {
        return {
            templateUrl: '_member_booking.html',
            scope: {
                booking: '=bbMemberBooking'
            },
            require: ['^?bbMemberUpcomingBookings', '^?bbMemberPastBookings'],
            link(scope, element, attrs, controllers) {

                scope.actions = [];

                let member_booking_controller = controllers[0] ? controllers[0] : controllers[1];
                let time_now = moment();

                if (scope.booking.on_waitlist && !scope.booking.datetime.isBefore(time_now, 'day')) {
                    scope.actions.push({
                        action: member_booking_controller.book,
                        label: 'Book',
                        translation_key: 'MEMBER_BOOKING_WAITLIST_ACCEPT',
                        disabled: !scope.booking.settings.sent_waitlist
                    });
                }

                if ((scope.booking.paid < scope.booking.price) && scope.booking.datetime.isAfter(time_now)) {
                    scope.actions.push({action: member_booking_controller.pay, label: 'Pay'});
                }

                scope.actions.push({
                    action: member_booking_controller.edit,
                    label: 'Details',
                    translation_key: 'MEMBER_BOOKING_EDIT'
                });

                if (!scope.booking.datetime.isBefore(time_now, 'day')) {
                    return scope.actions.push({
                        action: member_booking_controller.cancel,
                        label: 'Cancel',
                        translation_key: 'MEMBER_BOOKING_CANCEL'
                    });
                }
            }
        };
    }
);
