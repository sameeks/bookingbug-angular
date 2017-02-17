describe('BB.Services, PathSvc service', function () {
    let $sce = null;
    let AppConfig = null;

    let $http = null;
    let $httpBackend = null;

    let PathSvc = null;

    let appConfigMock = {
        partial_url: 'some-partial'
    };

    let sampleFileName = 'some-filename';

    let beforeEachFn = function () {
        module('BB');
    };

    beforeEach(beforeEachFn);

    let injectDependencies = function () {
        inject(function ($injector) {
            $sce = $injector.get('$sce');
            AppConfig = $injector.get('AppConfig');
            $http = $injector.get('$http');
            $httpBackend = $injector.get('$httpBackend');
            PathSvc = $injector.get('PathSvc');
        });

        spyOn($sce, 'trustAsResourceUrl').and.callThrough();

    };

    describe('when "partial_url" is not defined in AppConfig', function () {
        let beforeEach2LvlFn = function () {
            module(function ($provide) {
                $provide.value('AppConfig', {});
            });

            injectDependencies();

        };

        beforeEach(beforeEach2LvlFn);

        it('proper url is used', function () {
            let result = PathSvc.directivePartial(sampleFileName);

            expect($sce.trustAsResourceUrl)
                .toHaveBeenCalledWith(sampleFileName + '.html');

            expect(result)
                .toBeDefined();

        });
    });

    describe('when "partial_url" is defined in AppConfig', function () {
        let beforeEach2LvlFn = function () {
            module(function ($provide) {
                $provide.value('AppConfig', appConfigMock);
            });

            injectDependencies();

        };

        beforeEach(beforeEach2LvlFn);

        it('proper url is used', function () {
            let result = PathSvc.directivePartial(sampleFileName);

            expect($sce.trustAsResourceUrl)
                .toHaveBeenCalledWith(appConfigMock['partial_url'] + '/' + sampleFileName + '.html');

            expect(result)
                .toBeDefined();

        });
    });

});
