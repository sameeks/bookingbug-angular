// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
window.Collection.Day = class Day extends window.Collection.Base {

    checkItem(item) {
        return super.checkItem(...arguments);
    }
};


angular.module('BB.Services').provider("DayCollections", () => {
        return {
            $get() {
                return new window.BaseCollections();
            }
        };
    }
);

