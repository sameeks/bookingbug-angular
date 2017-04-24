angular.module('BB.Directives').directive('bbQuestion', ($compile, $timeout, $templateRequest, $templateCache) => {
    return {
        replace: true,
        transclude: true,
        restrict: 'A',
        bindToController: {
            question: '=bbQuestion',
            adminRequired: '=bbAdminRequired',
            dateFormatLocale: '=bbDateFormat',
            defaultPlaceholder: '='
        },
        template: "<div ng-if=\"$bbQuestionCtrl.isTemplate\"><div ng-include=\"$bbQuestionCtrl.templateUrl\"></div></div>",
        controller: 'BBQuestionController',
        controllerAs: '$bbQuestionCtrl'
    };
});
