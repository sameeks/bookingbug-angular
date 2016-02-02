'use strict';

angular.module('BB.Directives').directive 'bbContent', ($compile) ->
  transclude: false,
  restrict: 'A',
  link: (scope, element, attrs) ->
    element.attr('ng-include',"bb_main")
    element.attr('onLoad',"initPage()")
    element.attr('bb-content',null)
    element.attr('ng-hide',"hide_page")
    scope.initPage = () =>
      scope.setPageLoaded()
      scope.setLoadingPage(false)

    $compile(element)(scope)

angular.module('BB.Directives').directive 'bbLoading', ($compile) ->
  transclude: false,
  restrict: 'A',
  link: (scope, element, attrs) ->
    scope.scopeLoaded = scope.areScopesLoaded(scope)
    element.attr('ng-hide',"scopeLoaded")
    element.attr('bb-loading',null)
    $compile(element)(scope)
    return

angular.module('BB.Directives').directive 'bbWaitFor', ($compile) ->
  transclude: false,
  restrict: 'A',
  priority: 800,
  link: (scope, element, attrs) ->
    name = attrs.bbWaitVar
    name ||= "allDone"
    scope[name] = false
    prom = scope.$eval(attrs.bbWaitFor)
    prom.then () ->
      scope[name] = true
    return

# bbScrollTo
# Allows you to scroll to a specific element
angular.module('BB.Directives').directive 'bbScrollTo', ($rootScope, AppConfig, BreadcrumbService, $bbug, $window, SettingsService) ->
  transclude: false,
  restrict: 'A',
  link: (scope, element, attrs) ->

    evnts = attrs.bbScrollTo.split(',')
    always_scroll = attrs.bbAlwaysScroll? or false
    bb_transition_time = if attrs.bbTransitionTime? then parseInt(attrs.bbTransitionTime, 10) else 500

    if angular.isArray(evnts)
      angular.forEach evnts, (evnt) ->
        scope.$on evnt, (e) ->
          scrollToCallback(evnt)
    else
      scope.$on evnts, (e) ->
        scrollToCallback(evnts)

    scrollToCallback = (evnt) ->
      if evnt == "page:loaded" && scope.display && scope.display.xs && $bbug('[data-scroll-id="'+AppConfig.uid+'"]').length
        scroll_to_element = $bbug('[data-scroll-id="'+AppConfig.uid+'"]')
      else
        scroll_to_element = $bbug(element)

      current_step = BreadcrumbService.getCurrentStep()
      
      # if the event is page:loaded or the element is not in view, scroll to it
      if (scroll_to_element)
        if (evnt == "page:loaded" and current_step > 1) or always_scroll or (evnt == "widget:restart") or
          (not scroll_to_element.is(':visible') and scroll_to_element.offset().top != 0)
            if 'parentIFrame' of $window
              parentIFrame.scrollToOffset(0, scroll_to_element.offset().top - SettingsService.getScrollOffset())
            else
              $bbug("html, body").animate
                scrollTop: scroll_to_element.offset().top - SettingsService.getScrollOffset()
                , bb_transition_time

# bbSlotGrouper
# group time slots together based on a given start time and end time
angular.module('BB.Directives').directive 'bbSlotGrouper', () ->
  restrict: 'A'
  scope: true
  link: (scope, element, attrs) ->
    slots = scope.$eval(attrs.slots)
    return if !slots 
    scope.grouped_slots = []
    for slot in slots
      scope.grouped_slots.push(slot) if slot.time >= scope.$eval(attrs.startTime) && slot.time < scope.$eval(attrs.endTime)
    scope.has_slots = scope.grouped_slots.length > 0

# bbForm
# Adds behaviour to select first invalid input 
# TODO more all form behaviour to this directive, initilising options as parmas
angular.module('BB.Directives').directive 'bbForm', ($bbug, $window, SettingsService) ->
  restrict: 'A'
  require: '^form'
  link: (scope, elem, attrs, ctrls) ->

    form_controller = ctrls

    # set up event handler on the form element
    elem.on "submit", ->

      form_controller.submitted = true

      # mark nested forms as submitted too
      for property of form_controller
        if form_controller[property].hasOwnProperty('$valid')
          form_controller[property].submitted = true

      scope.$apply()

      invalid_form_group = elem.find('.has-error:first')
      
      if invalid_form_group && invalid_form_group.length > 0
        if 'parentIFrame' of $window
          parentIFrame.scrollToOffset(0, invalid_form_group.offset().top - SettingsService.getScrollOffset())
        else 
          $bbug("html, body").animate
            scrollTop: invalid_form_group.offset().top - SettingsService.getScrollOffset()
            , 1000

        invalid_input = invalid_form_group.find('.ng-invalid')
        invalid_input.focus()
        return false
      return true

