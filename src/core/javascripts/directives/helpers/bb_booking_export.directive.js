angular.module('BB.Directives').directive('bbBookingExport', () => {
        return {
            restrict: 'AE',
            scope: {
                booking: '=bbBookingExport'
            },
            templateUrl: '_popout_export_booking.html',
            link(scope, el, attrs) {
                let setHTML;
                scope.$watch('booking', function (new_val, old_val) {
                    if (new_val) {
                        return setHTML();
                    }
                });
                return setHTML = () =>
                    scope.content =
                        `<div class='text-center'><a href='${scope.booking.webcalLink()}'><img src='images/outlook.png' alt='outlook calendar icon' height='30' width='30' /><div class='clearfix'></div><span>Outlook</span></a></div><p></p>` +
                        `<div class='text-center'><a href='${scope.booking.gcalLink()}'><img src='images/google.png' alt='google calendar icon' height='30' width='30' /><div class='clearfix'></div><span>Google</span></a></div><p></p>` +
                        `<div class='text-center'><a href='${scope.booking.icalLink()}'><img src='images/ical.png' alt='ical calendar icon' height='30' width='30' /><div class='clearfix'></div><span>iCal</span></a></div>`
                    ;
            }
        };
    }
);
