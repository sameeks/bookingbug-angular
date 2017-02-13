// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc service
* @name BBAdminDashboard.login.services.service:SideNavigationPartials
*
* @description
* This service contains the logged in user's information
*
*/
angular.module('BBAdminDashboard.login.services').factory('LoggedAdmin', [
  'AdminLoginOptions', '$q',
  function(AdminLoginOptions, $q) {
    let loggedAdmin = {
      user               : null,
      adminAccountsArray : null,
      departmentsArray   : null,
      currentCompany     : null
    };

    return {
      setUser(user) {
        loggedAdmin.user = user;
      },
      getUser() {
        return loggedAdmin.user;
      },
      setCurrentCompany(company) {
        loggedAdmin.currentCompany = company;
        // if current company changes departments have to be refetched
        loggedAdmin.departmentsArray = null;
      },
      getCurrentCompany() {
        let deferred = $q.defer();

        if (loggedAdmin.currentCompany != null) {
          deferred.resolve(loggedAdmin.currentCompany);
          return deferred.promise;
        }

        if (loggedAdmin.user == null) {
          deferred.reject(new Error('LOGGED_ADMIN.ERROR_NO_USER_PROVIDED'));
          return deferred.promise;
        }

        if (loggedAdmin.user.$has('company')) {
          loggedAdmin.user.getCompanyPromise().then(function(company) {
            loggedAdmin.currentCompany = company;
            return deferred.resolve(loggedAdmin.currentCompany);
          }
          , err=> deferred.reject(new Error('LOGGED_ADMIN.ERROR_ISSUE_WITH_COMPANY')));
        }

        return deferred.promise;
      },

      getAdminAccounts() {
        let deferred = $q.defer();

        if (loggedAdmin.adminAccountsArray != null) {
          deferred.resolve(loggedAdmin.adminAccountsArray);
          return deferred.promise;
        }

        if (loggedAdmin.user == null) {
          deferred.reject(new Error('LOGGED_ADMIN.ERROR_NO_USER_PROVIDED'));
          return deferred.promise;
        }

        if (loggedAdmin.user.$has('administrators')) {
          loggedAdmin.user.getAdministratorsPromise().then(function(adminAccounts) {
            loggedAdmin.adminAccountsArray = administrators;
            return deferred.resolve(loggedAdmin.adminAccountsArray);
          }
          , err => deferred.reject(new Error('LOGGED_ADMIN.ERROR_COULD_NOT_GET_ADMINS')));
        } else {
          loggedAdmin.adminAccountsArray = [];
          deferred.resolve(loggedAdmin.adminAccountsArray);
        }

        return deferred.promise;
      },

      getDepartments() {
        let deferred = $q.defer();

        if (loggedAdmin.departmentsArray != null) {
          deferred.resolve(loggedAdmin.departmentsArray);
          return deferred.promise;
        }

        if (loggedAdmin.user == null) {
          deferred.reject(new Error('LOGGED_ADMIN.ERROR_NO_USER_PROVIDED'));
          return deferred.promise;
        }

        this.getCurrentCompany().then(function(company){
          if (company.companies && (company.companies.length > 0)) {
            loggedAdmin.departmentsArray = company.companies;
            return deferred.resolve(loggedAdmin.departmentsArray);
          } else {
            loggedAdmin.departmentsArray = [];
            return deferred.resolve(loggedAdmin.departmentsArray);
          }
        }
        , err => deferred.reject(err));

        return deferred.promise;
      }
    };
  }
]);