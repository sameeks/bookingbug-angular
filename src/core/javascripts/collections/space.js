window.Collection.Space = class Space extends window.Collection.Base {

    checkItem(item) {
        return super.checkItem(...arguments);
    }
};


angular.module('BB.Services').provider("SpaceCollections", () => {
        return {
            $get() {
                return new window.BaseCollections();
            }
        };
    }
);

