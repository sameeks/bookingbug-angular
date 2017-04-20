angular.module('BB.Models').factory("AdminUserModel", ($q, BBModel, BaseModel) => {
    class User extends BaseModel {
    }

    return User;
});

