'use strict';

###**
* @ngdoc service
* @name BB.Models:Answer
*
* @description
* Representation of an Answer Object
*
* @property {string} question Question that corresponds with answer
####

angular.module('BB.Models').factory "AnswerModel", ($q, BBModel, BaseModel, $bbug) ->

  class Answer extends BaseModel
    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name getQuestion
    * @methodOf BB.Models:Answer
    * @description
    * Gets the question.
    *
    * @returns {promise} A promise that will be resolved to a response question object when the request succeeds
    ###
    getQuestion: () ->
      defer = $q.defer()
      defer.resolve(@question) if @question
      if @_data.$has('question')
        @_data.$get('question').then (question) =>
          @question = question
          defer.resolve(@question)
      else
        defer.resolve([])
      defer.promise

