(function (angular) {

    angular.module('BBAdminDashboard.callCenter').provider('adminCallCenterOptions', AdminCallCenterOptions);

    function AdminCallCenterOptions() {

        let options = {
            useDefaultStates: true,
            showInNavigation: true,
            parentState: 'root'
        };

        this.setOption = function (option, value) {
            if (options.hasOwnProperty(option)) {
                options[option] = value;
            }
        };

        this.getOption = function (option) {
            if (options.hasOwnProperty(option)) {
                return options[option];
            }
        };
        this.$get = () => options;

    }

})(angular);
