'use strict';

###**
* @ngdoc service
* @name BB.Models:SurveyQuestion
*
* @description
* Representation of an SurveyQuestion Object
*
* @property {numbet} company_id Cmpany id
* @property {array} questions An array with questions
###

angular.module('BB.Models').factory "SurveyQuestionModel", ($q, $window, BBModel, BaseModel, QuestionModel) ->

  class SurveyQuestion extends QuestionModel
