// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember', [
    'BB',
    'BBMember.Directives',
    'BBMember.Services',
    'BBMember.Filters',
    'BBMember.Controllers',
    'BBMember.Models',
    'trNgGrid',
    'pascalprecht.translate'
]);


angular.module('BBMember.Directives', []);

angular.module('BBMember.Filters', []);

angular.module('BBMember.Models', []);

angular.module('BBMember.Services', [
    'ngResource',
    'ngSanitize'
]);

angular.module('BBMember.Controllers', [
    'ngSanitize'
]);

angular.module('BBMemberMockE2E', ['BBMember', 'BBAdminMockE2E']);
