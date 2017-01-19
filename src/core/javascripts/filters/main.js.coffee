'use strict'

# strips the postcode from the end of the address. i.e.
# '15 some address, somwhere, SS1 4RP' becomes '15 some address, somwhere'
angular.module('BB.Filters').filter 'stripPostcode', ->
  (address) ->
    # test to see if the address contains a postcode by searching for a any
    # letter followed by a number i.e N1, CM11
    match = address.toLowerCase().match(/[a-z]+\d/)
    # if there's a match, get the index of the match and remove postcode
    if match
      address = address.substr(0, match.index)
    # trim white space
    address = $.trim(address)
    #  remove trailing comma if there is one
    if /,$/.test(address)
      address = address.slice(0, -1)

    return address


angular.module('BB.Filters').filter 'labelNumber', ->
  (input, labels) ->
    response = input
    if labels[input]
      response = labels[input]
    return response


angular.module('BB.Filters').filter 'interpolate', ['version', (version) ->
  (text) ->
    return String(text).replace(/\%VERSION\%/mg, version)
]


angular.module('BB.Filters').filter 'rag', ->
  (value, v1, v2) ->
   if (value <= v1)
      return "red"
    else if (value <=v2)
      return "amber"
    else
      return "green"


angular.module('BB.Filters').filter 'time', ($window) ->
  (v) ->
    return $window.sprintf("%02d:%02d",Math.floor(v / 60), v%60 )

angular.module('BB.Filters').filter 'address_single_line', ->
  (address) =>

    return if !address
    return if !address.address1

    addr = ""
    addr += address.address1
    if address.address2 && address.address2.length > 0
      addr += ", "
      addr += address.address2
    if address.address3 && address.address3.length > 0
      addr += ", "
      addr += address.address3
    if address.address4 && address.address4.length > 0
      addr += ", "
      addr += address.address4
    if address.address5 && address.address5.length > 0
      addr += ", "
      addr += address.address5
    if address.postcode && address.postcode.length > 0
      addr += ", "
      addr += address.postcode
    return addr


angular.module('BB.Filters').filter 'address_multi_line', ->
  (address) =>

    return if !address
    return if !address.address1

    str = ""
    str += address.address1 if address.address1
    str += "<br/>" if address.address2 && str.length > 0
    str += address.address2 if address.address2
    str += "<br/>" if address.address3 && str.length > 0
    str += address.address3 if address.address3
    str += "<br/>" if address.address4 && str.length > 0
    str += address.address4 if address.address4
    str += "<br/>" if address.address5 && str.length > 0
    str += address.address5 if address.address5
    str += "<br/>" if address.postcode && str.length > 0
    str += address.postcode if address.postcode
    return str

angular.module('BB.Filters').filter 'map_lat_long', ->
  (address) =>
    return if !address
    return if !address.map_url

    cord = /([-+]*\d{1,3}[\.]\d*)[, ]([-+]*\d{1,3}[\.]\d*)/.exec(address.map_url)
    return cord[0]


###
 * @ngdoc filter
 * @name distance
 * @kind function
 *
 * @description
 * Formats distance using current locale.
 *
 * @param {number} distance_in_km Distance in kilometres
 * @param {integer} round_by The number of decimal places to round by

 * @returns {string} Formatted distance
 *
 *
 * @example
   <example module="distanceExample">
     <file name="index.html">
       <script>
         angular.module('distanceExample', [])
           .controller('ExampleController', ['$scope', function($scope) {
             $scope.distance = 10;
           }]);
       </script>
       <div ng-controller="ExampleController">
         <span>Price: {{distance | distance:1}}</span><br/>
       </div>
     </file>
   </example>
###
angular.module('BB.Filters').filter 'distance', ($translate, bbLocale) ->
  (distance_in_km, round_by) ->

    return '' unless distance_in_km

    distance  = distance_in_km
    use_miles = bbLocale.getLocale().match(/^(en|en-gb|en-us)$/gi)
    distance  *= 0.621371192 if use_miles
    distance  = Math.round(distance * Math.pow(10, round_by)) / Math.pow(10, round_by) if round_by
    unit      = if use_miles then $translate.instant('CORE.FILTERS.DISTANCE.MILES') else $translate.instant('CORE.FILTERS.DISTANCE.KILOMETRES')
    distance  = "#{distance} #{unit}"

    return distance


###
 * @ngdoc filter
 * @name currency
 * @kind function
 *
 * @description
 * Formats price using either the configured Company currency or the provided currency symbol.
 *
 * @param {integer} amount Input amount to format
 * @param {string} currency_code Optional currency symbol
 * @param {boolean} pretty_price Use to omit decimal places when price is whole. Default is false
 * @returns {string} Formatted currency.
 *
 *
 * @example
   <example module="currencyExample">
     <file name="index.html">
       <script>
         angular.module('currencyExample', [])
           .controller('ExampleController', ['$scope', function($scope) {
             $scope.price = 950;
           }]);
       </script>
       <div ng-controller="ExampleController">
         <span>Price: {{price | currency}}</span><br/>
       </div>
     </file>
   </example>
