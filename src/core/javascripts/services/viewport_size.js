/**
 * @ngdoc service
 * @name BB.Services.service:viewportSize
 *
 * @description
 * Stores the current screen size breakpoint.
 */
angular.module('BB.Services').service('viewportSize', function ($window, $document, $rootScope) {

    /**
     * @description variable used to store current screen size
     */
    let viewportSize = null;

    /**
     * @description id prefix for span html elements used to determin screen size via bootstrap classes
     */
    let viewportElementIdPrefix = 'viewport_size_';

    /**
     * @description used to prevent multiple viewport elements being appended to dom
     */
    let isInitialised = false;

    /**
     * @description boolean check for screen sizes
     */
    let state = {
        isXS: false,
        isSM: false,
        isMD: false,
        isLG: false
    };


    /**
     * @description returns supported bootstrap screen sizes
     * @returns {String}
     */
    let getSupportedSizes = () => ['xs', 'sm', 'md', 'lg'];


    /**
     * @description logic for getting element ids
     * @param {String} size
     * @returns {String}
     */
    let getElementId = size => viewportElementIdPrefix + size;


    /**
     * @description constructs and returns the elements used to determine screen size
     * @returns {String}
     */
    let getViewportElementsToAppend = function () {
        let viewportElementStrings = '<div id="viewport_size">';
        for (let size of Array.from(getSupportedSizes())) {
            let elementId = getElementId(size);
            viewportElementStrings += ` <span id="${elementId}"  class="visible-${size}">&nbsp;</span>`;
        }

        viewportElementStrings += '</div>';
        return viewportElementStrings;
    };


    /**
     * @description appends elements to bb element for bootstrap to show or hide
     */
    let appendViewportElementsToBBElement = function () {
        let viewportElements = getViewportElementsToAppend();
        let bb = $document.find('#bb');
        bb.append(viewportElements);
    };


    /**
     * @description grabs elements from document after being appended to determin which ones are visible
     * @returns {Array}
     */
    let getViewportElementsFromDocument = function () {
        let viewportElements = [];
        for (let size of Array.from(getSupportedSizes())) {
            let viewportElementId = getElementId(size);
            let viewportElement = $document[0].querySelector(`#${viewportElementId}`);
            viewportElements.push(viewportElement);
        }
        return viewportElements;
    };


    /**
     * @description check if element is visible based on styling
     * @param {String} element
     * @returns {boolean}
     */
    let isElementVisible = element => angular.element(element).css('display') !== 'none';


    /**
     * @description Gets the bootstrap size from the class name
     * @param {String} element
     * @returns {String}
     */
    let getSizeFromElement = function (element) {
        let className = element.className.match('(visible-[a-zA-Z]*)\\b')[0];
        let size = className.replace('visible-', '').trim();
        return size;
    };


    /**
     * @description determins the current size of the screen
     */
    let findVisibleElement = function () {
        let viewportElements = getViewportElementsFromDocument();
        for (let viewportElement of Array.from(viewportElements)) {
            let elementSize = getSizeFromElement(viewportElement);
            if (isElementVisible(viewportElement)) {
                viewportSize = elementSize;
                state[`is${elementSize.toUpperCase()}`] = true;
            } else {
                state[`is${elementSize.toUpperCase()}`] = false;
            }
        }
    };


    /**
     * @description get screen size when window resize function has been called
     */
    let listenForResize = function () {
        angular.element($window).resize(function () {
            let viewportSizeOld = viewportSize;
            findVisibleElement();
            if (viewportSizeOld !== viewportSize) {
                $rootScope.$broadcast('viewportSize:changed');
            }
        });
    };

    /**
     * @description initialise before utilising viewport service
     */
    let init = function () {
        if (!isInitialised) {
            appendViewportElementsToBBElement();
            findVisibleElement();
            listenForResize();
            isInitialised = true;
        }
    };

    /**
     * @description using function to grab screensize so it cannot be altered outside service
     * @returns {String}
     */
    let getViewportSize = () => viewportSize;

    /**
     * @description boolean check for XS screen size
     */
    let isXS = () => state.isXS;

    /**
     * @description boolean check for SM screen size
     */
    let isSM = () => state.isSM;

    /**
     * @description boolean check for MD screen size
     */
    let isMD = () => state.isMD;

    /**
     * @description boolean check for LG screen size
     */
    let isLG = () => state.isLG;

    return {
        init,
        getViewportSize,
        isXS,
        isSM,
        isMD,
        isLG
    };
});
