// Adapted from https://github.com/PM5544/scoped-polyfill

angular.module("BB.Directives").directive('scoped', function ($document, $timeout) {

    this.compat = (function () {
        let DOMStyle;
        let check = document.createElement('style');
        if (typeof check.sheet !== 'undefined') {
            DOMStyle = 'sheet';
        } else if (typeof check.getSheet !== 'undefined') {
            DOMStyle = 'getSheet';
        } else {
            DOMStyle = 'styleSheet';
        }
        let scopeSupported = undefined !== check.scoped;
        document.body.appendChild(check);
        let testSheet = check[DOMStyle];
        if (testSheet.addRule) {
            testSheet.addRule('c', 'blink');
        } else {
            testSheet.insertRule('c{}', 0);
        }
        let DOMRules = testSheet.rules ? 'rules' : 'cssRules';
        let testStyle = testSheet[DOMRules][0];
        try {
            testStyle.selectorText = 'd';
        } catch (e) {
        }
        let changeSelectorTextAllowed = 'd' === testStyle.selectorText.toLowerCase();
        check.parentNode.removeChild(check);
        return {
            scopeSupported,
            rules: DOMRules,
            sheet: DOMStyle,
            changeSelectorTextAllowed
        };
    })();

    let scopeIt = element => {
        let styleNode = element[0];
        let idCounter = 0;
        let sheet = styleNode[this.compat.sheet];
        if (!sheet) {
            return;
        }
        let allRules = sheet[this.compat.rules];
        let par = styleNode.parentNode;
        let id = par.id || (par.id = `scopedByScopedPolyfill_${++idCounter}`);
        let glue = '';
        let index = allRules.length || 0;
        while (par) {
            if (par.id) {
                glue = `#${par.id} ${glue}`;
            }
            par = par.parentNode;
        }
        return (() => {
            let result = [];
            while (index--) {
                let item;
                let rule = allRules[index];
                if (rule.selectorText) {
                    if (!rule.selectorText.match(new RegExp(glue))) {
                        let selector = glue + ' ' + rule.selectorText.split(',').join(`, ${glue}`);
                        selector = selector.replace(/[\ ]+:root/gi, '');
                        if (this.compat.changeSelectorTextAllowed) {
                            item = rule.selectorText = selector;
                        } else {
                            if (!rule.type || (1 === rule.type)) {
                                let styleRule = rule.style.cssText;
                                if (styleRule) {
                                    if (sheet.removeRule) {
                                        sheet.removeRule(index);
                                    } else {
                                        sheet.deleteRule(index);
                                    }
                                    if (sheet.addRule) {
                                        item = sheet.addRule(selector, styleRule);
                                    } else {
                                        item = sheet.insertRule(selector + '{' + styleRule + '}', index);
                                    }
                                }
                            }
                        }
                    }
                }
                result.push(item);
            }
            return result;
        })();
    };

    return {
        restrict: 'A',
        link(scope, element, attrs) {
            scope.scopeSupported = this.compat.scopeSupported;
            if (!this.compat.scopeSupported) {
                return $timeout(() => scopeIt(element));
            }
        },
        controller($scope, $element, $timeout) {
            if (!$scope.scopeSupported) {
                this.updateCss = () =>
                    $timeout(() => scopeIt($element))
                ;
            }
        }
    };
});

