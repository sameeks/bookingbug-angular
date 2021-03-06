angular.module('BBAdmin').filter('rag', () =>

    function (value, v1, v2) {
        if (value <= v1) {
            return "red";
        } else if (value <= v2) {
            return "amber";
        } else {
            return "green";
        }
    }
);



angular.module('BBAdmin').filter('gar', () =>

    function (value, v1, v2) {
        if (value <= v1) {
            return "green";
        } else if (value <= v2) {
            return "amber";
        } else {
            return "red";
        }
    }
);


angular.module('BBAdmin').filter('time', $window =>

    v => $window.sprintf("%02d:%02d", Math.floor(v / 60), v % 60)
);

