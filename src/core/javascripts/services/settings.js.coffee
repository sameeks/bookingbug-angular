angular.module('BB.Services').factory 'SettingsService', () ->
  scroll_offset = 0

  isInternationalizatonEnabled: -> true # use translation keys whenever possible

  setScrollOffset: (value) ->
    scroll_offset = parseInt(value)

  getScrollOffset: () ->
    return scroll_offset
