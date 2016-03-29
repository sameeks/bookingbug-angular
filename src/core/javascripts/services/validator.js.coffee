###**
* @ngdoc service
* @name BB.Services:Validator
*
* @description
* Representation of an Validator Object
*
* @property {string} uk_postcode_regex UK postcode regex
* @property {string} uk_postcode_regex_lenient UK postcode regex (lenient)
* @property {string} number_only_regex Number only regex
* @property {regex} uk_mobile_regex_strict UK mobile regex (strict)
* @property {regex} mobile_regex_lenient Mobile number regex (lenient)
* @property {regex} uk_landline_regex_strict UK landline regex (strict)
* @property {regex} uk_landline_regex_lenient UK landline regex (lenient)
* @property {number} international_number International number
* @property {string} alphanumeric Alphanumeric
* @property {string} alpha The letters and spaces
* @property {number} us_phone_number Us phone number
###

angular.module('BB.Services').factory 'ValidatorService', ($rootScope, AlertService, SettingsService, BBModel, $q, $bbug) ->

  # Use http://regex101.com/ to test patterns

  # UK postcode regex (strict)
  # http://regexlib.com/REDetails.aspx?regexp_id=260
  # uk_postcode_regex = /^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$/i
  uk_postcode_regex = /^(((([A-PR-UWYZ][0-9][0-9A-HJKS-UW]?)|([A-PR-UWYZ][A-HK-Y][0-9][0-9ABEHMNPRV-Y]?))\s{0,1}[0-9]([ABD-HJLNP-UW-Z]{2}))|(GIR\s{0,2}0AA))$/i
  # US postcode regex used for getMailingPattern
  us_postcode_regex = /^\d{5}(?:[-\s]\d{4})?$/
  # UK postcode regex (lenient) - this checks for a postcode like string
  # https://gist.github.com/simonwhitaker/5748487
  uk_postcode_regex_lenient = /^[A-Z]{1,2}[0-9][0-9A-Z]?\s*[0-9][A-Z]{2}$/i

  # number only regex
  number_only_regex = /^\d+$/

  # UK mobile number regex (strict)
  uk_mobile_regex_strict = /^((\+44\s?|0)7([45789]\d{2}|624)\s?\d{3}\s?\d{3})$/

  # mobile number regex (lenient)
  mobile_regex_lenient = /^(0|\+)([\d \(\)]{9,19})$/

  # UK landline regex (strict)
  uk_landline_regex_strict = /^(\(?(0|\+44)[1-9]{1}\d{1,4}?\)?\s?\d{3,4}\s?\d{3,4})$/

  # UK landline regex (lenient)
  uk_landline_regex_lenient = /^(0|\+)([\d \(\)]{9,19})$/

  # international number
  international_number = /^(\+)([\d \(\)]{9,19})$/

  email_regex = /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  # password requires minimum of 7 characters and 1 number
  standard_password = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/

  # alphanumeric
  alphanumeric = /^[a-zA-Z0-9]*$/

  geocode_result = null

  # letters and spaces
  alpha: /^[a-zA-Z\s]*$/

  us_phone_number: /(^[\d \(\)-]{9,16})$/

  # Strict email check that also checks for the top domain level too part 1 of 2.
  # email_pattern: /^[a-z0-9!#$%&'*+=?^_\/`{|}~.-]+@.[a-z0-9!#$%&'*+=?^_`{|}~.-]+[.]{1}[a-z0-9-]{2,20}$/i

  ###**
  * @ngdoc method
  * @name getEmailPattern
  * @methodOf BB.Services:Validator
  * @description
  * Gets the email pattern.
  *
  * @returns {regex} Email pattern
  ###
  getEmailPattern: () ->
    return email_regex

  ###**
  * @ngdoc method
  * @name getStandardPassword
  * @methodOf BB.Services:Validator
  * @description
  * Get the email pattern
  *
  * @returns {string} Returns Password must contain at least 7 characters and 1 number password pattern
  ###
  getStandardPassword: () ->
    return standard_password

  ###**
  * @ngdoc method
  * @name getUKPostcodePattern
  * @methodOf BB.Services:Validator
  * @description
  * Gets the UK postcode pattern.
  *
  * @returns {regex} UK postcode pattern
  ###
  getUKPostcodePattern: () ->
    return uk_postcode_regex_lenient
  getMailingPattern: () ->
    cc = SettingsService.getCountryCode()
    if cc = "us"
      return us_postcode_regex
    else
      return uk_postcode_regex_lenient

  ###**
  * @ngdoc method
  * @name getNumberOnlyPattern
  * @methodOf BB.Services:Validator
  * @description
  * Gets the number only pattern.
  *
  * @returns {regex} Return the number only regex
  ###
  getNumberOnlyPattern: () ->
    return number_only_regex

  ###**
  * @ngdoc method
  * @name getAlphaNumbericPattern
  * @methodOf BB.Services:Validator
  * @description
  * Gets the alphanumeric pattern.
  *
  * @returns {string} Alphanumeric regex
  ###
  getAlphaNumbericPattern: () ->
    return alphanumeric

  ###**
  * @ngdoc method
  * @name getUKMobilePattern
  * @methodOf BB.Services:Validator
  * @description
  * Gets the UK mobile pattern.
  *
  * @param {boolean} strict strict parameter
  *
  * @returns {regex} Returns the UK mobile regex if strict parameter is not null  otherwise returns mobile regex lenient
  ###
  getUKMobilePattern: (strict = false) ->
    return uk_mobile_regex_strict if strict
    return mobile_regex_lenient

  ###**
  * @ngdoc method
  * @name getMobilePattern
  * @methodOf BB.Services:Validator
  * @description
  * Gets the  the mobile pattern.
  *
  * @returns {regex} Mobile regex
  ###
  getMobilePattern: () ->
    return mobile_regex_lenient

  ###**
  * @ngdoc method
  * @name getUKLandlinePattern
  * @methodOf BB.Services:Validator
  * @description
  * Gets the UK landline pattern.
  *
  * @param {boolean} strict strict parameter
  *
  * @returns {number} Returns the UK landline regex if strict parameter is not null othervise UK landline regex lenient
  ###
  getUKLandlinePattern: (strict = false) ->
    return uk_landline_regex_strict if strict
    return uk_landline_regex_lenient

  ###**
  * @ngdoc method
  * @name getIntPhonePattern
  * @methodOf BB.Services:Validator
  * @description
  * Gets the international phone number pattern.
  *
  * @returns {regex} International phone number pattern
  ###
  getIntPhonePattern: () ->
    return international_number

  ###**
  * @ngdoc method
  * @name getGeocodeResult
  * @methodOf BB.Services:Validator
  * @description
  * Get the geocode result.
  *
  * @returns {string} Geocode
  ###
  getGeocodeResult: () ->
    return geocode_result if geocode_result

  # Strict email check that also checks for the top domain level too part 2 of 2.
  # getEmailPatten: () ->
  #   return email_pattern
  ###**
  * @ngdoc method
  * @name validatePostcode
  * @methodOf BB.Services:Validator
  * @description
  * Validates the postcode using the form and prm parameters.
  *
  * @param {object} form object
  * @param {object} prms object
  *
  * @returns {promise} A promise for valid postocde
  ###
  validatePostcode: (form, prms) ->
    AlertService.clear()
    return false if !form || !form.postcode
    if form.$error.required
      AlertService.raise('MISSING_POSTCODE')
      return false
    else if form.$error.pattern
      AlertService.raise('INVALID_POSTCODE')
      return false
    else
      deferred = $q.defer()
      postcode = form.postcode.$viewValue
      req = {address : postcode}
      req.region = prms.region if prms.region
      req.componentRestrictions = {'postalCode': req.address}
      if prms.bounds
        sw = new google.maps.LatLng(prms.bounds.sw.x, prms.bounds.sw.y)
        ne = new google.maps.LatLng(prms.bounds.ne.x, prms.bounds.ne.y)
        req.bounds = new google.maps.LatLngBounds(sw, ne);
      geocoder = new google.maps.Geocoder()
      geocoder.geocode req, (results, status) ->
        if results.length == 1 && status == 'OK'
          geocode_result = results[0]
          deferred.resolve(true)
        else
          AlertService.raise('INVALID_POSTCODE')
          $rootScope.$apply()
          deferred.reject(false)
      deferred.promise

  ###**
  * @ngdoc method
  * @name validateForm
  * @methodOf BB.Services:Validator
  * @description
  * Validates the form using the form parameter.
  *
  * @param {object} form parameter
  *
  * @returns {boolean} True or false
  ###
  validateForm: (form) ->
    return false if !form
    form.submitted = true
    $rootScope.$broadcast "form:validated", form
    if form.$invalid and form.raise_alerts and form.alert
      AlertService.danger(form.alert)
      return false
    else if form.$invalid and form.raise_alerts
      AlertService.danger(ErrorService.getError('FORM_INVALID'))
      return false
    else if form.$invalid
      return false
    else
      return true

   ###**
  * @ngdoc method
  * @name resetForm
  * @methodOf BB.Services:Validator
  * @description
  * Resets the form using the form parameter.
  *
  * @param {object} form parameter
  *
  ###
  resetForm: (form) ->
    if form
      form.submitted = false
      form.$setPristine()

  ###**
  * @ngdoc method
  * @name resetForms
  * @methodOf BB.Services:Validator
  * @description
  * Resets the forms using forms parameter.
  *
  * @param {array} form forms array
  *
  * @returns {boolean} Checks if this is reset or not
  ###
  resetForms: (forms) ->
    if forms && $bbug.isArray(forms)
      for form in forms
        form.submitted = false
        form.$setPristine()
