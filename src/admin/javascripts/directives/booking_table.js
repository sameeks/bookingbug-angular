// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin').directive('bookingTable', function (BBModel, ModalForm) {

    let controller = function ($scope) {

        $scope.fields = ['id', 'datetime'];

        $scope.getBookings = function () {
            let params =
                {company: $scope.company};
            return BBModel.Admin.Booking.$query(params).then(bookings => $scope.bookings = bookings.items);
        };

        $scope.newBooking = () =>
            ModalForm.new({
                company: $scope.company,
                title: 'New Booking',
                new_rel: 'new_booking',
                post_rel: 'bookings',
                success(booking) {
                    return $scope.bookings.push(booking);
                }
            })
        ;

        return $scope.edit = booking =>
            ModalForm.edit({
                model: booking,
                title: 'Edit Booking'
            })
            ;
    };

    let link = function (scope, element, attrs) {
        if (scope.company) {
            return scope.getBookings();
        } else {
            return BBModel.Admin.Company.$query(attrs).then(function (company) {
                scope.company = company;
                return scope.getBookings();
            });
        }
    };

    return {
        controller,
        link,
        templateUrl: 'booking_table_main.html'
    };
});

