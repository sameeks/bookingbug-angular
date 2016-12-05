'use strict'

###**
* @ngdoc service
* @name BB.Services:ErrorService
*
* @description
* Defines different alerts and errors that are raised by the SDK.
*
####
angular.module('BB.Services').factory 'ErrorService', (GeneralOptions) ->

  alerts = [
    {
      key: 'GENERIC'
      type: 'error'
      persist: true
    },
    {
      key: 'LOCATION_NOT_FOUND'
      type: 'warning'
      persist: true
    },
    {
      key: 'MISSING_LOCATION'
      type: 'warning'
      persist: true
    },
    {
      key: 'MISSING_POSTCODE'
      type: 'warning'
      persist: true,
    },
    {
      key: 'INVALID_POSTCODE'
      type: 'warning'
      persist: true
      },
    {
      key: 'ITEM_NO_LONGER_AVAILABLE'
      type: 'error'
      persist: true
    },
    {
      key: 'NO_WAITLIST_SPACES_LEFT'
      type: 'error'
      persist: true
    },
    {
      key: 'FORM_INVALID'
      type: 'warning'
      persist: true
    },
    {
      key: 'GEOLOCATION_ERROR'
      type: 'error'
      persist: true
    },
    {
      key: 'EMPTY_BASKET_FOR_CHECKOUT'
      type: 'warning'
      persist: true
    },
    {
      key: 'MAXIMUM_TICKETS'
      type: 'warning'
      persist: true
    },
    {
      key: 'GIFT_CERTIFICATE_REQUIRED'
      type: 'warning'
      persist: true
    },
    {
      key: 'TIME_SLOT_NOT_SELECTED'
      type: 'warning'
      persist: true
    },
    {
      key: 'STORE_NOT_SELECTED'
      type: 'warning'
      persist: true
    },
    {
      key: 'APPT_AT_SAME_TIME'
      type: 'warning'
      persist: true
    },
    {
      key: 'REQ_TIME_NOT_AVAIL'
      type: 'warning'
      persist: true
    },
    {
      key: 'TOPUP_SUCCESS'
      type: 'success'
      persist: true
    },
    {
      key: 'TOPUP_FAILED'
      type: 'warning'
      persist: true
    },
    {
      key: 'UPDATE_SUCCESS'
      type: 'success'
      persist: true
    },
    {
      key: 'UPDATE_FAILED'
      type: 'warning'
      persist: true
    },
    {
      key: 'ALREADY_REGISTERED'
      type: 'warning'
      persist: true
    },
    {
      key: 'LOGIN_FAILED'
      type: 'warning'
      persist: true
    },
    {
      key: 'SSO_LOGIN_FAILED'
      type: 'warning'
      persist: true
    },
    {
      key: 'PASSWORD_INVALID'
      type: 'warning'
      persist: true
    },
    {
      key: 'PASSWORD_RESET_REQ_SUCCESS'
      type: 'success'
      persist: true
    },
    {
      key: 'PASSWORD_RESET_REQ_FAILED'
      type: 'warning'
      persist: true,
    },
    {
      key: 'PASSWORD_RESET_SUCESS'
      type: 'success'
      persist: true
    },
    {
      key: 'PASSWORD_RESET_FAILED'
      type: 'warning'
      persist: true
    },
    {
      key: 'PASSWORD_MISMATCH'
      type: 'warning'
      persist: true
    },
    {
      key: 'ATTENDEES_CHANGED'
      type: 'info'
      persist: true
    },
    {
      key: 'PAYMENT_FAILED'
      type: 'danger'
      persist: true
    },
    {
      key: 'ACCOUNT_DISABLED'
      type: 'warning'
      persist: true
    },
    {
      key: 'FB_LOGIN_NOT_A_MEMBER'
      type: 'warning'
      persist: true
    },
    {
      key: 'PHONE_NUMBER_ALREADY_REGISTERED_ADMIN'
      type: 'warning'
      persist: true
    },
    {
      key: 'EMAIL_ALREADY_REGISTERED_ADMIN'
      type: 'warning'
      persist: true
    },
    {
      key: 'WAITLIST_ACCEPTED'
      type: 'success'
      persist: false
    },
    {
      key: 'BOOKING_CANCELLED'
      type: 'success'
      persist: false
    },
    {
      key: 'NOT_BOOKABLE_PERSON'
      type: 'warning'
      persist: false
    },
    {
      key: 'NOT_BOOKABLE_RESOURCE'
      type: 'warning'
      persist: false
    },
    {
      key: 'COUPON_APPLY_FAILED'
      type: 'warning'
      title: ''
      persist: true
    },
    {
      key: 'DEAL_APPLY_FAILED'
      type: 'warning'
      title: ''
      persist: true
    },
    {
      key: 'DEAL_REMOVE_FAILED'
      type: 'warning'
      title: ''
      persist: true
    }
  ]

  ###*
  # @param {String} msg
  # @returns {{msg: String}}
  ###
  createCustomError = (msg) ->
    return {msg: msg}

  ###**
  * @ngdoc method
  * @name getError
  * @methodOf BB.Directives:bbServices
  * @description
  * Returns error, always setting persist to true. Returns generic error if error with given key is not found.
  ###
  getError =  (key) ->

    error = getAlert(key)
    # return generic error if we can't find the key
    error = getAlert('GENERIC') if !error
    error.persist = true

    return error

  ###**
  * @ngdoc method
  * @name getAlert
  * @methodOf BB.Directives:bbServices
  * @description
  * Returns alert by given key
  ###
  getAlert = (key) ->

    alert = _.findWhere(alerts, {key: key})

    if alert

      alert.msg = $translate.instant("CORE.ALERTS.#{key}")

      return alert

    else

      return null

  return {
    createCustomError: createCustomError
    getAlert: getAlert
    getError: getError
  }

