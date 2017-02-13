window.Collection.Client = class Client extends window.Collection.Base {

  checkItem(item) {
    return super.checkItem(...arguments);
  }
};


angular.module('BB.Services').provider("ClientCollections", () =>
  ({
    $get() {
      return new  window.BaseCollections();
    }
  })
);

