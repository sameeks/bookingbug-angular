'use strict'

WidgetStep = (AlertService, BBModel, LoadingService, LoginService, $rootScope, $sce, widgetPage) ->
  'ngInject'

  $scope = null

  setScope = ($s) ->
    $scope = $s;
    return

  guardScope = () ->
    if $scope is null
      throw new Error 'please set scope'

  setStepTitle = (title) ->
    guardScope()
    $scope.bb.steps[$scope.bb.current_step - 1].title = title

  checkStepTitle = (title) ->
    guardScope()
    if $scope.bb.steps[$scope.bb.current_step - 1] and !$scope.bb.steps[$scope.bb.current_step - 1].title
      setStepTitle(title)

  getCurrentStepTitle = ->
    guardScope()
    steps = $scope.bb.steps

    if !_.compact(steps).length or steps.length == 1 and steps[0].number != $scope.bb.current_step
      steps = $scope.bb.allSteps

    if $scope.bb.current_step
      return steps[$scope.bb.current_step - 1].title

  loadStep = (step) ->
    guardScope()
    return if step == $scope.bb.current_step

    $scope.bb.calculatePercentageComplete(step)

    # so actually use the data from the "next" page if there is one - but show the correct page
    # this means we load the completed data from that page
    # if there isn't a next page - then try the select one
    st = $scope.bb.steps[step]
    prev_step = $scope.bb.steps[step - 1]
    prev_step = st if st && !prev_step
    st = prev_step if !st
    if st && !$scope.bb.last_step_reached
      $scope.bb.stacked_items = [] if !st.stacked_length || st.stacked_length == 0
      $scope.bb.current_item.loadStep(st.current_item)
      if $scope.bb.steps.length > 1
        $scope.bb.steps.splice(step, $scope.bb.steps.length - step)
      $scope.bb.current_step = step
      widgetPage.showPage(prev_step.page, true)
    if $scope.bb.allSteps
      for step in $scope.bb.allSteps
        step.active = false
        step.passed = step.number < $scope.bb.current_step
      if $scope.bb.allSteps[$scope.bb.current_step - 1]
        $scope.bb.allSteps[$scope.bb.current_step - 1].active = true

  ###**
  * @ngdoc method
  * @name loadPreviousStep
  * @methodOf BB.Directives:bbWidget
  * @description
  * Loads the previous unskipped step
  *
  * @param {integer} steps_to_go_back: The number of steps to go back
  * @param {string} caller: The method that called this function
  ###
  loadPreviousStep = (caller) ->
    guardScope()
    past_steps = _.reject($scope.bb.steps, (s) -> s.number >= $scope.bb.current_step)

    # Find the last unskipped step
    step_to_load = 0

    while past_steps[0]
      last_step = past_steps.pop()
      if !last_step
        break
      if !last_step.skipped
        step_to_load = last_step.number
        break

    # Remove pages from browser history (sync browser history with routing)
    if $scope.bb.routeFormat

      pages_to_remove_from_history = if step_to_load is 0 then $scope.bb.current_step + 1 else ($scope.bb.current_step - step_to_load)

      # -------------------------------------------------------------------------
      # Reduce number of pages to remove from browser history by one if this
      # method was triggered by Angular's $locationChangeStart broadcast
      # In this instance we can assume that the browser back button was used
      # and one page has already been removed from the history by the browser
      # -------------------------------------------------------------------------
      pages_to_remove_from_history-- if caller is "locationChangeStart"

      window.history.go(pages_to_remove_from_history * -1) if pages_to_remove_from_history > 0

    loadStep(step_to_load) if step_to_load > 0

  loadStepByPageName = (page_name) ->
    guardScope()
    for step in $scope.bb.allSteps
      if step.page == page_name
        return loadStep(step.number)
    return loadStep(1)

  reset = () ->
    guardScope()
    $rootScope.$broadcast 'clear:formData'
    $rootScope.$broadcast 'widget:restart'
    setLastSelectedDate(null)
    $scope.client = new BBModel.Client() if !LoginService.isLoggedIn()
    $scope.bb.last_step_reached = false
    # This is to remove the current step you are on.
    $scope.bb.steps.splice(1)

  restart = () ->
    guardScope()
    reset()
    loadStep(1)

  setLastSelectedDate = (date) =>
    guardScope()
    $scope.last_selected_date = date

  return {
    checkStepTitle: checkStepTitle
    getCurrentStepTitle: getCurrentStepTitle
    loadPreviousStep: loadPreviousStep
    loadStep: loadStep
    loadStepByPageName: loadStepByPageName
    reset: reset
    restart: restart
    setLastSelectedDate: setLastSelectedDate
    setScope: setScope
    setStepTitle: setStepTitle
  }

angular.module('BB').service 'widgetStep', WidgetStep