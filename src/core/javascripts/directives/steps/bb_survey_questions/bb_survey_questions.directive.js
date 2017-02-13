// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbSurveyQuestions
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of survey questions for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {integer} company_id The company id
* @property {array} questions An array with questions
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
* @property {object} widget The widget service - see {@link BB.Models:BBWidget Widget Service}
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
*///

angular.module('BB.Directives').directive('bbSurveyQuestions', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope: true,
    controller : 'SurveyQuestions'
  })
);
