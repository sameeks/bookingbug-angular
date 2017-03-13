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
            this.uiCalOptions = {
                calendar: this.bbFullCalendar.calendar
            };
            this.changeSelectedResources = this.bbFullCalendar.changeSelectedResources;
            this.updateDateHandler = this.bbFullCalendar.updateDateHandler;

            this.showAll = this.bbFullCalendar.showAll; //TODO
            this.calendar_name = this.bbFullCalendar.name; //TODO
            this.loading = this.bbFullCalendar.loading; //TODO
            this.assets = this.bbFullCalendar.assets; //TODO
            this.currentDate = this.bbFullCalendar.currentDate; //TODO
            this.calendarLoading = this.bbFullCalendar.calendarLoading; //TODO

            $scope.$watch('selectedResources.selected', selectedResourcesListener);
            $scope.$on('refetchBookings', refetchBookingsHandler);
            $scope.$on('newCheckout', newCheckoutHandler);
            $scope.$on('BBLanguagePicker:languageChanged', this.bbFullCalendar.updateCalendarLanguage.bind(this.bbFullCalendar));
            $scope.$on('CalendarEventSources:timeRangeChanged', this.bbFullCalendar.updateCalendarTimeRange.bind(this.bbFullCalendar));
        };

        const selectedResourcesListener = (newValue, oldValue) => {
            if (newValue !== oldValue) {
                let assets = [];
                angular.forEach(newValue, asset => assets.push(asset.id));

                let {params} = $state;
                params.assets = assets.join();
                $state.go($state.current.name, params, {notify: false, reload: false});
            }
        };


        const refetchBookingsHandler = () => {
            uiCalendarConfig.calendars[this.calendar_name].fullCalendar('refetchEvents');
        };

        const newCheckoutHandler = () => {
            uiCalendarConfig.calendars[this.calendar_name].fullCalendar('refetchEvents');
        };

        const setBBFullCalendar = () => {

            let calOptions = $scope.$eval($attrs.bbResourceCalendar);

            this.bbFullCalendar.setEnforceSchedules(calOptions.enforce_schedules);//TODO

            if (!calOptions) calOptions = {};

            if (!calOptions.defaultView) {
                if ($scope.model) {
                    //calOptions.defaultView = 'agendaWeek';
                    this.bbFullCalendar.setDefaultView('agendaWeek');
                } else {
                    //calOptions.defaultView = 'timelineDay';
                    this.bbFullCalendar.setDefaultView('timelineDay');
                }
            }

            if (!calOptions.views) {
                if ($scope.model) {
                    //calOptions.views = 'listDay,timelineDayThirty,agendaWeek,month';
                    this.bbFullCalendar.setHeaderRightViews('listDay,timelineDayThirty,agendaWeek,month');
                } else {
                    //calOptions.views = 'timelineDay,listDay,timelineDayThirty,agendaWeek,month';
                    this.bbFullCalendar.setHeaderRightViews('timelineDay,listDay,timelineDayThirty,agendaWeek,month');
                }
            }

            console.info(calOptions.name);
            if (calOptions.name) {
                //this.calendar_name = calOptions.name;
                this.bbFullCalendar.setName(calOptions.name);

            }
            /*else {
             //this.calendar_name = "resourceCalendar";
             this.bbFullCalendar.setName("resourceCalendar"); //TODO do we need it?
             }*/

            if (calOptions.cal_slot_duration != null) {
                //calOptions.cal_slot_duration = GeneralOptions.calendar_slot_duration;

                this.bbFullCalendar.setSlotDuration(calOptions.cal_slot_duration);

            }

            if (calOptions.type != null) {
                this.bbFullCalendar.setType(calOptions.type);
            }





            if ($scope.labelAssembler != null) {
                this.bbFullCalendar.setBookingsLabelAssembler($scope.labelAssembler);
            }

            if ($scope.blockLabelAssembler != null) {
                this.bbFullCalendar.setBlockLabelAssembler($scope.blockLabelAssembler);
            }

            if ($scope.externalLabelAssembler != null) {
                this.bbFullCalendar.setExternalLabelAssembler($scope.blockLabelAssembler);
            }

            this.bbFullCalendar.setRequestedAssets($state.params.assets); //TODO

            if ($scope.model) {
                this.bbFullCalendar.setModel($scope.model); //TODO
            }


            this.bbFullCalendar.setModel($scope.model);//TODO
            this.bbFullCalendar.setScope($scope);//TODO
            this.bbFullCalendar.setAttrs($attrs);//TODO



        };
    }
);
