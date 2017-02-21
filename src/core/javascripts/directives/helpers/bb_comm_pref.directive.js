// bbCommPref
angular.module('BB.Directives').directive('bbCommPref', () => {
        return {
            restrict: 'A',
            require: ['ngModel'],
            link(scope, element, attrs, ctrls) {

                let ng_model_ctrl = ctrls[0];

                // get the default communication preference
                let comm_pref = scope.$eval(attrs.bbCommPref) || false;

                // check if it's already been set
                if ((scope.bb.current_item.settings.send_email_followup != null) && (scope.bb.current_item.settings.send_sms_followup != null)) {
                    comm_pref = scope.bb.current_item.settings.send_email_followup;
                } else {
                    // set to the default
                    scope.bb.current_item.settings.send_email_followup = comm_pref;
                    scope.bb.current_item.settings.send_sms_followup = comm_pref;
                }

                // update the model
                ng_model_ctrl.$setViewValue(comm_pref);

                // register a parser to handle model changes
                let parser = function (value) {
                    scope.bb.current_item.settings.send_email_followup = value;
                    scope.bb.current_item.settings.send_sms_followup = value;
                    return value;
                };

                return ng_model_ctrl.$parsers.push(parser);
            }
        };
    }
);
