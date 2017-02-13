window.Collection.Day = class Day extends window.Collection.Base {

  checkItem(item) {
    return super.checkItem(...arguments);
  }
};


angular.module('BB.Services').provider("DayCollections", () =>
  ({
    $get() {
      return new  window.BaseCollections();
    }
  })
);

