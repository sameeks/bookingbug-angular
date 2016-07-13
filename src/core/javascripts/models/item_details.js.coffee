'use strict'


###**
* @ngdoc service
* @name BB.Models:ItemDetails
*
* @description
* Representation of an ItemDetails Object
*
* @property {string} self The self
* @property {array} questions The questions
* @property {array} survey_questions The survey questions
* @property {string} hasQuestions Has questions about the item details
* @property {string} hasSurveyQuestions Has survey questions about the item details
* @property {string} checkConditionalQuestions Check conditional questions about the item details
####


angular.module('BB.Models').factory "ItemDetailsModel", ($q, $bbug,
  ItemDetailsService, BBModel, BaseModel) ->

  class ItemDetails extends BaseModel

    constructor: (data) ->
      @_data = data
      if @_data
        @self = @_data.$href("self")
      @questions = []
      @survey_questions = []
      if data
        for q in data.questions
          if (q.outcome) == false
            if data.currency_code then q.currency_code = data.currency_code
            @questions.push( new BBModel.Question(q))
          else
            @survey_questions.push( new BBModel.SurveyQuestion(q))
      @hasQuestions = (@questions.length > 0)
      @hasSurveyQuestions = (@survey_questions.length > 0)

    ###**
    * @ngdoc method
    * @name questionPrice
    * @methodOf BB.Models:ItemDetails
    * @description
    * Get question about price in according of quantity
    *
    * @returns {integer} The returned price
    ###
    questionPrice: (qty) ->
      qty ||= 1
      @checkConditionalQuestions()
      price = 0
      for q in @questions
        price += q.selectedPriceQty(qty)
      price

    ###**
    * @ngdoc method
    * @name checkConditionalQuestions
    * @methodOf BB.Models:ItemDetails
    * @description
    * Checks if exist conditional questions
    *
    * @returns {boolean} The returned existing conditional questions
    ###
    checkConditionalQuestions: () ->
      BBModel.Question.$checkConditionalQuestions(@questions)

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:ItemDetails
    * @description
    * Get data
    *
    * @returns {array} The returned data
    ###
    getPostData: ->
      data = []
      for q in @questions
        data.push(q.getPostData()) if q.currentlyShown
      data

    ###**
    * @ngdoc method
    * @name setAnswers
    * @methodOf BB.Models:ItemDetails
    * @description
    * Load the answers from an answer set - probably from loading an existing basket item
    *
    * @returns {object} The returned answers set
    ###
    # load the answers from an answer set - probably from loading an existing basket item
    setAnswers: (answers) ->
      # turn answers into a hash
      ahash = {}
      for a in answers
        ahash[a.id] = a

      for q in @questions
        if ahash[q.id]  # if we have answer for it
          q.answer = ahash[q.id].answer
      @checkConditionalQuestions()

    ###**
    * @ngdoc method
    * @name getQuestion
    * @methodOf BB.Models:ItemDetails
    * @description
    * Get question about item details by id
    *
    * @returns {object} The returned question
    ###
    getQuestion: (id) ->
      _.findWhere(@questions, {id: id})

    @$query: (prms) ->
      ItemDetailsService.query(prms)
