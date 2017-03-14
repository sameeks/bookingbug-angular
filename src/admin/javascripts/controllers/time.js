angular.module('BBAdmin.Controllers').controller('DashTimeList', function ($scope, $rootScope, $location, $q, $element, AdminTimeService) {

    let k, slots;

    // Add a method that will be available in all retrieved CreditCard objects :
    $scope.init = day => {
        $scope.selected_day = day;
        let elem = angular.element($element);
        elem.attr('id', `tl_${$scope.bb.company_id}`);
        angular.element($element).show();

        let prms = {company_id: $scope.bb.company_id, day};
        if ($scope.service_id) {
            prms.service_id = $scope.service_id;
        }

        let timeListDef = $q.defer();
        $scope.slots = timeListDef.promise;
        prms.url = $scope.bb.api_url;

        $scope.aslots = AdminTimeService.query(prms);
        return $scope.aslots.then(res => {
                $scope.loaded = true;
                slots = {};
                for (let x of Array.from(res)) {
                    if (!slots[x.time]) {
                        slots[x.time] = x;
                    }
                }
                let xres = [];
                for (k in slots) {
                    let slot = slots[k];
                    xres.push(slot);
                }
                return timeListDef.resolve(xres);
            }
        );
    };

    if ($scope.selected_day) {
        $scope.init($scope.selected_day);
    }

    $scope.format_date = fmt => {
        return $scope.selected_date.format(fmt);
    };

    $scope.selectSlot = (slot, route) => {
        $scope.pickTime(slot.time);
        $scope.pickDate($scope.selected_date);
        return $location.path(route);
    };

    $scope.highlighSlot = slot => {
        $scope.pickTime(slot.time);
        $scope.pickDate($scope.selected_date);
        return $scope.setCheckout(true);
    };

    $scope.clear = () => {
        $scope.loaded = false;
        $scope.slots = null;
        return angular.element($element).hide();
    };

    return $scope.popupCheckout = slot => {
        let item = {
            time: slot.time,
            date: $scope.selected_day.date,
            company_id: $scope.bb.company_id,
            duration: 30,
            service_id: $scope.service_id,
            event_id: slot.id
        };
        let url = "/booking/new_checkout?";
        for (k in item) {
            let v = item[k];
            url += (k + "=" + v + "&");
        }
        let wWidth = $(window).width();
        let dWidth = wWidth * 0.8;
        let wHeight = $(window).height();
        let dHeight = wHeight * 0.8;
        let dlg = $("#dialog-modal");
        dlg.html(`<iframe frameborder=0 id='mod_dlg' onload='nowait();setTimeout(set_iframe_focus, 100);' width=100% height=99% src='${url}'></iframe>`);
        dlg.attr("title", "Checkout");
        return dlg.dialog({
            my: "top", at: "top",
            height: dHeight,
            width: dWidth,
            modal: true,
            overlay: {opacity: 0.1, background: "black"},
        });
    };
});

