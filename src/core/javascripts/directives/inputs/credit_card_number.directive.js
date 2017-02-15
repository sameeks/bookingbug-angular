angular.module('BB.Directives').directive("creditCardNumber", function () {

    let getCardType = function (ccnumber) {
        if (!ccnumber) {
            return '';
        }
        ccnumber = ccnumber.toString().replace(/\s+/g, '');
        if (/^(34)|^(37)/.test(ccnumber)) {
            return "american_express";
        }
        if (/^(62)|^(88)/.test(ccnumber)) {
            return "china_unionpay";
        }
        if (/^30[0-5]/.test(ccnumber)) {
            return "diners_club_carte_blanche";
        }
        if (/^(2014)|^(2149)/.test(ccnumber)) {
            return "diners_club_enroute";
        }
        if (/^36/.test(ccnumber)) {
            return "diners_club_international";
        }
        if (/^(6011)|^(622(1(2[6-9]|[3-9][0-9])|[2-8][0-9]{2}|9([01][0-9]|2[0-5])))|^(64[4-9])|^65/.test(ccnumber)) {
            return "discover";
        }
        if (/^35(2[89]|[3-8][0-9])/.test(ccnumber)) {
            return "jcb";
        }
        if (/^(6304)|^(6706)|^(6771)|^(6709)/.test(ccnumber)) {
            return "laser";
        }
        if (/^(5018)|^(5020)|^(5038)|^(5893)|^(6304)|^(6759)|^(6761)|^(6762)|^(6763)|^(0604)/.test(ccnumber)) {
            return "maestro";
        }
        if (/^5[1-5]/.test(ccnumber)) {
            return "master";
        }
        if (/^4/.test(ccnumber)) {
            return "visa";
        }
        if (/^(4026)|^(417500)|^(4405)|^(4508)|^(4844)|^(4913)|^(4917)/.test(ccnumber)) {
            return "visa_electron";
        }
    };

    let isValid = function (ccnumber) {
        if (!ccnumber) {
            return false;
        }
        ccnumber = ccnumber.toString().replace(/\s+/g, '');
        let len = ccnumber.length;
        let mul = 0;
        let prodArr = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]];
        let sum = 0;
        while (len--) {
            sum += prodArr[mul][parseInt(ccnumber.charAt(len), 10)];
            mul ^= 1;
        }
        return (((sum % 10) === 0) && (sum > 0));
    };

    let linker = (scope, element, attributes, ngModel) =>
            scope.$watch(() => ngModel.$modelValue
                , function (newValue) {
                    ngModel.$setValidity('card_number', isValid(newValue));
                    scope.cardType = getCardType(newValue);
                    if ((newValue != null) && (newValue.length === 16)) {
                        if (ngModel.$invalid) {
                            element.parent().addClass('has-error');
                            return element.parent().removeClass('has-success');
                        } else {
                            element.parent().removeClass('has-error');
                            return element.parent().addClass('has-success');
                        }
                    } else {
                        return element.parent().removeClass('has-success');
                    }
                })
        ;

    return {
        restrict: "C",
        require: "ngModel",
        link: linker,
        scope: {
            'cardType': '='
        }
    };
});
