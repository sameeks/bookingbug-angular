angular.module('BB.Services').factory 'ErrorService', (SettingsService) ->

  alerts = [
    {
      key: 'GENERIC',
      type: 'error',
      title: '',
      persist: true,
      msg: "Sorry, it appears that something went wrong. Please try again or call the business you're booking with if the problem persists."
    },
    {
      key: 'LOCATION_NOT_FOUND',
      type: 'warning', 
      title: '', 
      persist: true,
      msg: "Sorry, we don't recognise that location"
    },
    {
      key: 'MISSING_LOCATION',
      type: 'warning', 
      title: '',
      persist: true,
      msg: 'Please enter your location'
    },
    {
      key: 'MISSING_POSTCODE',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Please enter a postcode'
    },
    {
      key: 'INVALID_POSTCODE',
      type: 'warning', 
      title: '',
      persist: true,
      msg: 'Please enter a valid postcode'
      },
    {
      key: 'ITEM_NO_LONGER_AVAILABLE', 
      type: 'error',       
      title: '',
      persist: true,
      msg: 'Sorry. The item you were trying to book is no longer available. Please try again.'
    },
    {
      key: 'FORM_INVALID',
      type: 'warning',
      title: '', 
      persist: true,
      msg: 'Please complete all required fields'
    },
    {
      key: 'GEOLOCATION_ERROR',
      type: 'error', 
      title: '',
      persist: true,
      msg: 'Sorry, we could not determine your location. Please try searching instead.'
    },
    {
      key: 'EMPTY_BASKET_FOR_CHECKOUT', 
      type: 'warning',
      title: '',
      persist: true,
      msg: 'You need to add some items to the basket before you can checkout.'
    },
    {
      key: 'MAXIMUM_TICKETS',
      type: 'warning', 
      title: '',
      persist: true,
      msg: 'Sorry, the maximum number of tickets per person has been reached.'
    },
    {
      key: 'GIFT_CERTIFICATE_REQUIRED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'A valid Gift Certificate is required to proceed with this booking'
    },
    {
      key: 'TIME_SLOT_NOT_SELECTED',
      type: 'warning', 
      title: '',
      persist: true,
      msg: 'You need to select a time slot'
    },
    {
      key: 'APPT_AT_SAME_TIME',
      type: 'warning', 
      title: '',
      persist: true,
      msg: 'Your appointment is already booked for this time'
    },
    {
      key: 'REQ_TIME_NOT_AVAIL',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, the requested time slot is not available. Please choose a different time.'
    },
    {
      key: 'TOPUP_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, your topup failed. Please try again.'
    },
    {
      key: 'UPDATE_SUCCESS',
      type: 'success',
      title: '',
      persist: true,
      msg: 'Updated'
    },
    {
      key: 'UPDATE_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Update failed. Please try again'
    },
    {
      key: 'ALREADY_REGISTERED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'You have already registered with this email address. Please login or reset your password.'
    },
    {
      key: 'LOGIN_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, your email or password was not recognised. Please try again or reset your password.'
    },
    {
      key: 'PASSWORD_RESET_REQ_SUCCESS',
      type: 'success',
      title: '',
      persist: true,
      msg: 'We have sent you an email with instructions on how to reset your password.'
    },
    {
      key: 'PASSWORD_RESET_REQ_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, we didn\'t find an account registered with that email.'
    },
    {
      key: 'PASSWORD_RESET_SUCESS',
      type: 'success',
      title: '',
      persist: true,
      msg: 'Your password has been updated.'
    },
    {
      key: 'PASSWORD_RESET_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, we couldn\'t update your password. Plese try again.'
    },
    {
      key: 'PASSWORD_MISMATCH',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Your passwords don\'t match each other.'
    },
    {
      key: 'PAYMENT_FAILED',
      type: 'danger',
      title: '',
      persist: true,
      msg: 'We were unable to take payment. Please contact your card issuer or try again using a different card'
    },
    {
      key: 'ACCOUNT_DISABLED',
      type: 'warning',
      title: '',
      persist: true,
      msg: "Your account appears to be disabled. Please contact the business you're booking with if the problem persists."
    }
  ]

  getError: (key) ->
    error = _.findWhere(alerts, {key: key})
    error.persist = true
    translate = SettingsService.isInternationalizatonEnabled()
    # if i18n enabled, return the translation key
    if error and translate
      return {msg: "ERROR.#{key}"}
    # else return the error object
    else if error and !translate
      return error
    # if no error with key given found, return generic error
    else if translate
      return {msg: 'GENERIC'}
    else
      return alerts[0]


  getAlert: (key) ->
    alert = _.findWhere(alerts, {key: key})
    translate = SettingsService.isInternationalizatonEnabled()
    # if i18n enabled, return the translation key
    if alert and translate
      return {msg: "ALERT.#{key}"}
    else if alert and !translate
      return alert
    else
      return null
