// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// Form Data Store Directive  this does very little apart from register the
// widget, so the user's form choices are stored.
angular.module('BB.Directives').directive('bbFormDataStore', FormDataStoreService =>
  //  remove '?' when we change over the bbWidget directive
  ({
    require : '?bbWidget',
    link(scope) {
      return FormDataStoreService.register(scope);
    }
  })
);

