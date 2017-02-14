// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember').directive('memberSsoLogin', ($rootScope, LoginService, $sniffer, $timeout, QueryStringService) =>
    ({
        scope: {
            token: '@memberSsoLogin',
            company_id: '@companyId'
        },
        transclude: true,
        template: `\
<div ng-if='member' ng-transclude></div>\
`,
        link(scope, element, attrs) {
            let options = {
                root: $rootScope.bb.api_url,
                company_id: scope.company_id
            };
            let data = {};
            if (scope.token) {
                data.token = scope.token;
            }
            if (!data.token) {
                data.token = QueryStringService('sso_token');
            }

            if ($sniffer.msie && ($sniffer.msie < 10) && ($rootScope.iframe_proxy_ready === false)) {
                return $timeout(() =>
                        LoginService.ssoLogin(options, data).then(member => scope.member = member)

                    , 2000);
            } else {
                return LoginService.ssoLogin(options, data).then(member => scope.member = member);
            }
        }
    })
);
