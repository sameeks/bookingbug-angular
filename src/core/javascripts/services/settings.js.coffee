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
    LLLL = if value == 'us' then "dddd, MMMM Do[,] h.mma" else "dddd Do MMMM[,] h.mma"
    moment.locale('en', {
        longDateFormat : {
            LT: "h:mm A",
            LTS: "h:mm:ss A",
            L: "MM/DD/YYYY",
            l: "M/D/YYYY",
            LL: "MMMM Do YYYY",
            ll: "MMM D YYYY",
            LLL: "MMMM Do YYYY LT",
            lll: "MMM D YYYY LT",
            LLLL: LLLL,
            llll: "ddd, MMM D YYYY LT"
        }
      })  

  getCountryCode: () ->
    return country_code
