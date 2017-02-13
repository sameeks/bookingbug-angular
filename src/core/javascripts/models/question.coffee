'use strict'


###**
* @ngdoc service
* @name BB.Models:Question
*
* @description
* Representation of an Question Object
*
* @property {integer} company_id The company id
* @property {array} question An array with questions
####


angular.module('BB.Models').factory "QuestionModel", ($q, $filter, BBModel,
  BaseModel, QuestionService) ->

  class Question extends BaseModel

    constructor: (data) ->
      # weirdly quesiton is  not currently initited as a hal object
      super(data)

      if @price
        @price = parseFloat(@price)
      if @_data.default
        @answer=@_data.default
      if @_data.options
        for option in @_data.options
          if option.is_default
            @answer=option.name
          if @hasPrice()
            option.price = parseFloat(option.price)
            currency = if data.currency_code then data.currency_code else 'GBP'
            option.display_name = "#{option.name} (#{$filter('currency')(option.price, currency)})"
          else
            option.display_name = option.name
      if @_data.detail_type == "check" || @_data.detail_type == "check-price"
        @answer =(@_data.default && @_data.default == "1")

      @currentlyShown = true

    ###**
    * @ngdoc method
    * @name hasPrice
    * @methodOf BB.Models:Question
    * @description
    * Check if it contains one of the following: "check-price", "select-price", "radio-price"
    *
    * @returns {boolean} If this contains detail_type
    ###
    hasPrice: ->
      return @detail_type == "check-price" || @detail_type == "select-price"  || @detail_type == "radio-price"

    ###**
    * @ngdoc method
    * @name selectedPrice
    * @methodOf BB.Models:Question
    * @description
    * Select price if detail type si equal with check-price
    *
    * @returns {float} The returned selected price
    ###
    selectedPrice: ->
      return 0 if !@hasPrice()
      if @detail_type == "check-price"
        return (if @answer then @price else 0)
      for option in @_data.options
        return option.price if @answer == option.name
      return 0

    ###**
    * @ngdoc method
    * @name selectedPriceQty
    * @methodOf BB.Models:Question
    * @description
    * Select price quantity if selected price has been selected
    *
    * @returns {object} The returned selected price quantity
    ###
    selectedPriceQty: (qty) ->
      qty ||= 1
      p = @selectedPrice()
      if @price_per_booking
        p = p * qty
      p

    ###**
    * @ngdoc method
    * @name getAnswerId
    * @methodOf BB.Models:Question
    * @description
    * Get answer id
    *
    * @returns {object} The returned answer id
    ###
    getAnswerId: ->
      return null if !@answer || !@options || @options.length == 0
      for o in @options
        return o.id if @answer == o.name
      return null

    ###**
    * @ngdoc method
    * @name showElement
    * @methodOf BB.Models:Question
    * @description
    * Show element
    *
    * @returns {boolean} If element is displayed
    ###
    showElement: ->
      @currentlyShown = true

    ###**
    * @ngdoc hideElement
    * @name showElement
    * @methodOf BB.Models:Question
    * @description
    * Hide element
    *
    * @returns {boolean} If element is hidden
    ###
    hideElement: ->
      @currentlyShown = false

    ###**
    * @ngdoc hideElement
    * @name getPostData
    * @methodOf BB.Models:Question
    * @description
    * Get post data
    *
    * @returns {object} The returned post data
    ###
    getPostData: ->
      x = {}
      x.id = @id
      x.answer = @answer
      x.answer = moment(@answer).toISODate() if @detail_type == "date" && @answer
      p = @selectedPrice()
      x.price = p if p
      x

    @$addAnswersByName: (obj, keys) ->
      QuestionService.addAnswersByName(obj, keys)

    @$addDynamicAnswersByName: (questions) ->
      QuestionService.addDynamicAnswersByName(questions)

    @$addAnswersFromDefaults: (questions, answers) ->
      QuestionService.addAnswersFromDefaults(questions, answers)

    @$checkConditionalQuestions: (questions) ->
      QuestionService.checkConditionalQuestions(questions)

