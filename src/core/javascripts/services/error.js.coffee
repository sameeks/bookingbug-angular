'use strict'

angular.module('BB.Services').factory 'ErrorService', (GeneralOptions, $translate) ->

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
      key: 'NO_WAITLIST_SPACES_LEFT',
      type: 'error',
      title: '',
      persist: true,
      msg: 'Sorry, the space has now been taken, you are still in the waitlist and we will notify you if more spaces become available'
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
      key: 'STORE_NOT_SELECTED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'You need to select a store'
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
      msg: 'The requested time slot is not available. Please choose a different time.'
    },
    {
      key: 'TOPUP_SUCCESS',
      type: 'success',
      title: '',
      persist: true,
      msg: 'Your wallet has been topped up'
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
      key: 'SSO_LOGIN_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, the login process failed. Please try again.'
    },
    {
      key: 'PASSWORD_INVALID',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, your chosen password is invalid'
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
      msg: 'Sorry, we couldn\'t update your password. Please try again.'
    },
    {
      key: 'PASSWORD_MISMATCH',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Your passwords don\'t match'
    },
    {
      key: 'ATTENDEES_CHANGED',
      type: 'info',
      title: '',
      persist: true,
      msg: 'Your booking has been successfully updated'
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
    },
    {
      key: 'FB_LOGIN_NOT_A_MEMBER',
      type: 'warning',
      title: '',
      persist: true,
      msg: "Sorry, we couldn't find a login linked with your Facebook account. You will need to sign up using Facebook first."
    },
    {
      key: 'PHONE_NUMBER_ALREADY_REGISTERED_ADMIN',
      type: 'warning',
      title: '',
      persist: true,
      msg: "There's already an account registered with this phone number. Use the search field to find the customers account."
    },
    {
      key: 'EMAIL_ALREADY_REGISTERED_ADMIN',
      type: 'warning',
      title: '',
      persist: true,
      msg: "There's already an account registered with this email. Use the search field to find the customers account."
    },
    {
      key: 'WAITLIST_ACCEPTED',
      type: 'success',
      title: '',
      persist: false,
      msg: "Your booking is now confirmed!"
    },
    {
      key: 'BOOKING_CANCELLED',
      type: 'success',
      title: '',
      persist: false,
      msg: "Your booking has been cancelled."
    },
    {
      key: 'NOT_BOOKABLE_PERSON',
      type: 'warning',
      title: '',
      persist: false,
      msg: "Sorry, this person does not offer this service, please select another"
    },
    {
      key: 'NOT_BOOKABLE_RESOURCE',
      type: 'warning',
      title: '',
      persist: false,
      msg: "Sorry, resource does not offer this service, pelase select another"
    },
    {
      key: 'COUPON_APPLY_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, your coupon could not be applied. Please try again.'
    },
    {
      key: 'DEAL_APPLY_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, your deal code could not be applied. Please try again.'
    },
    {
      key: 'DEAL_REMOVE_FAILED',
      type: 'warning',
      title: '',
      persist: true,
      msg: 'Sorry, we were unable to remove that deal. Please try again.'
    }
  ]

  ###*
  # @param {String} msg
  # @returns {{msg: String}}
  ###
  createCustomError = (msg) ->
    return {msg: msg}

  getError = (key) ->
    error = _.findWhere(alerts, {key: key})
    error.persist = true
    translate = GeneralOptions.use_i18n
    # if i18n enabled, return the translation key
    if error and translate
      return {msg: $translate.instant('ERROR.' + key)}
    # else return the error object
    else if error and !translate
      return error
    # if no error with key given found, return generic error
    else if translate
      return {msg: 'GENERIC'}
    else
      return alerts[0]


  getAlert = (key) ->
    alert = _.findWhere(alerts, {key: key})
    translate = GeneralOptions.use_i18n
    # if i18n enabled, return the translation key
    if alert and translate
      return {msg: $translate.instant('ALERT.' + key)}
    else if alert and !translate
      return alert
    else
      return null

  return {
    createCustomError: createCustomError
    getAlert: getAlert
    getError: getError
  }

