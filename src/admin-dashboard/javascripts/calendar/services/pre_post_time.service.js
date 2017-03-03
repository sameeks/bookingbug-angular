angular.module('BBAdminDashboard.calendar.services').factory("PrePostTime", ($compile) => {

        return {
            apply(event, elements, view, scope) {
                return (() => {
                    let result = [];
                    for (let e of Array.from(elements)) {
                        let item;
                        let element = angular.element(e);
                        let totalDuration = event.duration + event.pre_time + event.post_time;
                        if (event.pre_time) {
                            switch (view.name) {
                                case "agendaWeek":
                                case "agendaDay": {
                                    let preHeight = (event.pre_time * (element.height() + 2)) / totalDuration;
                                    let pre = $compile(`<div class='pre' style='height:${preHeight}px'></div>`)(scope);
                                    element.prepend(pre);
                                    break;
                                }
                                case "timelineDay": {
                                    let contentDiv = element.children()[0];
                                    let preWidth = (event.pre_time * (element.width() + 2)) / totalDuration;
                                    pre = $compile(`<div class='pre' style='width:${preWidth}px'></div>`)(scope);
                                    element.prepend(pre);
                                    angular.element(contentDiv).css("padding-left", `${preWidth}px`);
                                    break;
                                }
                            }
                        }
                        if (event.post_time) {
                            switch (view.name) {
                                case "agendaWeek":
                                case "agendaDay": {
                                    let postHeight = (event.post_time * (element.height() + 2)) / totalDuration;
                                    let post = $compile(`<div class='post' style='height:${postHeight}px'></div>`)(scope);
                                    item = element.append(post);
                                    break;
                                }
                                case "timelineDay": {
                                    let postWidth = (event.post_time * (element.width() + 2)) / totalDuration;
                                    post = $compile(`<div class='post' style='width:${postWidth}px'></div>`)(scope);
                                    item = element.append(post);
                                    break;
                                }
                            }
                        }
                        result.push(item);
                    }
                    return result;
                })();
            }
        };

    }
);