# bbAddressMap
# Adds behaviour to select first invalid input 
angular.module('BB.Directives').directive 'bbAddressMap', ($document) ->
  restrict: 'A'
  scope: true
  replace: true
  controller: ($scope, $element, $attrs) ->

    $scope.isDraggable = $document.width() > 480

    $scope.$watch $attrs.bbAddressMap, (new_val, old_val) ->
      
      return if !new_val

      map_item = new_val

      $scope.map = { 
        center: { 
          latitude: map_item.lat, 
          longitude: map_item.long 
        }, 
        zoom: 15
      }

      $scope.options = {
        scrollwheel: false,
        draggable: $scope.isDraggable
      }

      $scope.marker = {
        id: 0,
        coords: {
          latitude: map_item.lat,
          longitude: map_item.long
        }
      }

angular.module('BB.Directives').directive 'bbMergeDuplicateQuestions', () ->
  restrict: 'A'
  scope: true
  controller: ($scope, $rootScope) ->

    $scope.questions = {}

    $rootScope.$on "item_details:loaded", () ->

      for item in $scope.bb.stacked_items
        if item.item_details and item.item_details.questions
          item.item_details.hide_questions = false
          for question in item.item_details.questions
            if $scope.questions[question.id]
              # this is a duplicate, setup clone and hide it
              item.setCloneAnswers($scope.questions[question.id].item)
              item.item_details.hide_questions = true
              break
            else
              $scope.questions[question.id] = {question: question, item: item}

      $scope.has_questions = _.pluck($scope.questions, 'question').length > 0

angular.module('BB.Directives').directive 'bbModal', ($window, $bbug) ->
  restrict: 'A'
  scope: true
  link: (scope, elem, attrs) ->

    # watch modal height to ensure it does not exceed window height
    deregisterWatcher = scope.$watch ->
      height = elem.height()
      modal_padding = 200
      if height > $bbug(window).height()
        new_height = $bbug(window).height() - modal_padding
        elem.attr( 'style', 'height: ' + (new_height) + 'px; overflow-y: scroll;' )
        deregisterWatcher()

###**
* @ngdoc directive
* @name BB.Directives:bbBackgroundImage
* @restrict A
* @scope true
*
* @description
* Adds a background-image to an element

* @param
* {string} url
*
* @example
* <div bb-background-image='images/example.jpg'></div>
####
angular.module('BB.Directives').directive('bbBackgroundImage', () ->
    restrict: 'A'
    scope: true
    link: (scope, el, attrs) ->     
      return if !attrs.bbBackgroundImage or attrs.bbBackgroundImage == ""
      killWatch = scope.$watch attrs.bbBackgroundImage, (new_val, old_val) ->       
        if new_val          
          killWatch()
          el.css('background-image', 'url("' + new_val + '")')
)

###**
* @ngdoc directive
* @name BB.Directives:bbCapacityView
* @restrict A
* @description
* Assigns an appropriate description of ticket availability based
* on the value of the "Select spaces view" dropdown in the admin console
* @param
* {object} The event object
* @attribute ticket-type-singular
* {String} Custom name for the ticket
* @example
* <div bb-capacity-view='event' ticket-type-singular='seat'></div>
* @example_view
* 5 of 10 seats available
####
angular.module('BB.Directives').directive('bbCapacityView', () ->
  restrict: 'A'
  template: '{{capacity_view_description}}'
  link: (scope, el, attrs) ->
    ticket_type = attrs.ticketTypeSingular || "ticket"
    killWatch = scope.$watch(attrs.bbCapacityView, (item) ->
      if item
        killWatch()

        num_spaces_plural = if item.num_spaces > 1 then "s" else ""
        spaces_left_plural = if item.spaces_left > 1 then "s" else ""
        
        switch item.chain.capacity_view
          when "NUM_SPACES" then scope.capacity_view_description = scope.ticket_spaces = item.num_spaces + " " + ticket_type + num_spaces_plural
          when "NUM_SPACES_LEFT" then scope.capacity_view_description = scope.ticket_spaces = item.spaces_left + " " + ticket_type + spaces_left_plural + " available"
          when "NUM_SPACES_AND_SPACES_LEFT" then scope.capacity_view_description = scope.ticket_spaces = item.spaces_left + " of " + item.num_spaces + " " + ticket_type + num_spaces_plural + " available"

      )
  )
