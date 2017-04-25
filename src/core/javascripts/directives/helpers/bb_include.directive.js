angular.module('BB.Directives').directive('bbInclude', ($compile, $rootScope, $analytics) => {
        return {
            link(scope, element, attr) {
                let track_page = (attr.bbTrackPage != null) ? true : false;
                return scope.$watch('bb.path_setup', (newval, oldval) => {
                        if (newval) {
                            element.attr('ng-include', `'${scope.getPartial(attr.bbInclude)}'`);
                            element.attr('bb-include', null);
                            $compile(element)(scope);
                            if (track_page) {
                                $analytics.pageTrack(attr.bbInclude);
                            }
                        }
                    }
                );
            }
        };
    }
);
