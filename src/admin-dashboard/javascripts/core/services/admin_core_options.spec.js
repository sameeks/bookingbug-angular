describe('BBAdminDashboard, AdminCoreOptions provider', function () {
    let AdminCoreOptionsProviderObj = null;
    let AdminCoreOptions = null;

    let beforeEachFn = function () {
        module('BBAdminDashboard');

        module(function (AdminCoreOptionsProvider) {
            AdminCoreOptionsProviderObj = AdminCoreOptionsProvider;
        });

        inject(function ($injector) {
            AdminCoreOptions = $injector.get('AdminCoreOptions');
        });

    };

    beforeEach(beforeEachFn);

    it('has predefined options', function () {
        let options = AdminCoreOptionsProviderObj.$get();

        expect(options.default_state)
            .toBeDefined();
        expect(options.deactivate_sidenav)
            .toBeDefined();
        expect(options.deactivate_boxed_layout)
            .toBeDefined();
        expect(options.sidenav_start_open)
            .toBeDefined();
        expect(options.boxed_layout_start)
            .toBeDefined();
        expect(options.side_navigation)
            .toBeDefined();

    });


    it('allows to override predefined options', function () {
        let testOptionKey = 'default_state';
        let testOptionOldValue = 'calendar';
        let testOptionNewValue = 'some_value';

        expect(AdminCoreOptionsProviderObj.getOption(testOptionKey))
            .toBe(testOptionOldValue);

        AdminCoreOptionsProviderObj.setOption(testOptionKey, testOptionNewValue);

        expect(AdminCoreOptionsProviderObj.getOption(testOptionKey))
            .toBe(testOptionNewValue);

    });

    it('doesn\'t allow to create new options', function () {
        let newOptionKey = 'some_new_option';
        let newOptionValue = 'some_new_option_value';

        AdminCoreOptionsProviderObj.setOption(newOptionKey, newOptionValue);

        expect(AdminCoreOptionsProviderObj.getOption(newOptionKey))
            .toBeUndefined();

    });

    it('provider @get returns object with available options', function () {
        expect(AdminCoreOptions)
            .toBe(AdminCoreOptionsProviderObj.$get());

    });

});
