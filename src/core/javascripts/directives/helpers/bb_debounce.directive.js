angular.module('BB.Directives').directive('bbDebounce', $timeout => {
        return {
            restrict: 'A',
            link(scope, element, attrs) {
                let delay = 400;
                if (attrs.bbDebounce) {
                    delay = attrs.bbDebounce;
                }

                return element.bind('click', () => {
                        $timeout(() => {
                                return element.attr('disabled', true);
                            }
                            , 0);
                        return $timeout(() => {
                                return element.attr('disabled', false);
                            }
                            , delay);
                    }
                );
            }
        };
    }
);
