describe('BBAdminDashboard.check-in.directives, bbCheckIn directive', () => {
    let $httpBackend = null;
    let bbGridService;

    let directiveDefaultTemplatePath = 'check-in/checkin-table.html';

    let beforeEachFn = () => {
        module('BBAdminDashboard.check-in.directives');

        module(($provide) => {
             $provide.provider('bbGridService', bbGridService);
        });


        inject(($injector, $provide) => {
            $httpBackend = $injector.get('$httpBackend');
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


