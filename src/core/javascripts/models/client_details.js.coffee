'use strict';


###**
* @ngdoc service
* @name BB.Models:ClientDetails
*
* @description
* Representation of an ClientDetails Object
*
* @property {array} questions Questions of the client
* @property {integer} company_id The company id of the client company
####


angular.module('BB.Models').factory "ClientDetailsModel", ($q, BBModel, BaseModel) ->

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
    * Get post data from client details according to questions
    *
    * @returns {object} The returned data
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
    * Set answers of the client details in function of answers
    *
    * @returns {object} The returned answers
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
