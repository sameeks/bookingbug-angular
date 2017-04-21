/***
 * @ngdoc directive
 * @name BB.Directives:bbLogin
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of logins for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {boolean} password_updated The user password updated
 * @property {boolean} password_error The user password error
 * @property {boolean} email_sent The email sent
 * @property {boolean} success If user are log in with success
 * @property {boolean} login_error If user have some errors when try to log in
 * @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
 *///


angular.module('BB.Directives').directive('bbLogin', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'Login'
        };
    }
);
