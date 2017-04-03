angular.module('BB.Models').factory("AdminQueuerPersonModel", function($q,
  AdminPersonService, BBModel, BaseModel, AdminPersonModel) {

    return class Admin_Person extends AdminPersonModel {

        constructor(data) {
            super(data);
            if (!this.queuing_disabled) {
                this.setCurrentCustomer();
            }
        }

        /***
        * @ngdoc method
        * @name setCurrentCustomer
        * @methodOf BB.Models:AdminPerson
        * @description
        * Set current customer
        *
        * @returns {Promise} Returns a promise that rezolve the current customer
        */
        setCurrentCustomer() {
            let defer = $q.defer();
            if (this.$has('queuer')) {
                this.$get('queuer').then(queuer => {
                    this.serving = new BBModel.Admin.Queuer(queuer);
                    return defer.resolve(this.serving);
                }, err => defer.reject(err));
            } else {
                defer.resolve();
            }
            return defer.promise;
        }
  };
});
