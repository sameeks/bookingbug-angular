'use strict'

# This is a customisation of the accordion-group directive in ui bootstrap
# v0.12.0 to fix an issue in ie8. Replace has been changed from true to false

# The accordion-group directive indicates a block of html that will expand and collapse in an accordion
angular.module('BB.Directives').directive 'bbAccordionGroup', () ->

  return {
    require: '^accordion' # We need this directive to be inside an accordion
    restrict: 'EA'
    transclude: true # It transcludes the contents of the directive into the template
    replace: false
    templateUrl: 'template/accordion/accordion-group.html'
    scope:
      heading: '@'
      isOpen: '=?'
      isDisabled: '=?'
    controller: () ->
      this.setHeading = (element) ->
        this.heading = element
    link: (scope, element, attrs, accordionCtrl) ->
      accordionCtrl.addGroup(scope)

      scope.$watch 'isOpen', (value) ->
        if value
          accordionCtrl.closeOthers(scope)
  }

