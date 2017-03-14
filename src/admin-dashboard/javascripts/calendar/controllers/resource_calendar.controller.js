angular.module('BBAdminDashboard.calendar.controllers').controller('bbResourceCalendarController',
    function (AdminBookingPopup, AdminCalendarOptions, AdminCompanyService, AdminMoveBookingPopup, $attrs, BBAssets,
              BBModel, $bbug, CalendarEventSources, ColorPalette, Dialog, $filter, GeneralOptions, ModalForm, PrePostTime,
              ProcessAssetsFilter, $q, $rootScope, $scope, $state, TitleAssembler, $translate, $window, uiCalendarConfig,
              BbFullCalendar) {
        'ngInject';

        this.$onInit = () => {

            this.bbFullCalendar = new BbFullCalendar();

            setBBFullCalendar();

            this.assets = this.bbFullCalendar.assets;
            this.selectedResources = this.bbFullCalendar.selectedResources;
            this.eventSources = this.bbFullCalendar.eventSources;
            this.uiCalOptions = {};
            this.uiCalOptions.calendar = this.bbFullCalendar.calendar;
            this.changeSelectedResources = this.bbFullCalendar.changeSelectedResources;
            this.updateDateHandler = this.bbFullCalendar.updateDateHandler;


           // $scope.$watch(() => this.bbFullCalendar.showAll, () => this.assets = this.bbFullCalendar.showAll);

            this.showAll = this.bbFullCalendar.showAll; //TODO
            this.calendar_name = this.bbFullCalendar.name; //TODO
            this.loading = this.bbFullCalendar.loading; //TODO
            this.assets = this.bbFullCalendar.assets; //TODO
            this.currentDate = this.bbFullCalendar.currentDate; //TODO
            this.calendarLoading = this.bbFullCalendar.calendarLoading; //TODO

            $scope.$watch('bbFullCalendar.selectedResources.selected', selectedResourcesListener);
            $scope.$on('refetchBookings', this.bbFullCalendar.refetchBooking.bind(this.bbFullCalendar));
            $scope.$on('newCheckout', this.bbFullCalendar.refetchBooking.bind(this.bbFullCalendar));
            $scope.$on('BBLanguagePicker:languageChanged', this.bbFullCalendar.updateCalendarLanguage.bind(this.bbFullCalendar));
            $scope.$on('CalendarEventSources:timeRangeChanged', this.bbFullCalendar.updateCalendarTimeRange.bind(this.bbFullCalendar));
        };

        const selectedResourcesListener = (newValue, oldValue) => {
            if (newValue === oldValue) return;

            let assets = [];

            angular.forEach(newValue,
                (asset) => {
                    assets.push(asset.id)
                }
            );

            let {params} = $state;
            params.assets = assets.join();
            $state.go($state.current.name, params, {notify: false, reload: false});

        };

        const setBBFullCalendar = () => {

            let calOptions = $scope.$eval($attrs.bbResourceCalendar);
            if (!calOptions) calOptions = {};

            if (!calOptions.defaultView) {
                if ($scope.model) {
                    this.bbFullCalendar.setDefaultView('agendaWeek');
                } else {
                    this.bbFullCalendar.setDefaultView('timelineDay');
                }
            }

            if (!calOptions.views) {
                if ($scope.model) {
                    this.bbFullCalendar.setHeaderRightViews('listDay,timelineDayThirty,agendaWeek,month');
                } else {
                    this.bbFullCalendar.setHeaderRightViews('timelineDay,listDay,timelineDayThirty,agendaWeek,month');
                }
            }

            if (calOptions.name) this.bbFullCalendar.setName(calOptions.name);
            if (calOptions.type != null) this.bbFullCalendar.setType(calOptions.type);
            if (calOptions.cal_slot_duration != null) this.bbFullCalendar.setSlotDuration(calOptions.cal_slot_duration);
            if (calOptions.enforce_schedules != null) this.bbFullCalendar.setEnforceSchedules(calOptions.enforce_schedules);

            if ($state.params.assets != null) this.bbFullCalendar.setRequestedAssets();

            if ($scope.labelAssembler != null) this.bbFullCalendar.setBookingsLabelAssembler($scope.labelAssembler);
            if ($scope.blockLabelAssembler != null) this.bbFullCalendar.setBlockLabelAssembler($scope.blockLabelAssembler);
            if ($scope.externalLabelAssembler != null) this.bbFullCalendar.setExternalLabelAssembler($scope.blockLabelAssembler);
            if ($scope.model) this.bbFullCalendar.setModel($scope.model);

            this.bbFullCalendar.setScope($scope);//TODO
            this.bbFullCalendar.setAttrs($attrs);//TODO
        };
    }
);
