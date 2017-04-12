describe('BBAdminDashboard.check-in.directives, bbCheckIn directive', () => {
    let $compile = null;
    let $httpBackend = null;
    let $rootScope = null;
    let bbGridService;

    let compiled = null;

    let directiveDefaultTemplatePath = 'check-in/checkin-table.html';
    let directiveDefaultHtml = `<div bb-check-in api_url="bb.api_url" company="bb.company"></div>`;

    let beforeEachFn = () => {
        module('BBAdminDashboard.check-in.directives');

        module(($provide) => {
             $provide.provider('bbGridService', bbGridService);
        });


        inject(($injector, $provide) => {
            $compile = $injector.get('$compile');
            $httpBackend = $injector.get('$httpBackend');
            $rootScope = $injector.get('$rootScope');
        });

        $httpBackend.whenGET(directiveDefaultTemplatePath).respond(200, '<span>test</span>');

    };

    let afterEachFn = () => {
        $httpBackend.verifyNoOutstandingExpectation();
        return $httpBackend.verifyNoOutstandingRequest();
    };

    beforeEach(beforeEachFn);
    afterEach(afterEachFn);

});