###
angular.module('BB.Filters').filter 'currency', ($window, $rootScope, CompanyStoreService, $translate) ->
  (amount, currency_code, pretty_price=false) ->

    return unless angular.isNumber(amount)

    currency_codes = {USD: "$", GBP: "£", AUD: "$", EUR: "€", CAD: "$", MIXED: "~", RUB: "₽"}

    currency_code ||= CompanyStoreService.currency_code

    format = $translate.instant(['CORE.FILTERS.CURRENCY.THOUSANDS_SEPARATOR', 'CORE.FILTERS.CURRENCY.DECIMAL_SEPARATOR', 'CORE.FILTERS.CURRENCY.CURRENCY_FORMAT'])

    hide_decimal   = pretty_price and (amount % 100 is 0)
    decimal_places = if hide_decimal then 0 else 2

    return $window.accounting.formatMoney(amount / 100, currency_codes[currency_code], decimal_places, format.THOUSANDS_SEPARATOR, format.DECIMAL_SEPARATORS, format.CURRENCY_FORMAT)


angular.module('BB.Filters').filter 'icurrency', ($filter) ->
  (number, currency_code) ->
    return $filter('currency')(number, currency_code)


angular.module('BB.Filters').filter 'raw_currency', -> (number) -> number / 100.0


angular.module('BB.Filters').filter 'pretty_price', ($translate, $filter) ->
  (price, currency_code) ->
    if parseFloat(price) == 0 then $translate.instant('CORE.FILTERS.PRETTY_PRICE.FREE')
    else $filter('currency')(price, currency_code, true)


angular.module('BB.Filters').filter 'ipretty_price', ($filter) ->
  (number, currencyCode) ->
    return $filter('pretty_price')(number, currencyCode)

###
 * @ngdoc filter
 * @name time_period
 * @kind function
 *
 * @description
 * Formats a number as a humanized duration, e.g. 1 hour, 2 minutes
 *
 * @param {number} minutes Input to format
 * @returns {string} Humanized duration.
 *
 *
 * @example
   <example module="timePeriodExample">
     <file name="index.html">
       <script>
         angular.module('timePeriodExample', [])
           .controller('ExampleController', ['$scope', function($scope) {
             $scope.duration = 90;
           }]);
       </script>
       <div ng-controller="ExampleController">
         <span>Duration: {{amount | time_period}}</span>
       </div>
     </file>
   </example>
###
angular.module('BB.Filters').filter 'time_period', ($translate) ->
  (v) ->

    return unless angular.isNumber(v)

    minutes = parseInt(v)

    hours          = Math.floor(minutes / 60)
    minutes        %= 60
    show_seperator = hours > 0 and minutes > 0

    time_period = $translate.instant('CORE.FILTERS.TIME_PERIOD.TIME_PERIOD', {
      hours          : hours,
      minutes        : minutes,
      show_seperator : +show_seperator
    }, 'messageformat')

    return time_period


###
 * @ngdoc filter
 * @name time_period_from_seconds
 * @kind function
 *
 * @description
 * Formats a number as a humanized duration, e.g. 1 hour, 2 minutes, 5 seconds
 *
 * @param {number} seconds Input to format
 * @returns {string} Humanized duration.
 *
 *
 * @example
   <example module="timePeriodExample">
     <file name="index.html">
       <script>
         angular.module('timePeriodExample', [])
           .controller('ExampleController', ['$scope', function($scope) {
             $scope.duration = 90;
           }]);
       </script>
       <div ng-controller="ExampleController">
         <span>Duration: {{amount | time_period_from_seconds}}</span>
       </div>
     </file>
   </example>
###
angular.module('BB.Filters').filter 'time_period_from_seconds', ($translate, $filter) ->
  (v) ->

    return unless angular.isNumber(v)

    seconds = parseInt(v)
    time_period = ''

    if seconds >= 60
      time_period += $filter('time_period')(seconds / 60)
      if (seconds % 60) > 0
        time_period += $translate.instant('CORE.FILTERS.TIME_PERIOD.TIME_SEPARATOR')
    if (seconds % 60) > 0
      time_period += moment.duration(seconds % 60, 'seconds').humanize()

    return time_period


angular.module('BB.Filters').filter 'twelve_hour_time', ($window) ->
  (time, options) ->

    return if !angular.isNumber(time)

    omit_mins_on_hour = options && options.omit_mins_on_hour or false
    separator         = if options && options.separator then options.separator else ":"

    t = time
    h = Math.floor(t / 60)
    m = t%60
    suffix = 'am'
    suffix = 'pm' if h >=12
    h -=12 if (h > 12)
    if m is 0 && omit_mins_on_hour
      time = "#{h}"
    else
      time = "#{h}#{separator}" + $window.sprintf("%02d", m)
    time += suffix
    return time


angular.module('BB.Filters').filter 'round_up', ->
  (number, interval) ->
    result = number / interval
    result = parseInt(result)
    result = result * interval
    if (number % interval) > 0
      result = result + interval
    return result


