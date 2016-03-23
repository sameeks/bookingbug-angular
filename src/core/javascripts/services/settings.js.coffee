angular.module('BB.Services').factory 'SettingsService', () ->
  scroll_offset = 0
  country_code = ""

  setScrollOffset: (value) ->
    scroll_offset = parseInt(value)

  getScrollOffset: () ->
    return scroll_offset

  setCountryCode: (value) ->
    country_code = value

  getCountryCode: () ->
    return country_code
