// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Directives').directive('bbAdminSsoLogin', ($rootScope,
  BBModel, QueryStringService, halClient) =>

  ({
    restrict: 'EA',
    scope: {
      token: '@bbAdminSsoLogin',
      companyId: '@',
      apiUrl: '@'
    },
    transclude: true,
    template: `\
<div ng-if='admin' ng-transclude></div>\
`,

    link(scope, element, attrs) {
      let api_host;
      scope.qs = QueryStringService;
      let data = {};
      if (scope.qs) { data.token = scope.qs('sso_token'); }
      if (scope.token) { if (!data.token) { data.token = scope.token; } }
      if (scope.apiUrl) { api_host = scope.apiUrl; }
      if (!api_host) { api_host = $rootScope.bb.api_url; }
      let url = `${api_host}/api/v1/login/admin_sso/${scope.companyId}`;
      return halClient.$post(url, {}, data).then(function(login) {
        let params = {auth_token: login.auth_token};
        return login.$get('administrator', params).then(function(admin) {
          scope.admin = admin;
          return BBModel.Admin.Login.$setLogin(admin);
        });
      });
    }
  })
);