###
 * @ngdoc filter
 * @name exclude_days
 * @kind function
 *
 * @description
 * Formats a phone number using provided country code. If no country code is passed in, the country of the current company is used.
 *
 * @param {array} days Array of BBModel.Day objects
 * @param {array} excluded String array of days to exclude, e.g. ['Saturday','Sunday']
 * @returns {array} Filtered array excluding specificed days
 *
###
angular.module('BB.Filters').filter 'exclude_days', ->
  (days, excluded) ->
    _.filter days, (day) ->
      excluded.indexOf(day.date.format('dddd')) == -1



###
 * @ngdoc filter
 * @name local_phone_number
 * @kind function
 *
 * @description
 * Formats a phone number using provided country code. If no country code is passed in, the country of the current company is used.
 *
 * @param {string} phone_number The phone number to format
 * @param {string} country_code (Optional) The country code in Alpha-2 ISO-3166 format
 * @returns {string} Formatted phone number
 *
 *
 * @example
   <example module="localPhoneNumberExample">
     <file name="index.html">
       <script>
         angular.module('localPhoneNumberExample', [])
           .controller('ExampleController', ['$scope', function($scope) {
             $scope.number = "+44 7877 123456";
           }]);
       </script>
       <div ng-controller="ExampleController">
         <span>Phone Number: {{number | local_phone_number}}</span>
       </div>
     </file>
   </example>
###
angular.module('BB.Filters').filter 'local_phone_number', (CompanyStoreService, ValidatorService) ->
  (phone_number, country_code) ->

    return if !phone_number

    country_code ||= CompanyStoreService.country_code

    switch country_code
      when "gb" then return phone_number.replace(/^(\+44 \(0\)|\S{0})/, '0')
      when "us" then return phone_number.replace(ValidatorService.us_phone_number, "($1) $2 $3")
      else
        return phone_number


###
 * @ngdoc filter
 * @name datetime
 * @kind function
 *
 * @description
 * Format given moment object or datelike string using provided format.
 *
 * @param {moment|string} date The date to format
 * @param {string} format The format to apply. Defaults to LLL
 * @returns {boolean} show_time_zone Show timezone identifer. Defaults to false
 *
 *
 * @example
   <example module="dateTimeExample">
     <file name="index.html">
       <script>
         angular.module('dateTimeExample', [])
           .controller('ExampleController', ['$scope', function($scope) {
             $scope.date = moment();
           }]);
       </script>
       <div ng-controller="ExampleController">
         <span>Date: {{date | datetime}}</span>
       </div>
     </file>
   </example>
###
angular.module('BB.Filters').filter 'datetime', (GeneralOptions) ->
  (date, format="LLL", show_time_zone=false) ->

    return if !date or (date and !moment(date).isValid())
    
    new_date = moment(date)
    new_date.tz(GeneralOptions.display_time_zone)
    format += ' zz' if show_time_zone

    return new_date.format(format)


angular.module('BB.Filters').filter 'range', ->
  (input, min, max) ->
    (input.push(i) for i in [parseInt(min)..parseInt(max)])
    input


angular.module('BB.Filters').filter 'international_number', () ->
  (number, prefix) =>
    if number and prefix
      return "#{prefix} #{number}"
    else if number
      return "#{number}"
    else
      return ""


angular.module('BB.Filters').filter "startFrom", ->
  (input, start) ->
    if input is `undefined`
      input
    else
      input.slice +start


angular.module('BB.Filters').filter 'add', ->
  (item, value) =>
    if item and value
      item = parseInt(item)
      return item + value

angular.module('BB.Filters').filter 'spaces_remaining', () ->
  (spaces) ->
    if spaces < 1
      return 0
    else
      return spaces

angular.module('BB.Filters').filter 'key_translate', ->
  (input) ->
    upper_case = angular.uppercase(input)
    remove_punctuations = upper_case.replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g,"")
    add_underscore = remove_punctuations.replace(/\ /g, "_")
    return add_underscore

angular.module('BB.Filters').filter 'nl2br', ->
  return (str) ->
    if str
      # replace new lines with <br/> tags for multiline display in HTML
      return str.replace(/\n/g, '<br/>')


angular.module('BB.Filters').filter 'clearTimezone', ->
  (val, offset) ->
    if val != null and val.length > 19
      return val.substring(0, 19)
    val

angular.module('BB.Filters').filter "format_answer", ->
  (answer) ->
    if typeof answer == "boolean"
      answer = if answer is true then "Yes" else "No"
    else if moment(answer, 'YYYY-MM-DD', true).isValid()
      answer = moment(answer).format "D MMMM YYYY"
    return answer

angular.module('BB.Filters').filter 'snakeCase', ->
  (string) ->
    return string.trim().replace(/\s/g, '_').toLowerCase()

# -------------------------------------------------------------------------------------------
# filters out all non alpha-numeric characters with the exception of space and underscore
# -------------------------------------------------------------------------------------------
angular.module('BB.Filters').filter 'wordCharactersAndSpaces', ->
  (string) ->
    return string.replace(/[^a-zA-Z0-9\_\s]+/, '')
