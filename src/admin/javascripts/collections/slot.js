// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
window.Collection.Slot = class Slot extends window.Collection.Base {

    checkItem(item) {
        return super.checkItem(...arguments);
    }

    matchesParams(item) {
        if (this.params.start_date) {
            if (!this.start_date) {
                this.start_date = moment(this.params.start_date);
            }
            if (this.start_date.isAfter(item.date)) {
                return false;
            }
        }
        if (this.params.end_date) {
            if (!this.end_date) {
                this.end_date = moment(this.params.end_date);
            }
            if (this.end_date.isBefore(item.date)) {
                return false;
            }
        }
        return true;
    }
};


angular.module('BB.Services').provider("SlotCollections", () => {
        return {
            $get() {
                return new window.BaseCollections();
            }
        };
    }
);

