angular.module('BB.Services').factory 'SettingsService', () ->
  i18n = false
  scroll_offset = 0
  country_code = ""
  use_local_timezone = false

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

  getCountryCode: () ->
    return country_code

  setUseLocalTimezone: (value) ->
    use_local_timezone = value?

  getUseLocalTimezone: ->
    use_local_timezone
