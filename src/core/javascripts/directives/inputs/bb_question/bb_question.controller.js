(function () {
    angular.module('BB.Controllers').controller('BBQuestionController', BBQuestionController);

    function BBQuestionController($scope, $compile, $element) {

        this.$onInit = function () {

            this.isTemplate = true;

            setDateFormats();

            if (this.question) determineTemplate();
        };

        this.recalc = () => {
            if (angular.isDefined($scope.recalc_price)) {
                if (!this.question.outcome) {
                    $scope.recalc_price();
                }
            }
            if (angular.isDefined($scope.recalc_question)) {
                return $scope.recalc_question();
            }
        };

        const setDateFormats = () => {
            this.date_format = 'DD/MM/YYYY';
            this.date_format_2 = 'dd/MM/yyyy';
            if (this.dateFormatLocale === 'US') {
                this.date_format = 'MM/DD/YYYY';
                this.date_format_2 = 'MM/dd/yyyy';
            }
        };

        const determineTemplate = () => {
            this.name = null;
            this.placeholder = '';

            let html = '';

            if (this.defaultPlaceholder) {
                if ((this.question.detail_type === "text_area") || (this.question.detail_type === "text_field")) {
                    if (this.question.default) this.placeholder = this.question.default;
                    if (this.question.answer === this.question.default) this.question.answer = "";
                }
            }

            if ($scope.idmaps && ($scope.idmaps[this.question.detail_type] || $scope.idmaps[this.question.id])) {
                let index = $scope.idmaps[this.question.id] ? this.question.id : this.question.detail_type;
                ({html} = $scope.idmaps[index]);
            } else if ((this.question.detail_type === "select") || (this.question.detail_type === "select-price")) {
                this.templateUrl = "bb-question/_question_select.html";
            } else if (this.question.detail_type === "text_area") {
                this.templateUrl = "bb-question/_question_text_area.html";
            } else if (this.question.detail_type === "radio") {
                this.templateUrl = "bb-question/_question_radio.html";
            } else if (this.question.detail_type === "check") {
                // stop the duplication of question names for muliple checkboxes by
                // checking the question name against the previous question name.
                this.name = this.question.name;
                this.templateUrl = "bb-question/_question_check.html";
            } else if (this.question.detail_type === "check-price") {
                this.templateUrl = "bb-question/_question_check_price.html";
            } else if (this.question.detail_type === "radio-price") {
                this.templateUrl = "bb-question/_question_radio_price.html";
            } else if (this.question.detail_type === "date") {
                this.templateUrl = "bb-question/_question_date.html";
            } else {
                this.templateUrl = "bb-question/_question_default.html"
            }

            compileTemplate(html);
        };

        const compileTemplate = (html) => {
            if (!html) return;

            this.isTemplate = false;
            $compile(html)($scope, (cloned, $scope) => {
                    $element.replaceWith(cloned);
                }
            );
        };
    }

})(angular);
