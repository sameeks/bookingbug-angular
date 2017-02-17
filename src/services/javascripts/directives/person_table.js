angular.module('BBAdminServices').directive('personTable', function ($log, ModalForm,
                                                                     BBModel) {

    let controller = function ($scope) {

        $scope.fields = ['id', 'name', 'mobile'];

        $scope.getPeople = () =>
            BBModel.Admin.Person.$query({company: $scope.company}).then(people => $scope.people = people)
        ;

        $scope.newPerson = () =>
            ModalForm.new({
                company: $scope.company,
                title: 'New Person',
                new_rel: 'new_person',
                post_rel: 'people',
                success(person) {
                    return $scope.people.push(person);
                }
            })
        ;

        $scope.delete = person =>
            person.$del('self').then(() => $scope.people = _.reject($scope.people, person)
                , err => $log.error("Failed to delete person"))
        ;

        $scope.edit = person =>
            ModalForm.edit({
                model: person,
                title: 'Edit Person'
            })
        ;

        return $scope.schedule = person =>
            person.$get('schedule').then(schedule =>
                ModalForm.edit({
                    model: schedule,
                    title: 'Edit Schedule'
                })
            )
            ;
    };

    let link = function (scope, element, attrs) {
        if (scope.company) {
            return scope.getPeople();
        } else {
            return BBModel.Admin.Company.$query(attrs).then(function (company) {
                scope.company = company;
                return scope.getPeople();
            });
        }
    };

    return {
        controller,
        link,
        templateUrl: 'person_table_main.html'
    };
});

