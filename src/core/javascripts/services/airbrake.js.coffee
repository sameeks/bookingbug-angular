###**
* @ngdoc service
* @name BB.Services:Airbrake
*
* @description
* JavaScript notifier for capturing errors in web browsers and reporting them to Airbrake.
*
####

angular.module('BB.Services').factory '$exceptionHandler', ($log, AirbrakeConfig) ->

  airbrake = new airbrakeJs.Client(
    projectId: AirbrakeConfig.projectId
    projectKey: AirbrakeConfig.projectKey
  )

  airbrake.addFilter (notice) ->
    if AirbrakeConfig.environment is 'development' || !notice.params.from_sdk
      return false

    notice.context.environment = 'production'
    notice

  (exception, cause, sdkError) ->
    $log.error exception
    airbrake.notify
      error: exception
      params: angular_cause: cause, from_sdk: sdkError
    return
