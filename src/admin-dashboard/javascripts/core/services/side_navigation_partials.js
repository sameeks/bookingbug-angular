/**
 * @ngdoc service
 * @name BBAdminDashboard.SideNavigationPartials
 *
 * @description
 * This service assembles the navigation partials for the side-navigation
 *
 */
angular.module('BBAdminDashboard').factory('SideNavigationPartials', [
    'AdminCoreOptions',
    function (AdminCoreOptions) {
        let templatesArray = [];

        return {
            addPartialTemplate(identifier, partial){
                if (!_.find(templatesArray, item => item.module === identifier)) {
                    templatesArray.push({
                        module: identifier,
                        navPartial: partial
                    });
                }

            },

            removePartialTemplate(identifier) {
                let partial = _.findWhere(templatesArray, {module: identifier});
                let index = _.indexOf(templatesArray, partial);
                templatesArray.splice(index, 1);
            },

            getPartialTemplates(){
                return templatesArray;
            },

            getOrderedPartialTemplates(flat = false){
                let orderedList = [];
                let flatOrderedList = [];

                angular.forEach(AdminCoreOptions.side_navigation, function (group, index) {
                    if (angular.isArray(group.items) && group.items.length) {
                        let newGroup = {
                            group_name: group.group_name,
                            items: []
                        };

                        angular.forEach(group.items, function (item, index) {
                            let existing = _.find(templatesArray, template => template.module === item);

                            if (existing) {
                                flatOrderedList.push(existing);
                                return newGroup.items.push(existing);
                            }
                        });

                        return orderedList.push(newGroup);
                    }
                });

                if (flat) {
                    return flatOrderedList;
                } else {
                    return orderedList;
                }
            }
        };
    }
]);
