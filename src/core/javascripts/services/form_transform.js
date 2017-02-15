angular.module('BB.Services').provider('FormTransform', function () {

    let options = {new: {}, edit: {}};

    this.getTransform = (type, model) => options[type][model];

    this.setTransform = (type, model, fn) => options[type][model] = fn;

    this.$get = () => options;

});

