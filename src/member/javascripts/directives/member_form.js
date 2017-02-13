// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc directive
* @name BBMember.directive:memberForm
* @scope
* @restrict E
*
* @description
* Member form, validates & submits a form that represents a member/client
*
* @param {string}    apiUrl              Expexts to be bled through the scope (MUST FIX)
* @param {object}    member              Member object
* @param {function}  onSuccessSave       On save success callback
* @param {function}  onFailSave          On save fail callback
* @param {function}  onValidationError   On validation fail callback
*
*/
angular.module('BBMember').directive('memberForm', ($rootScope, AlertService, PathSvc) =>

    ({
      templateUrl(el, attrs) {
        if (attrs.bbCustomMemberForm != null) {
          return PathSvc.directivePartial("_member_form");
        } else {
          return PathSvc.directivePartial("_member_schema_form");
        }
      },
      scope: {
        apiUrl: '@',
        member: '=',
        onSuccessSave: '=',
        onFailSave: '=',
        onValidationError: '='
      },
      link(scope, element, attrs) {

        if (!$rootScope.bb) { $rootScope.bb = {}; }
        if (!$rootScope.bb.api_url) { $rootScope.bb.api_url = attrs.apiUrl; }
        if (!$rootScope.bb.api_url) { $rootScope.bb.api_url = "http://www.bookingbug.com"; }

        if (attrs.bbCustomMemberForm != null) {
          return scope.custom_member_form = true;
        }
      },

      controller($scope, FormTransform) {

        $scope.loading = true;

        // THIS IS CRUFTY AND SHOULD BE REMOVE WITH AN API UPDATE THAT TIDIES UP THE SCEMA RESPONE
        // fix the issues we have with the the sub client and question blocks being in doted notation, and not in child objects
        let checkSchema = function(schema) {
          for (let k in schema.properties) {
            let v = schema.properties[k];
            let vals = k.split(".");
            if ((vals[0] === "questions") && (vals.length > 1)) {
              if (!schema.properties.questions) { schema.properties.questions = {type: "object", properties: {}}; }
              if (!schema.properties.questions.properties[vals[1]]) { schema.properties.questions.properties[vals[1]] = {type: "object", properties: {answer: v}}; }
            }
            if ((vals[0] === "client") && (vals.length > 2)) {
              if (!schema.properties.client) { schema.properties.client = {type: "object", properties: {q: {type: "object", properties: {}}}}; }
              if (schema.properties.client.properties) {
                if (!schema.properties.client.properties.q.properties[vals[2]]) { schema.properties.client.properties.q.properties[vals[2]] = {type: "object", properties: {answer: v}}; }
              }
            }
          }
          return schema;
        };


        $scope.$watch('member', function(member) {
          if (member != null) {
            if (member.$has('edit_member')) {
              return member.$get('edit_member').then(function(member_schema) {
                $scope.form = member_schema.form;
                let model_type = functionName(member.constructor);
                if (FormTransform['edit'][model_type]) {
                  $scope.form = FormTransform['edit'][model_type]($scope.form, member_schema.schema, member);
                }
                $scope.schema = checkSchema(member_schema.schema);
                return $scope.loading = false;
              });
            } else if (member.$has('edit')) {
              return member.$get('edit').then(function(member_schema) {
                $scope.form = member_schema.form;
                let model_type = functionName(member.constructor);
                if (FormTransform['edit'][model_type]) {
                  $scope.form = FormTransform['edit'][model_type]($scope.form, member_schema.schema, member);
                }
                $scope.schema = checkSchema(member_schema.schema);
                return $scope.loading = false;
              });
            }
          }
        });




        var functionName = function(func) {
          let result = /^function\s+([\w\$]+)\s*\(/.exec( func.toString() );
          if (result) {
             return result[ 1 ];
          } else {
             return '';
           }
        };


        return $scope.submit = function(form, data) {
          // Required for the fields to validate themselves
          $scope.$broadcast('schemaFormValidate');

          if (form.$valid) {
            $scope.loading = true;
            // --------------------------------------------------------------------
            // member_schema form does not bind the question answers in
            // custom form elements to the Client.questions array of objects
            // but rather to the Client.q array of objects, so for example:
            // Client.q.1.answer <= INSTEAD OF => Client.questions[0].answer
            // So in that case we need to update answers in questions to match
            // the answers in q, so that if a user changes a custom form field
            // the new answer and not the old one will be sent to the api
            // --------------------------------------------------------------------
            if (!$scope.custom_member_form) {
              for (let item of Array.from(data.questions)) {
                item.answer = data.q[item.id].answer;
              }
            }

            return $scope.member.$put('self', {}, data).then(function(member) {
              $scope.loading = false;
              AlertService.raise('UPDATE_SUCCESS');

              if (typeof $scope.onSuccessSave === 'function') {
                return $scope.onSuccessSave();
              }
            }
            , function(err) {
              $scope.loading = false;
              AlertService.raise('UPDATE_FAILED');

              if (typeof $scope.onFailSave === 'function') {
                return $scope.onFailSave();
              }
            });
          } else {
            if (typeof $scope.onValidationError === 'function') {
                return $scope.onValidationError();
              }
          }
        };
      }
    })
);
