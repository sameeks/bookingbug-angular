// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.

window.Collection.Client = class Client extends window.Collection.Base {

    checkItem(item) {
        return super.checkItem(...arguments);
    }
};

angular.module('BB.Services').provider("ClientCollections", () => {
        return {
            $get() {
                return new window.BaseCollections();
            }
        };
    }
);

