###**
* @ngdoc service
* @name BB.Services:Alert
*
* @description
* Representation of an Alert Object
*
* @property {array} alerts The array with all types of alerts
* @property {string} add Add alert message
####

angular.module('BB.Services').factory 'AlertService', ($rootScope, ErrorService, $timeout) ->

  $rootScope.alerts = []

  ###**
    * @ngdoc method
    * @name titleLookup
    * @methodOf BB.Services:Alert
    * @description
    * Sets the appropriate title.
    *
    * @param {string} type Title type
    * @param {string} title Title
    *
    * @returns {boolean} The returned title
  ###
  titleLookup = (type, title) ->
    return title if title
    switch type
      when "error", "danger"
        title = "Error"
      else
        title = null
    title

  alertService =
    add: (type, {title, msg, persist}) ->
      persist = true if !persist?
      $rootScope.alerts = []
      alert =
        type: type
        title: titleLookup(type, title)
        msg: msg
        close: -> alertService.closeAlert(this)
      $rootScope.alerts.push(alert)
      if !persist
        $timeout ->
          $rootScope.alerts.splice($rootScope.alerts.indexOf(alert), 1)
        , 3000
      $rootScope.$broadcast "alert:raised"

    ###**
    * @ngdoc method
    * @name closeAlert
    * @methodOf BB.Services:Alert
    * @description
    * Closes the alert.
    *
    * @returns {array} alerts Alerts array without the alert that was closed
    ###
    closeAlert: (alert) ->
      @closeAlertIdx $rootScope.alerts.indexOf(alert)

    ###**
    * @ngdoc method
    * @name closeAlertIdx
    * @methodOf BB.Services:Alert
    * @description
    * Closes the alert using the alert index.
    *
    * @returns {array} alerts Alerts array without the alert that was closed
    ###
    closeAlertIdx: (index) ->
      $rootScope.alerts.splice index, 1

    ###**
    * @ngdoc method
    * @name clear
    * @methodOf BB.Services:Alert
    * @description
    * Resets the alerts array.
    *
    * @returns {array} Empty array
    ###
    clear: ->
      $rootScope.alerts = []

    ###**
    * @ngdoc error
    * @name clear
    * @methodOf BB.Services:Alert
    * @description
    * Error alert
    *
    * @param {object} alert alert object
    *
    * @returns {array} Error alert
    ###
    error: (alert) ->
      return if !alert
      @add('error', {title: alert.title, msg: alert.msg, persist: alert.persist})

    ###**
    * @ngdoc error
    * @name danger
    * @methodOf BB.Services:Alert
    * @description
    * Danger alert
    *
    * @param {object} alert alert object
    *
    * @returns {array} Dnger alert
    ###
    danger: (alert) ->
      return if !alert
      @add('danger', {title: alert.title, msg: alert.msg, persist: alert.persist})

    ###**
    * @ngdoc error
    * @name info
    * @methodOf BB.Services:Alert
    * @description
    * Info alert
    *
    * @param {object} alert alert object
    *
    * @returns {array} Info alert
    ###
    info: (alert) ->
      return if !alert
      @add('info', {title: alert.title, msg: alert.msg, persist: alert.persist})

    ###**
    * @ngdoc error
    * @name warning
    * @methodOf BB.Services:Alert
    * @description
    * Warning alert
    *
    * @param {object} alert alert object
    *
    * @returns {array} The returned warning alert
    ###
    warning: (alert) ->
      return if !alert
      @add('warning', {title: alert.title, msg: alert.msg, persist: alert.persist})

    ###**
    * @ngdoc error
    * @name raise
    * @methodOf BB.Services:Alert
    * @description
    * Raise alert
    *
    * @param {object} alert alert object
    *
    * @returns {array} Raise alert
    ###
    raise: (key) ->
      return if !key
      alert = ErrorService.getAlert(key)
      if alert
        @add(alert.type, {title: alert.title, msg: alert.msg, persist: alert.persist})
