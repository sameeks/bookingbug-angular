'use strict'

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

angular.module('BB.Services').factory 'AlertService', ($rootScope, ErrorService, $timeout, $translate, $bbug, AppService) ->

  $rootScope.alerts = []

  ###**
    * @ngdoc method
    * @name titleLookup
    * @methodOf BB.Services:Alert
    * @description
    * Title look up in according of type and title parameters
    *
    * @returns {boolean} The returned title
  ###
  titleLookup = (type, title) ->
    return title if title 
    switch type
      when "error", "danger"
        title = $translate.instant('CORE.ERROR_HEADING')
      else
        title = null
    title



  alertService =
    add: (type, {title, msg, persist}) ->
      if AppService.isModalOpen
        $bbug('[ng-app]').find('.alerts').css('opacity', '0')
        $bbug('[ng-app]').find('.modal-dialog').find('.alerts').css('opacity', '1')

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
    * Close alert
    *
    * @returns {boolean}  close alert
    ###
    closeAlert: (alert) ->
      @closeAlertIdx $rootScope.alerts.indexOf(alert)

    ###**
    * @ngdoc method
    * @name closeAlertIdx
    * @methodOf BB.Services:Alert
    * @description
    * Close alert index
    *
    * @returns {boolean}  The returned close alert index
    ###
    closeAlertIdx: (index) ->
      $rootScope.alerts.splice index, 1

    ###**
    * @ngdoc method
    * @name clear
    * @methodOf BB.Services:Alert
    * @description
    * Clear alert message
    *
    * @returns {array} Newly clear array of the alert messages
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
    * @returns {array} The returned error alert
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
    * @returns {array} The returned danger alert
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
    * @returns {array} The returned info alert
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
    * @returns {array} The returned warning alert
    ###
    warning: (alert) ->
      return if !alert
      @add('warning', {title: alert.title, msg: alert.msg, persist: alert.persist})


    ###**
    * @ngdoc error
    * @name success
    * @methodOf BB.Services:Alert
    * @description
    * Success alert
    *
    * @returns {array} The returned warning alert
    ###
    success: (alert) ->
      return if !alert
      @add('success', {title: alert.title, msg: alert.msg, persist: alert.persist})



    ###**
    * @ngdoc error
    * @name raise
    * @methodOf BB.Services:Alert
    * @description
    * Raise alert
    *
    * @returns {array} The returned raise alert
    ###
    raise: (key) ->
      return if !key
      alert = ErrorService.getAlert(key)
      if alert
        @add(alert.type, {title: alert.title, msg: alert.msg, persist: alert.persist})

