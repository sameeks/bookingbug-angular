'use strict'


# bbCommPref
angular.module('BB.Directives').directive 'bbCommPref', () ->
  restrict: 'A'
  require: ['ngModel']
  link: (scope, element, attrs, ctrls) ->

    ng_model_ctrl = ctrls[0]

    # get the default communication preference
    comm_pref = scope.$eval(attrs.bbCommPref) or false

    # check if it's already been set
    if scope.bb.current_item.settings.send_email_followup? and scope.bb.current_item.settings.send_sms_followup?
      comm_pref = scope.bb.current_item.settings.send_email_followup
    else
      # set to the default
      scope.bb.current_item.settings.send_email_followup = comm_pref
      scope.bb.current_item.settings.send_sms_followup   = comm_pref

    # update the model
    ng_model_ctrl.$setViewValue(comm_pref)

    # register a parser to handle model changes
    parser = (value) ->
      scope.bb.current_item.settings.send_email_followup = value
      scope.bb.current_item.settings.send_sms_followup   = value
      value

    ng_model_ctrl.$parsers.push parser
