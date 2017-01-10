'use strict'

###*
* @ngdoc service
* @name BB.Services.service:ViewportSize
*
* @description
* Stores the current screen size breakpoint.
###
angular.module('BB.Services').service 'ViewportSize', ($window, $document) ->

  service = @

  ###*
  # @description variable used to store current screen size
  ###
  viewportSize = null

  ###*
  # @description id prefix for span html elements used to determin screen size via bootstrap classes
  ###
  viewportElementIdPrefix = 'viewport_size_'

  ###*
  # @description used to prevent multiple viewport elements being appended to dom
  ###
  isInitialised = false

  ###*
  # @description boolean check for screen sizes
  ###
  state = 
    isXS: false
    isSM: false
    isMD: false
    isLG: false


  ###*
  # @description returns supported bootstrap screen sizes
  # @returns {String}
  ###
  getSupportedSizes = ->
    return ['xs', 'sm', 'md', 'lg']


  ###*
  # @description logic for getting element ids
  # @param {String} size
  # @returns {String}
  ###
  getElementId = (size) ->
    return viewportElementIdPrefix + size


  ###*
  # @description constructs and returns the elements used to determine screen size
  # @returns {String}
  ###
  getViewportElementsToAppend = ->
    viewportElementStrings = '<div id="viewport_size">'
    for size in getSupportedSizes()
      elementId = getElementId(size)
      viewportElementStrings += ' <span id="' + elementId + '"  class="visible-' + size + '">&nbsp;</span>'

    viewportElementStrings += '</div>'
    return viewportElementStrings


  ###*
  # @description appends elements to document body for bootstrap to show or hide
  ###
  appendViewportElementsToDocumentBody = ->
    viewportElements = getViewportElementsToAppend()
    body = $document.find('body')
    body.append(viewportElements)
    return


  ###*
  # @description grabs elements from document after being appended to determin which ones are visible
  # @returns {Array}
  ###
  getViewportElementsFromDocumentBody = ->
    viewportElements = []
    for size in getSupportedSizes()
      viewportElementId = getElementId(size)
      viewportElement = $document[0].querySelector('#' + viewportElementId)
      viewportElements.push(viewportElement)
    return viewportElements


  ###*
  # @description check if element is visible based on styling
  # @param {String} element
  # @returns {boolean}
  ###
  isElementVisible = (element) ->
    return angular.element(element).css('display') != 'none'

  
  ###*
  # @description Gets the bootstrap size from the class name 
  # @param {String} element
  # @returns {String}
  ###
  getSizeFromElement = (element) ->
    className = element.className.match('(visible-[a-zA-Z]*)\\b')[0]
    size = className.replace('visible-', '').trim()
    return size


  ###*
  # @description determins the current size of the screen
  ###
  findVisibleElement = ->
    viewportElements = getViewportElementsFromDocumentBody()
    for viewportElement in viewportElements
      elementSize = getSizeFromElement(viewportElement)
      if isElementVisible(viewportElement)
        viewportSize = elementSize
        state['is' + elementSize.toUpperCase()] = true
      else
        state['is' + elementSize.toUpperCase()] =  false
    return


  ###*
  # @description get screen size when window resize function has been called
  ###
  listenForResize = ->
    angular.element($window).resize ->
      findVisibleElement()
      return
    return

  ###*
  # @description initialise before utilising viewport service
  ###
  init = ->
    if !isInitialised
      appendViewportElementsToDocumentBody()
      findVisibleElement()
      listenForResize()
      isInitialised = true
    return

  ###*
  # @description using function to grab screensize so it cannot be altered outside service
  # @returns {String}
  ###
  getViewportSize = ->
    return viewportSize

  ###*
  # @description boolean check for XS screen size
  ###
  isXS = ->
    return state.isXS

  ###*
  # @description boolean check for SM screen size
  ###
  isSM = ->
    return state.isSM

  ###*
  # @description boolean check for MD screen size
  ###
  isMD = ->
    return state.isMD

  ###*
  # @description boolean check for LG screen size
  ###
  isLG = ->
    return state.isLG

  return {
    init: init
    getViewportSize: getViewportSize
    isXS: isXS
    isSM: isSM
    isMD: isMD
    isLG: isLG
  }
