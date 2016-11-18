'use strict'

###
* @ngdoc service
* @name BB.Services.service:ViewportSize
*
* @description
* Stores the current screen size breakpoint.
###
angular.module('BB.Services').service 'ViewportSize', ($window, $document, $rootScope) ->

  viewport_size = null

  size_strings = ['xs', 'sm', 'md', 'lg']
  viewport_element_id_prefix = 'viewport_'


  # returns the elements used to determine screen size
  getViewportElementsToAppend = () ->
    viewport_element_strings = []
    for size in size_strings
      viewport_element_strings.push(
        '<span id="' + viewport_element_id_prefix + size + '"  class="visible-' + size + '">&nbsp;</span>'
      )
    return angular.element(viewport_element_strings)


  # appends elements to body for bootstrap to show / hide
  appendViewportElementsToDocumentBody = () ->
    viewport_elements = getViewportElementsToAppend()

    body = $document.find('body')
    body.append(viewport_elements)

    return


  # elements need to be selected from document to access which ones are visible
  getViewportElementsFromDocumentBody = () ->


    debugger


    viewport_elements = []
    for size in size_strings
      viewport_element_id = viewport_element_id_prefix + size
      viewport_element = angular.element(document.querySelector('#' + viewport_element_id))
      viewport_elements.push(viewport_element)
    return viewport_elements


  isElementVisible = (element) ->
    return element && element.style.display != 'none' && element.offsetWidth && element.offsetHeight


  getSizeFromElement = (element) ->
    return element.className[8..10]


  calculateCurrentSize = () ->

    
    debugger


    viewport_elements = getViewportElementsFromDocumentBody()
    for viewport_element in viewport_elements
      if isElementVisible(viewport_element)
        viewport_size = getSizeFromElement(viewport_element)

    return 


  # TODO - this function should be depricated
  # setViewportSize: (size) ->
  #   if size != viewport_size
  #     viewport_size = size
  #     $rootScope.$broadcast 'ViewportSize:changed'


  @getViewportSize = () ->
    return viewport_size


  appendViewportElementsToDocumentBody()


  resizeTimeout = null
  angular.element($window).bind 'resize', () =>
    $window.clearTimeout(resizeTimeout)
    resizeTimeout = setTimeout () ->

      
      # TCTODO - remove
      console.log 'resize called'


      calculateCurrentSize()
      return
    , 50
    return 


  angular.element($window).bind 'load', () =>

    
    # TCTODO - remove
    console.log 'load called'


    calculateCurrentSize()
    return

  return




