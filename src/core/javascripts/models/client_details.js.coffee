'use strict';

###**
* @ngdoc service
* @name BB.Models:ClientDetails
*
* @description
* Representation of an ClientDetails Object
*
* @property {array} questions Client questions
* @property {number} company_id Client company id
####

angular.module('BB.Models').factory "ClientDetailsModel", ($q, BBModel, BaseModel, ClientDetailsService) ->

  class ClientDetails extends BaseModel

    constructor: (data) ->
      super
      @questions = []
      if @_data
        for q in data.questions
          @questions.push( new BBModel.Question(q))
      @hasQuestions = (@questions.length > 0)

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:ClientDetails
    * @description
    * Gets a list of answers where every list item has an answer, id, and a price.
    *
    * @param {array} questions Questions array
    *
    * @returns {array} An array of question answers.
    ###
    getPostData : (questions) ->
      data = []
      for q in questions
        data.push({answer: q.answer, id: q.id, price: q.price})
      data

    ###**
    * @ngdoc method
    * @name setAnswers
    * @methodOf BB.Models:ClientDetails
    * @description
    * Loads the answers from an answer set.
    *
    * @param {array} answers answers array
    *
    * @returns {array} An array of answers
    ###
    # load the answers from an answer set - probably from loading an existing basket item
    setAnswers: (answers) ->
      # turn answers into a hash
      ahash = {}
      for a in answers
        ahash[a.question_id] = a

      for q in @questions
        if ahash[q.id]  # if we have answer for it
          q.answer = ahash[q.id].answer

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:ClientDetails
    * @description
    * Static function that gets the client details from a company object.
    *
    * @param {object} company Company object
    *
    * @returns {promise} A promise that on success will return the details about a company's clients
    ###
    @$query: (company) ->
      ClientDetailsService.query(company)
