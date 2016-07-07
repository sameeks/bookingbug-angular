angular.module('BB.Services').factory 'SettingsService', () ->
  i18n = false
  scroll_offset = 0
  country_code = null
  use_local_timezone = false
  currency = null
  company_time_zone = null
  display_time_zone = null

  enableInternationalizaton: () ->
    i18n = true

  isInternationalizatonEnabled: () ->
    return i18n

  setScrollOffset: (value) ->
    scroll_offset = parseInt(value)

  getScrollOffset: () ->
    return scroll_offset

  setCountryCode: (value) ->
    country_code = value
    cc = if value is 'us' then 'en' else 'en-gb'
    moment.locale(cc)

  getCountryCode: () ->
    return country_code

  setUseLocalTimezone: (value) ->
    use_local_timezone = value
    display_time_zone  = moment.tz.guess()

  getUseLocalTimezone: ->
    use_local_timezone

  setCurrency: (value) ->
    currency = value

  getCurrency: ->
    currency

  setTimeZone: (value) ->
    company_time_zone = value

  getTimeZone: ->
    company_time_zone

  setDisplayTimeZone: (value) ->
    display_time_zone = value

  getDisplayTimeZone: ->
    if display_time_zone
      display_time_zone
    else 
      company_time_zone