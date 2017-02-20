/***
 * @ngdoc service
 * @name BB.Models:SurveyQuestion
 *
 * @description
 * Representation of an SurveyQuestion Object
 *
 * @property {integer} company_id The company id
 * @property {array} questions An array with questions
 */

angular.module('BB.Models').factory("SurveyQuestionModel", ($q, $window, BBModel, BaseModel, QuestionModel) => class SurveyQuestion extends QuestionModel {
});

