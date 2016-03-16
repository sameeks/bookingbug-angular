angular.module('BB.Services').factory 'ErrorService', ($translate) ->
  types =
    GENERIC: 'error'
    ITEM_NO_LONGER_AVAILABLE: 'error'
    GEOLOCATION_ERROR: 'error'
    TOPUP_SUCCESS: 'success'
    ATTENDEES_CHANGED: 'info'
    PAYMENT_FAILED: 'danger'
    PASSWORD_RESET_SUCESS: 'success'
    TOPUP_SUCCESS: 'success'
    UPDATE_SUCCESS: 'success'
    PASSWORD_RESET_REQ_SUCCESS: 'success'

  get = (key) ->
    msg: $translate.instant("ALERTS.#{key}")
    persist: true
    title: ''
    type: types[key] or 'warning'

  return {getError: get, getAlert: get}
