angular.module('BBAdmin').config(function ($logProvider) {
    'ngInject';

    $logProvider.debugEnabled(true);
});

angular.module('BB').config(function (FormTransformProvider) {
    'ngInject';

    FormTransformProvider.setTransform('edit', 'Admin_Booking', function (form, schema, model) {
        let disable_list;
        if (model && (model.status === 3)) { // blocked - don't disable the datetime
            disable_list = ['service', 'person_id', 'resource_id'];
        } else {
            disable_list = ['datetime', 'service', 'person_id', 'resource_id'];
        }

        if (form[0].tabs) {
            _.each(form[0].tabs[0].items, function (item) {
                if (_.indexOf(disable_list, item.key) > -1) {
                    return item.readonly = true;
                }
            });
        } else {
            _.each(form, function (item) {
                if (_.indexOf(disable_list, item.key) > -1) {
                    return item.readonly = true;
                }
            });
        }
        return form;
    });

});
