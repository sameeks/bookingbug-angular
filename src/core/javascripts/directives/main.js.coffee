'use strict'

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


angular.module('BB.Directives').directive 'bbLoading', ($compile, $timeout, $bbug, LoadingService) ->
  link: (scope, element, attrs) ->
    scope.scopeLoaded = LoadingService.areScopesLoaded(scope)
    element.attr("ng-hide", "scopeLoaded")
    element.attr("bb-loading", null)

    positionLoadingIcon = () ->
      loading_icon = $bbug('.bb-loader').find('#loading_icon')
      wait_graphic = $bbug('.bb-loader').find('#wait_graphic')
      modal_open   = $bbug('[ng-app]').find('#bb').hasClass('modal-open')

      if modal_open
        $timeout ->
          center = $bbug('[ng-app]').find('.modal-dialog').height() or $bbug('[ng-app]').find('.modal-content').height() or $bbug('[ng-app]').find('.modal').height()
          center = (center / 2) - (wait_graphic.height() / 2)
          loading_icon.css("padding-top", center + "px")
        , 50
      else
        center = ($(window).innerHeight() / 2) - (wait_graphic.height() / 2)
        loading_icon.css("padding-top", center + "px")

    positionLoadingIcon()
    $bbug(window).on "resize", ->
      positionLoadingIcon()
    scope.$on "page:loaded", ->
      positionLoadingIcon()

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
    if !prom
      scope[name] = true
    else
      prom.then () ->
        scope[name] = true
    return



# bbScrollTo
# Allows you to scroll to a specific element
angular.module('BB.Directives').directive 'bbScrollTo', ($rootScope, AppConfig, BreadcrumbService, $bbug, $window, GeneralOptions, viewportSize) ->
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

    isElementInView = (el) ->
      return el.offset().top > $bbug('body').scrollTop() and el.offset().top < ($bbug('body').scrollTop() + $bbug(window).height())

    scrollToCallback = (evnt) ->
      if evnt == "page:loaded" && viewportSize.isXS() && $bbug('[data-scroll-id="'+AppConfig.uid+'"]').length
        scroll_to_element = $bbug('[data-scroll-id="'+AppConfig.uid+'"]')
      else
        scroll_to_element = $bbug(element)

      current_step = BreadcrumbService.getCurrentStep()

      # if the event is page:loaded or the element is not in view, scroll to it
      if (scroll_to_element)
        if (evnt == "page:loaded" and current_step > 1) or always_scroll or (evnt == "widget:restart") or
          (not isElementInView(scroll_to_element) and scroll_to_element.offset().top != 0)
            if 'parentIFrame' of $window
              parentIFrame.scrollToOffset(0, scroll_to_element.offset().top - GeneralOptions.scroll_offset)
            else
              $bbug("html, body").animate
                scrollTop: scroll_to_element.offset().top - GeneralOptions.scroll_offset
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

# bbAddressMap
# Adds behaviour to select first invalid input
angular.module('BB.Directives').directive 'bbAddressMap', ($document) ->
  restrict: 'A'
  scope: true
  replace: true
  controller: ($scope, $element, $attrs, uiGmapGoogleMapApi) ->

    $scope.isDraggable = $document.width() > 480

    uiGmapGoogleMapApi.then (maps)->
      maps.visualRefresh = true
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



###**
* @ngdoc directive
* @name BB.Directives:bbModal
* @restrict A
* @scope true
*
* @description
* Use with modal templates to ensure modal height does not exceed window height

*
* @example
* <div bb-modal></div>
####
angular.module('BB.Directives').directive 'bbModal', ($window, $bbug, $timeout) ->
  restrict: 'A'
  scope: true
  link: (scope, elem, attrs) ->

    $timeout ->
      elem.parent().parent().parent().css("z-index", 999999)
    ,
    # watch modal height to ensure it does not exceed window height
    deregisterWatcher = scope.$watch ->
      height = elem.height()
      if $bbug(window).width() >= 769
        modal_padding = 200
      else
        modal_padding = 20
      if height > $bbug(window).height()
        new_height = $bbug(window).height() - modal_padding
        elem.css({
          "height": new_height + "px"
          "overflow-y": "scroll"
          })
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
angular.module('BB.Directives').directive 'bbBackgroundImage', () ->
    restrict: 'A'
    scope: true
    link: (scope, el, attrs) ->
      return if !attrs.bbBackgroundImage or attrs.bbBackgroundImage == ""
      killWatch = scope.$watch attrs.bbBackgroundImage, (new_val, old_val) ->
        if new_val
          killWatch()
          el.css('background-image', 'url("' + new_val + '")')


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
* <span bb-capacity-view='event' ticket-type-singular='seat'></span>
* @example_result
* <span bb-capacity-view='event' ticket-type-singular='seat' class='ng-binding'>5 of 10 seats available</span>
####
angular.module('BB.Directives').directive 'bbCapacityView', () ->
  restrict: 'A'
  template: '{{capacity_view_description}}'
  link: (scope, el, attrs) ->
    ticket_type = attrs.ticketTypeSingular || "ticket"
    killWatch = scope.$watch attrs.bbCapacityView, (item) ->
      if item
        killWatch()

        num_spaces_plural = if item.num_spaces > 1 then "s" else ""
        spaces_left_plural = if item.spaces_left > 1 then "s" else ""

        switch item.chain.capacity_view
          when "NUM_SPACES" then scope.capacity_view_description = scope.ticket_spaces = item.num_spaces + " " + ticket_type + num_spaces_plural
          when "NUM_SPACES_LEFT" then scope.capacity_view_description = scope.ticket_spaces = item.spaces_left + " " + ticket_type + spaces_left_plural + " available"
          when "NUM_SPACES_AND_SPACES_LEFT" then scope.capacity_view_description = scope.ticket_spaces = item.spaces_left + " of " + item.num_spaces + " " + ticket_type + num_spaces_plural + " available"



###**
* @ngdoc directive
* @name BB.Directives:bbTimeZone
* @restrict A
* @description
* Timezone name helper
* @param {String} time_zone_name The name of the time zone
* @param {Boolean} is_time_zone_diff Indicates if the users time zone is different to the company time zone
* @example
* <span bb-time-zone ng-show="is_time_zone_diff">All times are shown in {{time_zone_name}}.</span>
* @example_result
* <span bb-time-zone ng-show="is_time_zone_diff">All times are shown in British Summer Time.</span>
####
angular.module('BB.Directives').directive 'bbTimeZone', (GeneralOptions, CompanyStoreService) ->
  restrict: 'A'
  link: (scope, el, attrs) ->
    company_time_zone = CompanyStoreService.time_zone
    scope.time_zone_name = moment().tz(company_time_zone).format('zz')
    #  if not using local time zone and user time zone is not same as companies
    if !GeneralOptions.use_local_time_zone and GeneralOptions.display_time_zone != company_time_zone
      scope.is_time_zone_diff = true

