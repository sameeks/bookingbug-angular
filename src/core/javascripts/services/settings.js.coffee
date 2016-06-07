angular.module('BB.Services').factory 'SettingsService', () ->
  i18n = false
  scroll_offset = 0
  country_code = ""

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
