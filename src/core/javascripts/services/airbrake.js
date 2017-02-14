// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc service
 * @name BB.Services:Airbrake
 *
 * @description
 * JavaScript notifier for capturing errors in web browsers and reporting them to Airbrake.
 *
 *///

angular.module('BB.Services').factory('$exceptionHandler', function ($log, AirbrakeConfig) {

    let airbrake = new airbrakeJs.Client({
        projectId: AirbrakeConfig.projectId,
        projectKey: AirbrakeConfig.projectKey
    });

    airbrake.addFilter(function (notice) {
        if ((AirbrakeConfig.environment === 'development') || !notice.params.from_sdk) {
            return false;
        }

        notice.context.environment = 'production';
        return notice;
    });

    return function (exception, cause, sdkError) {
        $log.error(exception);
        airbrake.notify({
            error: exception,
            params: {
                angular_cause: cause, from_sdk: sdkError
            }
        });
    };
});

