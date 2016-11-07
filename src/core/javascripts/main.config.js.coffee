'use strict'

angular.module('BB').value('AppConfig', {
  appId: 'f6b16c23',
  appKey: 'f0bc4f65f4fbfe7b4b3b7264b655f5eb'
})

angular.module('BB').value('AirbrakeConfig', {
  projectId: '122836',
  projectKey: 'e6d6710b2cf00be965e8452d6a384d37',
  environment: if window.location.hostname is 'localhost' then 'development' else 'production'
})

if (window.use_no_conflict)
  window.bbjq = $.noConflict()
  angular.module('BB').value '$bbug', jQuery.noConflict(true)
else
  angular.module('BB').value '$bbug', jQuery

angular.module('BB').constant('UriTemplate', window.UriTemplate)

angular.module('BB').config ($locationProvider, $httpProvider, $provide, ie8HttpBackendProvider, uiGmapGoogleMapApiProvider) ->
  'ngInject'

  uiGmapGoogleMapApiProvider.configure({
    v: '3.20',
    libraries: 'weather,geometry,visualization'
  })

  $httpProvider.defaults.headers.common =
    'App-Id': 'f6b16c23',
    'App-Key': 'f0bc4f65f4fbfe7b4b3b7264b655f5eb'

  # this should not be enforced - but set per app for custom app that uses html paths
  # $locationProvider.html5Mode(false).hashPrefix('!')

  int = (str) ->
    parseInt(str, 10)

  lowercase = (string) ->
    if angular.isString(string) then string.toLowerCase() else string

  msie = int((/msie (\d+)/.exec(lowercase(navigator.userAgent)) || [])[1])
  if (isNaN(msie))
    msie = int((/trident\/.*; rv:(\d+)/.exec(lowercase(navigator.userAgent)) || [])[1])

  regexp = /Safari\/([\d.]+)/
  result = regexp.exec(navigator.userAgent)
  webkit = parseFloat(result[1]) if result

  if (msie && msie <= 9) or (webkit and webkit < 537)
    $provide.provider({$httpBackend: ie8HttpBackendProvider})


  moment.fn.toISODate ||= -> this.clone().locale('en').format('YYYY-MM-DD')

  return

window.bookingbug =
  logout: (options) ->
    options ||= {}
    options.reload = true unless options.reload == false
    logout_opts =
      app_id: 'f6b16c23'
      app_key: 'f0bc4f65f4fbfe7b4b3b7264b655f5eb'
    logout_opts.root = options.root if options.root
    angular.injector(['BB.Services', 'BB.Models', 'ng'])
    .get('LoginService').logout(logout_opts)
    window.location.reload() if options.reload

# String::includes polyfill
if !String::includes

  String::includes = (search, start) ->
    if typeof start != 'number'
      start = 0
    if start + search.length > @length
      false
    else
      @indexOf(search, start) != -1

# Extend String with parameterise method
String::parameterise = (seperator = '-') ->
  @trim().replace(/\s/g, seperator).toLowerCase()