// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory('QuestionService', function ($window, QueryStringService, $bbug) {

    // grab url params
    let defaults = QueryStringService() || {};

    let convertDates = obj =>
            _.each(obj, function (val, key) {
                let date = $window.moment(obj[key]);
                if (_.isString(obj[key]) && date.isValid()) {
                    return obj[key] = date;
                }
            })
        ;


    //  store any values from $window.bb_setup if it exists
    if ($window.bb_setup) {
        convertDates($window.bb_setup);
        angular.extend(defaults, $window.bb_setup);
    }


    // adds an answer property to a question object if the id of the question
    // matches the id of the values stored in the defaults object. this would
    // almost defintiely be used to get values from the querystring i.e.
    // ?14393=Wedding&14392=true
    let addAnswersById = function (questions) {
        if (!questions) {
            return;
        }

        if (angular.isArray(questions)) {
            return _.each(questions, function (question) {
                let id = question.id + '';

                if (!question.answer && defaults[id]) {
                    return question.answer = defaults[id];
                }
            });
        } else {

            if (defaults[questions.id + '']) {
                return questions.answer = defaults[questions.id + ''];
            }
        }
    };


    // converts a string to a clean, snake case string. it's used to convert
    // question names into snake case so they can be accessed using the object dot
    // notation and match any values set using $window.bb_set_up
    let convertToSnakeCase = function (str) {
        str = str.toLowerCase();
        str = $.trim(str);
        // replace all punctuation and special chars
        str = str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '');
        // replace any double or more spaces
        str = str.replace(/\s{2,}/g, ' ');
        // convert to sanke case
        str = str.replace(/\s/g, '_');
        return str;
    };


    // takes an array of questions objects. loops through the questions gettting
    // the obj.name value and converting it into snake case. then loop through the
    // stored value key name and see if there is whole or partial match.
    let addDynamicAnswersByName = function (questions) {
        if (angular.isArray(questions)) {
            let keys = _.keys(defaults);

            return _.each(questions, function (question) {
                let name = convertToSnakeCase(question.name);
                return _.each(keys, function (key) {
                    if ((name.indexOf(`_${key}`) >= 0) || (name.indexOf(`_${key}_`) >= 0) || (name.indexOf(`${key}_`) >= 0)) {
                        if (defaults[key] && !question.answer) {
                            question.answer = defaults[key];
                            delete defaults[key];
                        }
                    }
                });
            });
        }
    };


    // takes an object and array of key names. it loops through key names and if
    // they match the key names in the stored values, then the values are added to
    // calling obj.
    let addAnswersByName = function (obj, keys) {
        let type = Object.prototype.toString.call(obj).slice(8, -1);

        if ((type === 'Object') && angular.isArray(keys)) {
            for (let key of Array.from(keys)) {
                // only add property to calling object if it doesn't have a property
                if (defaults[key] && !obj[key]) {
                    obj[key] = defaults[key];
                    // remove it once it's set otherwise there could be a lot of issues
                    delete defaults[key];
                }
            }
            return;
        }
    };


    // takes an array of questions and an answers hash which then matches answers either
    // by thier key name and the questions help_text value or by question id
    let addAnswersFromDefaults = (questions, answers) =>
            (() => {
                let result = [];
                for (let question of Array.from(questions)) {
                    let item;
                    let name = question.help_text;
                    if (answers[name]) {
                        question.answer = answers[name];
                    }
                    if (answers[question.id + '']) {
                        item = question.answer = answers[question.id + ''];
                    }
                    result.push(item);
                }
                return result;
            })()
        ;


    let storeDefaults = obj => angular.extend(defaults, obj.bb_setup || {});


    let checkConditionalQuestions = questions =>
            (() => {
                let result = [];
                for (let q of Array.from(questions)) {
                    let item;
                    if (q.settings && q.settings.conditional_question) {
                        let cond = findByQuestionId(questions, parseInt(q.settings.conditional_question));
                        if (cond) {
                            // check if the question has an answer which means "show"
                            let ans = cond.getAnswerId();
                            let found = false;
                            if ($bbug.isEmptyObject(q.settings.conditional_answers) && (cond.detail_type === "check") && !cond.answer) {
                                // this is messy - we're showing the question when we ahve a checkbox conditional, based on it being unticked
                                found = true;
                            }

                            for (let a in q.settings.conditional_answers) {
                                let v = q.settings.conditional_answers[a];
                                if ((a[0] === 'c') && (parseInt(v) === 1) && cond.answer) {
                                    found = true;
                                } else if ((parseInt(a) === ans) && (parseInt(v) === 1)) {
                                    found = true;
                                }
                            }
                            if (found) {
                                item = q.showElement();
                            } else {
                                item = q.hideElement();
                            }
                        }
                    }
                    result.push(item);
                }
                return result;
            })()
        ;


    var findByQuestionId = function (questions, qid) {
        for (let q of Array.from(questions)) {
            if (q.id === qid) {
                return q;
            }
        }
        return null;
    };


    return {
        getStoredData() {
            return defaults;
        },

        storeDefaults,
        addAnswersById,
        addAnswersByName,
        addDynamicAnswersByName,
        addAnswersFromDefaults,
        convertToSnakeCase,
        checkConditionalQuestions
    };
});

