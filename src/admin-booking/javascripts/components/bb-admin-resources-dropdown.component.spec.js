describe('bbAdminResourcesDropdown component', function () {
    let $componentController = null;
    let $rootScope = null;
    let $scope = null;
    let $q = null;

    let BBAssets = null;
    let assetsDeferred = null;

    let assetPerson = {id: 1, type: 'person', identifier: '1_p'};
    let assetResource = {id: 2, type: 'resource', identifier: '2_r'};

    let assets = [assetPerson, assetResource];

    let ctrl = null;
    let ctrlDependencies = null;

    beforeEach(function () {
        module('BB');
        module('BBAdminBooking');

        inject(function ($injector) {
            $componentController = $injector.get('$componentController');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();

            $q = $injector.get('$q');
            return BBAssets = $injector.get('BBAssets');
        });

        assetsDeferred = $q.defer();
        spyOn(BBAssets, 'getAssets').and.returnValue(assetsDeferred.promise);
        assetsDeferred.resolve(assets);

        return ctrlDependencies = {
            'BBAssets': BBAssets,
            '$rootScope': $rootScope,
            '$scope': $scope
        };
    });

    let createBindings = function (asset) {
        let bindings = {
            '$bbCtrl': {
                $scope: {
                    bb: {
                        current_item: asset
                    }
                }
            }
        };
        return bindings;
    };

    describe('can change dropdown value from "resource" asset to "person" asset', function () {
        beforeEach(function () {
            let ctrlBindings = createBindings({resource: {id: 2}});
            ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings);
            ctrl.$onInit();
            return $rootScope.$apply();
        });

        it('resource is defined before change, id = 2', () => expect(ctrl.$bbCtrl.$scope.bb.current_item.resource.id).toBe(2));

        it('resource is undefined after change', function () {
            ctrl.pickedResource = assetPerson.identifier;
            ctrl.changeResource();
            return expect(ctrl.$bbCtrl.$scope.bb.current_item.resource).toBeUndefined();
        });

        it('person is undefined before change', () => expect(ctrl.$bbCtrl.$scope.bb.current_item.person).toBeUndefined());

        return it('person is defined after change, id = 1', function () {
            ctrl.pickedResource = assetPerson.identifier;
            ctrl.changeResource();
            return expect(ctrl.$bbCtrl.$scope.bb.current_item.person.id).toBe(1);
        });
    });

    describe('can change dropdown value from "person" asset to "resource" asset', function () {
        beforeEach(function () {
            let ctrlBindings = createBindings({person: {id: 1}});
            ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings);
            ctrl.$onInit();
            return $rootScope.$apply();
        });

        it('person is defined before change, id = 1', () => expect(ctrl.$bbCtrl.$scope.bb.current_item.person.id).toBe(1));

        it('person is undefined after change', function () {
            ctrl.pickedResource = assetResource.identifier;
            ctrl.changeResource();
            return expect(ctrl.$bbCtrl.$scope.bb.current_item.person).toBeUndefined();
        });

        it('resource is undefined before change', () => expect(ctrl.$bbCtrl.$scope.bb.current_item.resource).toBeUndefined());

        return it('resource is defined after change, id = 2', function () {
            ctrl.pickedResource = assetResource.identifier;
            ctrl.changeResource();
            return expect(ctrl.$bbCtrl.$scope.bb.current_item.resource.id).toBe(2);
        });
    });

    describe('can undo dropdown selection', function () {
        beforeEach(function () {
            let ctrlBindings = createBindings({person: {id: 1}});
            ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings);
            ctrl.$onInit();
            return $rootScope.$apply();
        });

        it('person is defined before change, id = 1', () => expect(ctrl.$bbCtrl.$scope.bb.current_item.person.id).toBe(1));

        it('resource is undefined before change', () => expect(ctrl.$bbCtrl.$scope.bb.current_item.resource).toBeUndefined());

        it('person is undefined after change', function () {
            ctrl.pickedResource = null;
            ctrl.changeResource();
            return expect(ctrl.$bbCtrl.$scope.bb.current_item.person).toBeUndefined();
        });

        return it('resource is undefined after change', function () {
            ctrl.pickedResource = undefined;
            ctrl.changeResource();
            return expect(ctrl.$bbCtrl.$scope.bb.current_item.resource).toBeUndefined();
        });
    });

    it('adds bbAdminResourcesDropdown:resourceChanged listener when initialising scope', function () {
        let ctrlBindings = createBindings({resource: {id: 2}});
        ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings);
        ctrl.$onInit();
        $rootScope.$apply();
        return expect($scope.$$listenerCount['bbAdminResourcesDropdown:resourceChanged']).toBeDefined();
    });

    return it('removes bbAdminResourcesDropdown:resourceChanged listener when destroying scope', function () {
        let ctrlBindings = createBindings({resource: {id: 2}});
        ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings);
        ctrl.$onInit();
        ctrl.$onDestroy();
        $rootScope.$apply();
        return expect($scope.$$listenerCount['bbAdminResourcesDropdown:resourceChanged']).toBeUndefined();
    });
});
