angular.module('BB.Services').factory 'SettingsService', () ->
  scroll_offset = 0
  country_code = ""

  isInternationalizatonEnabled: -> true # use translation keys whenever possible for the few client projects who use this

  setScrollOffset: (value) ->
    scroll_offset = parseInt(value)

  getScrollOffset: () ->
    return scroll_offset

  setCountryCode: (value) ->
    country_code = value

  getCountryCode: () ->
    return country_code
