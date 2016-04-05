angular.module('BB.Services').factory '$exceptionHandler', ($log, AirbrakeConfig) ->
  airbrake = new (airbrakeJs.Client)(
    projectId: AirbrakeConfig.projectId
    projectKey: AirbrakeConfig.projectKey)
  airbrake.addFilter (notice) ->
    notice.context.environment = AirbrakeConfig.environment
    notice
  (exception, cause) ->
    $log.error exception
    airbrake.notify
      error: exception
      params: angular_cause: cause
    return
