'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbPayForm
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of pay forms for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} total The total pay_form price
* @property {array} card The card is used to payment
####


angular.module('BB.Directives').directive 'bbPayForm', ($window, $timeout,
  $sce, $http, $compile, $document, $location, GeneralOptions) ->
  restrict: 'AE'
  replace: true
  scope: true
  controller: 'PayForm'
  link: (scope, element, attributes) ->
    $window.addEventListener 'message', (event) =>
      if angular.isObject(event.data)
        data = event.data
      else if angular.isString(event.data) and not event.data.match(/iFrameSizer/)
        data = JSON.parse event.data
      if data
        switch data.type
          when "load"
            scope.$apply =>
              scope.referrer = data.message
              applyCustomPartials(event.data.custom_partial_url, scope, element) if data.custom_partial_url
              applyCustomStylesheet(data.custom_stylesheet) if data.custom_stylesheet
              GeneralOptions.scroll_offset = data.scroll_offset if data.scroll_offset
    , false

  ###**
  * @ngdoc method
  * @name applyCustomPartials
  * @methodOf BB.Directives:bbPayForm
  * @description
  * Apply the custom partials in according of custom partial url, scope and element parameters
  *
  * @param {string} custom_partial_url The custom partial url
  ###
  applyCustomPartials = (custom_partial_url, scope, element) ->
    if custom_partial_url?
      $document.domain = "bookingbug.com"
      $http.get(custom_partial_url).then (custom_templates) ->
        $compile(custom_templates.data) scope, (custom, scope) ->
          for e in custom
            if e.tagName == "STYLE"
              element.after(e.outerHTML)
          custom_form = (e for e in custom when e.id == 'payment_form')
          if custom_form and custom_form[0]
            $compile(custom_form[0].innerHTML) scope, (compiled_form, scope) ->
              form = element.find('form')[0]
              action = form.action
              compiled_form.attr('action', action)
              $(form).replaceWith(compiled_form)

  ###**
  * @ngdoc method
  * @name applyCustomStylesheet
  * @methodOf BB.Directives:bbPayForm
  * @description
  * Apply the custom stylesheet from href
  *
  * @param {string} href The href of the stylesheet
  ###
  applyCustomStylesheet = (href) ->
    css_id = 'custom_css'
    if !document.getElementById(css_id)
      head = document.getElementsByTagName('head')[0]
      link = document.createElement('link')
      link.id = css_id
      link.rel = 'stylesheet'
      link.type = 'text/css'
      link.href = href
      link.media = 'all'
      head.appendChild link

      # listen to load of css and trigger resize
      link.onload = ->
        parentIFrame.size() if 'parentIFrame' of $window
