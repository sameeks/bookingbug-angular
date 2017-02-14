// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc filter
 * @name BB.Filters.filter:props
 * @description
 * Does an OR operation
 */
angular.module('BB.Filters').filter('props', function ($translate) {
    'ngInject';
    return function (items, props) {
        let out = [];
        if (angular.isArray(items)) {
            let keys = Object.keys(props);
            items.forEach(function (item) {
                let itemMatches = false;
                let i = 0;
                while (i < keys.length) {
                    let prop = keys[i];
                    let text = props[prop].toLowerCase();

                    if ((item[prop] != null) && ($translate.instant(item[prop]).toString().toLowerCase().indexOf(text) !== -1)) {
                        itemMatches = true;
                        break;
                    }
                    i++;
                }
                if (itemMatches) {
                    out.push(item);
                }
            });
        } else {
// Let the output be the input untouched
            out = items;
        }

        return out;
    };
});

