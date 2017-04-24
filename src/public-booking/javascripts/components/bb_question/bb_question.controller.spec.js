describe('bbQuestion directive', function () {
    let $scope = null;
    let $controller = null;
    let $bbQuestionCtrl = null;
    let $compile = null;
    let $element = null;

    beforeEach(function () {
        module('BB');

        inject(function ($injector) {
            $scope = $injector.get('$rootScope');
            $controller = $injector.get('$controller');
            $compile = $injector.get('$compile');
            $element = angular.element('<div bb-question></div>');
        });
    });

    describe('question defaults', function () {

        it('sets placeholder for question detail type text_area', function () {

            const question = {
                detail_type: 'text_area',
                default: "placeholder text for text_area"
            };

            const data = {
                question: question,
                defaultPlaceholder: true
            };

            $bbQuestionCtrl = $controller('BBQuestionController', {
                $scope: $scope,
                $compile: $compile,
                $element: $element
            }, data);
            $bbQuestionCtrl.$onInit();

            expect($bbQuestionCtrl.placeholder).toEqual(question.default);

        });

        it('sets placeholder for question detail type text_field', function () {
            const question = {
                detail_type: 'text_field',
                default: "placeholder text for text_field"
            };

            const data = {
                question: question,
                defaultPlaceholder: true
            };

            $bbQuestionCtrl = $controller('BBQuestionController', {
                $scope: $scope,
                $compile: $compile,
                $element: $element
            }, data);
            $bbQuestionCtrl.$onInit();

            expect($bbQuestionCtrl.placeholder).toEqual(question.default);
        });

        it('clears question answer if same as default', function () {

            const defaultAnswer = 'default answer for question';

            const question = {
                detail_type: 'text_field',
                default: defaultAnswer,
                answer: defaultAnswer
            };

            const data = {
                question: question,
                defaultPlaceholder: true
            };

            $bbQuestionCtrl = $controller('BBQuestionController', {
                $scope: $scope,
                $compile: $compile,
                $element: $element
            }, data);
            $bbQuestionCtrl.$onInit();

            expect($bbQuestionCtrl.question.answer).not.toEqual(question.default);
            expect($bbQuestionCtrl.question.answer).toEqual('');
            expect(question.answer).toEqual('');
        });
    });

    describe('re-calculations', function () {

        it('calls recalc_price function if set', function () {
            $scope.recalc_price = function () {
            };

            const question = {};

            const data = {
                question: question
            };

            spyOn($scope, 'recalc_price');

            $bbQuestionCtrl = $controller('BBQuestionController', {
                $scope: $scope,
                $compile: $compile,
                $element: $element
            }, data);
            $bbQuestionCtrl.$onInit();

            $bbQuestionCtrl.recalc();

            expect($scope.recalc_price).toHaveBeenCalled();
        });

        it('calls recalc_question function if set', function () {
            $scope.recalc_question = function () {
            };

            const question = {};

            const data = {
                question: question
            };

            spyOn($scope, 'recalc_question');

            $bbQuestionCtrl = $controller('BBQuestionController', {
                $scope: $scope,
                $compile: $compile,
                $element: $element
            }, data);
            $bbQuestionCtrl.$onInit();

            $bbQuestionCtrl.recalc();

            expect($scope.recalc_question).toHaveBeenCalled();
        });
    });

    describe('templates', function () {

        describe('standard questions', function () {

            it('requests template for default', function () {
                const question = {
                    detail_type: ''
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_default.html');
            });

            it('requests template for select', function () {
                const question = {
                    detail_type: 'select'
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_select.html');
            });

            it('requests template for select-price', function () {
                const question = {
                    detail_type: 'select-price'
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_select.html');
            });

            it('requests template for text_area', function () {
                const question = {
                    detail_type: 'text_area'
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_text_area.html');
            });

            it('requests template for radio', function () {
                const question = {
                    detail_type: 'radio'
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_radio.html');
            });

            it('requests template for check', function () {
                const question = {
                    detail_type: 'check'
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_check.html');
            });

            it('requests template for check-price', function () {
                const question = {
                    detail_type: 'check-price'
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_check_price.html');
            });

            it('requests template for radio-price', function () {
                const question = {
                    detail_type: 'radio-price'
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_radio_price.html');
            });

            it('requests template for date', function () {
                const question = {
                    detail_type: 'date'
                };

                const data = {
                    question: question
                };

                $bbQuestionCtrl = $controller('BBQuestionController', {
                    $scope: $scope,
                    $compile: $compile,
                    $element: $element
                }, data);
                $bbQuestionCtrl.$onInit();

                expect($bbQuestionCtrl.templateUrl).toEqual('bb-question/_question_date.html');
            });
        });
    });
});
