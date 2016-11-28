'use strict'

###
* @ngdoc service
* @name BB.Services.service:ViewportSize
*
* @description
* Stores the current screen size breakpoint.
###
angular.module('BB.Services').service 'ViewportSize', ($window, $document, $rootScope) ->

  service = @

  # variable used to store current screen size
  viewport_size = null

  # id prefix for span html elements used to determin screen size via bootstrap classes
  viewport_element_id_prefix = 'viewport_size_'

  # using function to grab screensize so it cannot be altered outside service
  service.getViewportSize = ->
    return viewport_size

  # supported bootstrap screen sizes
  # also used to created dynamic methods in the format
  # service.isXS() / service.isSM() / etc.
  service.getSupportedSizes = ->
    return ['xs', 'sm', 'md', 'lg']


  # logic for getting element ids
  getElementId = (size) ->
    return viewport_element_id_prefix + size


  # constructs and returns the elements used to determine screen size
  getViewportElementsToAppend = ->
    # opening parent tag
    viewport_element_strings = '<div id="viewport_size">'
    for size in service.getSupportedSizes()
      element_id = getElementId(size)
      viewport_element_strings += ' <span id="' + element_id + '"  class="visible-' + size + '">&nbsp;</span>'

    # closing parent tag
    viewport_element_strings += '</div>'
    return viewport_element_strings


  # appends elements to document body for bootstrap to show or hide
  do appendViewportElementsToDocumentBody = ->
    viewport_elements = getViewportElementsToAppend()
    body = $document.find('body')
    body.append(viewport_elements)
    return


  # grabs elements from document after being appended to determin which ones are visible
  getViewportElementsFromDocumentBody = ->
    viewport_elements = []
    for size in service.getSupportedSizes()
      viewport_element_id = getElementId(size)
      viewport_element = document.querySelector('#' + viewport_element_id)
      viewport_elements.push(viewport_element)
    return viewport_elements


  # check if element is visible based on styling
  isElementVisible = (element) ->
    return element && element.style.display != 'none' && element.offsetWidth && element.offsetHeight


  # gets the bootstrap size from the class name 
  getSizeFromElement = (element) ->
    class_name = element.className.match('(visible-[a-zA-Z]*)\\b')[0]
    size = class_name.replace('visible-', '').trim()
    return size


  # determins the current size of the screen
  do calculateCurrentSize = ->
    viewport_elements = getViewportElementsFromDocumentBody()
    for viewport_element in viewport_elements
      element_size = getSizeFromElement(viewport_element)
      if isElementVisible(viewport_element)
        viewport_size = element_size
        # create function to return true for current screensize 
        service['is' + element_size.toUpperCase()] = -> return true
      else
        # create function to return false for screensize 
        service['is' + element_size.toUpperCase()] = -> return false
    return


  # re-calculate screen size when window resize function has been called
  angular.element($window).resize ->
    calculateCurrentSize()
    return

  return
