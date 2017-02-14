// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminServices').directive('scheduleTable', function (BBModel, $log, ModalForm) {

    let controller = function ($scope) {

        $scope.fields = ['id', 'name', 'mobile'];

        $scope.getSchedules = function () {
            let params =
                {company: $scope.company};
            return BBModel.Admin.Schedule.query(params).then(schedules => $scope.schedules = schedules);
        };

        $scope.newSchedule = () =>
            ModalForm.new({
                company: $scope.company,
                title: 'New Schedule',
                new_rel: 'new_schedule',
                post_rel: 'schedules',
                size: 'lg',
                success(schedule) {
                    return $scope.schedules.push(schedule);
                }
            })
        ;

        $scope.delete = schedule =>
            schedule.$del('self').then(() => $scope.schedules = _.reject($scope.schedules, schedule)
                , err => $log.error("Failed to delete schedule"))
        ;

        return $scope.edit = schedule =>
            ModalForm.edit({
                model: schedule,
                title: 'Edit Schedule',
                size: 'lg'
            })
            ;
    };

    let link = function (scope, element, attrs) {
        if (scope.company) {
            return scope.getSchedules();
        } else {
            return BBModel.Admin.Company.query(attrs).then(function (company) {
                scope.company = company;
                return scope.getSchedules();
            });
        }
    };

    return {
        controller,
        link,
        templateUrl: 'schedule_table_main.html'
    };
});

