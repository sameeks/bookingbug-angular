// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbDynamicFooter', ($timeout, $bbug) =>
  function(scope, el, attrs) {

    scope.$on("page:loaded", () => $bbug('.content').css('height', 'auto'));

    scope.$watch(() => $bbug('.content')[0].scrollHeight,
    function(new_val, old_val) {
      if (new_val !== old_val) {
        return scope.setContentHeight();
      }
    });

    scope.setContentHeight = function() {
      $bbug('.content').css('height', 'auto');
      let content_height = $bbug('.content')[0].scrollHeight;
      let min_content_height = $bbug(window).innerHeight() - $bbug('.content').offset().top - $bbug('.footer').height();
      if (content_height < min_content_height) {
        return $bbug('.content').css('height', min_content_height + 'px');
      }
    };

    return $bbug(window).on('resize', () => scope.setContentHeight());
  }
);
