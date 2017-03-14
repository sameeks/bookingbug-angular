describe('widgetModalService', () => {
    let widgetModalService = null;

    beforeEach(() => {
        module('BB');

        return inject($injector => widgetModalService = $injector.get('widgetModalService'));
    });

    // describe('', () => {

    // });
});
