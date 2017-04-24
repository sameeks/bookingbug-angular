angular.module('BBQueue').config(function (AdminCoreOptionsProvider) {
    'ngInject';

    AdminCoreOptionsProvider.setOption('side_navigation', [
    {
        group_name: 'SIDE_NAV_QUEUING',
        items: ['queue']
    }, {
        group_name: 'SIDE_NAV_BOOKINGS',
        items: ['calendar', 'clients']
    }, {
        group_name: 'SIDE_NAV_CONFIG',
        items: ['config-iframe', 'publish-iframe', 'settings-iframe']
    }
    ]);
});
