// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc filter
 * @name BBAdminDashboard.filters.filter:minutesToString
 * @description
 * Converts a number to the desired format (default is hour minute(HH:mm))
 */
angular.module('BBAdminDashboard').filter('minutesToString', () =>
    function (minutes, format) {
        if (format == null) {
            format = 'HH:mm';
        }
        return moment(moment.duration(minutes, 'minutes')._data).format(format);
    }
);
