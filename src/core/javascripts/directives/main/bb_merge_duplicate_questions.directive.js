angular.module('BB.Directives').directive('bbMergeDuplicateQuestions', () =>
  ({
    restrict: 'A',
    scope: true,
    controller($scope, $rootScope) {

      $scope.questions = {};

      return $rootScope.$on("item_details:loaded", function() {

        for (let item of Array.from($scope.bb.stacked_items)) {
          if (item.item_details && item.item_details.questions) {
            item.item_details.hide_questions = false;
            for (let question of Array.from(item.item_details.questions)) {
              if ($scope.questions[question.id]) {
                // this is a duplicate, setup clone and hide it
                item.setCloneAnswers($scope.questions[question.id].item);
                item.item_details.hide_questions = true;
                break;
              } else {
                $scope.questions[question.id] = {question, item};
              }
            }
          }
        }

        return $scope.has_questions = _.pluck($scope.questions, 'question').length > 0;
      });
    }
  })
);
