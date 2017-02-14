// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').provider('FormTransform', function () {

    let options = {new: {}, edit: {}};

    this.getTransform = (type, model) => options[type][model];

    this.setTransform = (type, model, fn) => options[type][model] = fn;

    this.$get = () => options;

});

