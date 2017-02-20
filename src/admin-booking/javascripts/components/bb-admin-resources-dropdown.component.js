angular.module('BBAdminBooking').component('bbAdminResourcesDropdown', {
    bindings: {
        formCtrl: '<'
    },
    controller: 'BBAdminResourcesDropdownCtrl',
    controllerAs: '$bbAdminResourcesDropdownCtrl',
    require: {
        $bbCtrl: '^^bbAdminBooking'
    },
    templateUrl: 'admin-booking/admin_resources_dropdown.html'
});

let BBAdminResourcesDropdownCtrl = function (BBAssets, $rootScope, $scope) {
    'ngInject';

    let resource;
    this.pickedResource = null;
    this.resources = [];
    this._resourceChangedUnSubscribe = null;

    this.$onInit = () => {
        this.changeResource = changeResource;

        BBAssets.getAssets(this.$bbCtrl.$scope.bb.company).then(setLoadedResources);
        this._resourceChangedUnSubscribe = $scope.$on('bbAdminResourcesDropdown:resourceChanged', resourceChangedListener);
    };

    this.$onDestroy = () => {
        this._resourceChangedUnSubscribe();
    };

    var resourceChangedListener = event => {
        if (this.pickedResource == null) {
            delete this.$bbCtrl.$scope.bb.current_item.resource;
            delete this.$bbCtrl.$scope.bb.current_item.person;
            return;
        }

        let type = this.pickedResource.split('_')[1];
        for (let resourceKey = 0; resourceKey < this.resources.length; resourceKey++) {
            resource = this.resources[resourceKey];
            if (resource.identifier === this.pickedResource) {
                if (type === 'p') {
                    this.$bbCtrl.$scope.bb.current_item.person = resource;
                    this.pickedResource = resource;
                    delete this.$bbCtrl.$scope.bb.current_item.resource;
                } else if (type === 'r') {
                    this.$bbCtrl.$scope.bb.current_item.resource = resource;
                    this.pickedResource = resource;
                    delete this.$bbCtrl.$scope.bb.current_item.person;
                }
                break;
            }
        }

    };

    /**
     * @param {Array} resources
     */
    var setLoadedResources = resources => {
        this.resources = resources;
        setCurrentResource();
    };

    var setCurrentResource = () => {
        if ((this.$bbCtrl.$scope.bb.current_item.person != null) && (this.$bbCtrl.$scope.bb.current_item.person.id != null)) {
            this.pickedResource = this.$bbCtrl.$scope.bb.current_item.person;
            this.pickedResource.identifier = this.$bbCtrl.$scope.bb.current_item.person.id + '_p';
        } else if ((this.$bbCtrl.$scope.bb.current_item.resource != null) && (this.$bbCtrl.$scope.bb.current_item.resource.id != null)) {
            this.pickedResource = this.$bbCtrl.$scope.bb.current_item.resource;
            this.pickedResource.identifier = this.$bbCtrl.$scope.bb.current_item.resource.id + '_r';
        }

    };

    var changeResource = () => {
        $rootScope.$broadcast('bbAdminResourcesDropdown:resourceChanged');
    };

};

angular.module('BBAdminBooking').controller('BBAdminResourcesDropdownCtrl', BBAdminResourcesDropdownCtrl);
