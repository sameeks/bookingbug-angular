/***
 * @ngdoc directive
 * @name BB.Directives:bbTimeRanges
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of time rangers for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @param {hash}  bbTimeRanges A hash of options
 * @property {string} selected_slot The selected slot
 * @property {date} selected_date The selected date
 * @property {string} postcode The postcode
 * @property {date} original_start_date The original start date
 * @property {date} start_at_week_start The start at week start
 * @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
 *///


angular.module('BB.Directives').directive('bbTimeRanges', ($q, $templateCache, $compile, $timeout, $bbug) => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            priority: 1,
            transclude: true,
            controller: 'TimeRangeList',
            link(scope, element, attrs, controller, transclude) {
                // focus on continue button after slot selected - for screen readers
                scope.$on('time:selected', function () {
                    let btn = angular.element('#btn-continue');
                    btn[0].disabled = false;
                    $timeout(() =>
                            $bbug("html, body").animate(
                                {scrollTop: btn.offset().top}
                                , 500)

                        , 1000);
                    return $timeout(() => btn[0].focus()
                        , 1500);
                });

                // date helpers
                scope.today = moment().toDate();
                scope.tomorrow = moment().add(1, 'days').toDate();

                scope.options = scope.$eval(attrs.bbTimeRanges) || {};

                return transclude(scope, clone => {

                        // if there's content compile that or grab the week_calendar template
                        let has_content = (clone.length > 1) || ((clone.length === 1) && (!clone[0].wholeText || /\S/.test(clone[0].wholeText)));

                        if (has_content) {
                            return element.html(clone).show();
                        } else {
                            return $q.when($templateCache.get('_week_calendar.html')).then(function (template) {
                                element.html(template).show();
                                return $compile(element.contents())(scope);
                            });
                        }
                    }
                );
            }
        }
    }
);
