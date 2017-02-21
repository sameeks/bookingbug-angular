/***
 * @ngdoc directive
 * @name BB.Directives:bbModal
 * @restrict A
 * @scope true
 *
 * @description
 * Use with modal templates to ensure modal height does not exceed window height

 *
 * @example
 * <div bb-modal></div>
 *///
angular.module('BB.Directives').directive('bbModal', ($window, $bbug, $timeout) => {
        return {
            restrict: 'A',
            scope: true,
            link(scope, elem, attrs) {

                let deregisterWatcher;
                return $timeout(() => elem.parent().parent().parent().css("z-index", 999999)
                    ,
                    // watch modal height to ensure it does not exceed window height
                    deregisterWatcher = scope.$watch(function () {
                        let modal_padding;
                        let height = elem.height();
                        if ($bbug(window).width() >= 769) {
                            modal_padding = 200;
                        } else {
                            modal_padding = 20;
                        }
                        if (height > $bbug(window).height()) {
                            let new_height = $bbug(window).height() - modal_padding;
                            elem.css({
                                "height": new_height + "px",
                                "overflow-y": "scroll"
                            });
                            return deregisterWatcher();
                        }
                    })
                );
            }
        };
    }
);
