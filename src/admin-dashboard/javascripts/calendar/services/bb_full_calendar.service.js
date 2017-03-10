angular.module('BBAdminDashboard.calendar.controllers').service('BbFullCalendar',
    function (AdminCalendarOptions, $translate, $filter) {
        'ngInject';

        class BbFullCalendar {
            constructor() {
                this.setOptions();
            }

            setOptions() {
                this.name = 'calendar';
                this.slotDuration = GeneralOptions.calendar_slot_duration;

                this.options = {
                    calendar: {
                        schedulerLicenseKey: '0598149132-fcs-1443104297',
                        eventStartEditable: false,
                        eventDurationEditable: false,
                        height: 'auto',
                        buttonText: {},
                        header: {
                            left: 'today,prev,next',
                            center: 'title',
                            right: 'listDay,timelineDayThirty,agendaWeek,month'
                        },
                        defaultView: 'agendaWeek',
                        views: {
                            listDay: {},
                            agendaWeek: {
                                slotDuration: $filter('minutesToString')(this.slotDuration),
                                groupByDateAndResource: false
                            },
                            month: {
                                eventLimit: 5
                            },
                            timelineDay: {
                                slotDuration: $filter('minutesToString')(this.slotDuration),
                                eventOverlap: false,
                                slotWidth: 25,
                                resourceAreaWidth: '18%'
                            }
                        },
                        resourceGroupField: 'group',
                        resourceLabelText: ' ',
                        eventResourceEditable: true,
                        selectable: true,
                        lazyFetching: false,
                        columnFormat: AdminCalendarOptions.column_format,
                        resources: fcResources,
                        eventDragStop: fcEventDragStop,
                        eventDrop: fcEventDrop,
                        eventClick: fcEventClick,
                        eventRender: fcEventRender,
                        eventAfterRender: fcEventAfterRender,
                        eventAfterAllRender: fcEventAfterAllRender,
                        select: fcSelect,
                        viewRender: fcViewRender,
                        eventResize: fcEventResize,
                        loading: fcLoading
                    }
                };

                this.updateCalendarLanguage();
                this.updateCalendarTimeRange();
            }

            updateCalendarLanguage() {
                this.options.calendar.locale = $translate.use();
                this.options.calendar.buttonText.today = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.TODAY');
                this.options.calendar.views.listDay.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.TODAY');
                this.options.calendar.views.agendaWeek.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.WEEK');
                this.options.calendar.views.month.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.MONTH');
                this.options.calendar.views.timelineDay.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.DAY',
                    {minutes: this.slotDuration}
                );
            }

            updateCalendarTimeRange() {
                this.options.calendar.minTime = AdminCalendarOptions.minTime;
                this.options.calendar.maxTime = AdminCalendarOptions.maxTime;
            }

            /**
             * @param {string} view ['agendaWeek'|'timelineDay']
             */
            setDefaultView(view) {
                this.options.calendar.defaultView = view;
            }

            /**
             * @param {string} views CSV e.g. 'timelineDay,listDay,timelineDayThirty,agendaWeek,month'
             */
            setHeaderRightViews(views) {
                this.options.calendar.header.right = views
            }

            /**
             * @param {string} name
             */
            setName(name) {
                this.name = name;
            }

            /**
             * @param {number} slotDuration Number of minutes
             */
            setSlotDuration(slotDuration) {
                this.slotDuration = slotDuration;

                this.options.calendar.views.agendaWeek.slotDuration = $filter('minutesToString')(this.slotDuration);
                this.options.calendar.views.timelineDay.slotDuration = $filter('minutesToString')(this.slotDuration);
                this.updateCalendarLanguage();
            }

            fcResources = (callback) => {
                return getCalendarAssets(callback);
            }


        }

        return BbFullCalendar;
    }
);
