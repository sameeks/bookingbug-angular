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

  ###
  # @description variable used to store current screen size
  ###
  viewport_size = null

  ###
  # @description id prefix for span html elements used to determin screen size via bootstrap classes
  ###
  viewport_element_id_prefix = 'viewport_size_'

  ###
  # @description used to prevent multiple viewport elements being appended to dom
  ###
  is_initialised = false


  ###
  # @description supported bootstrap screen sizes
  # also used to created dynamic methods in the format
  # service.isXS() / service.isSM() / etc.
  # @param {String} size
  # @returns {String}
  ###
  getSupportedSizes = ->
    return ['xs', 'sm', 'md', 'lg']


  ###
  # @description logic for getting element ids
  # @param {String} size
  # @returns {String}
  ###
  getElementId = (size) ->
    return viewport_element_id_prefix + size


  ###
  # @description constructs and returns the elements used to determine screen size
  # @returns {String}
  ###
  getViewportElementsToAppend = ->
    # opening parent tag
    viewport_element_strings = '<div id="viewport_size">'
    for size in getSupportedSizes()
      element_id = getElementId(size)
      viewport_element_strings += ' <span id="' + element_id + '"  class="visible-' + size + '">&nbsp;</span>'

    # closing parent tag
    viewport_element_strings += '</div>'
    return viewport_element_strings


  ###
  # @description appends elements to document body for bootstrap to show or hide
  ###
  appendViewportElementsToDocumentBody = ->
    viewport_elements = getViewportElementsToAppend()
    body = $document.find('body')
    body.append(viewport_elements)
    return


  ###
  # @description grabs elements from document after being appended to determin which ones are visible
  # @returns {Array}
  ###
  getViewportElementsFromDocumentBody = ->
    viewport_elements = []
    for size in getSupportedSizes()
      viewport_element_id = getElementId(size)
      viewport_element = document.querySelector('#' + viewport_element_id)
      viewport_elements.push(viewport_element)
    return viewport_elements


  ###
  # @description check if element is visible based on styling
  # @param {String} element
  # @returns {boolean}
  ###
  isElementVisible = (element) ->
    return element and element.style.display != 'none' and element.offsetWidth and element.offsetHeight

  
  ###
  # @description Gets the bootstrap size from the class name 
  # @param {String} element
  # @returns {String}
  ###
  getSizeFromElement = (element) ->
    class_name = element.className.match('(visible-[a-zA-Z]*)\\b')[0]
    size = class_name.replace('visible-', '').trim()
    return size


  ###
  # @description determins the current size of the screen and generates dynamic functions
  ###
  findVisibleElement = ->
    viewport_elements = getViewportElementsFromDocumentBody()
    for viewport_element in viewport_elements
      element_size = getSizeFromElement(viewport_element)
      if isElementVisible(viewport_element)
        viewport_size = element_size
        # dynamically created function to return true for current screensize 
        service['is' + element_size.toUpperCase()] = -> return true
      else
        # dynamically created function to return false for screensize 
        service['is' + element_size.toUpperCase()] = -> return false
    return


  ###
  # @description get screen size when window resize function has been called
  ###
  listenForResize = ->
    angular.element($window).resize ->
      findVisibleElement()
      return
    return


  ################## 
  # PUBLIC METHODS #
  ##################

  # Dynamically generated methods (see findVisibleElement)
  # service.isXS
  # service.isSM
  # service.isMD
  # service.isLG

  ###
  # @description initialise before utilising viewport service
  ###
  service.init = ->
    if !is_initialised
      appendViewportElementsToDocumentBody()
      findVisibleElement()
      listenForResize()
      is_initialised = true
    return

  ###
  # @description using function to grab screensize so it cannot be altered outside service
  # @returns {String}
  ###
  service.getViewportSize = ->
    return viewport_size


  return
