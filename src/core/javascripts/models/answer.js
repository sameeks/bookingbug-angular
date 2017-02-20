/***
 * @ngdoc service
 * @name BB.Models:Answer
 *
 * @description
 * Representation of an Answer Object
 *
 * @property {string} question The question that the answer belongs to
 *///


angular.module('BB.Models').factory("AnswerModel", ($q, BBModel, BaseModel, $bbug) =>

    class Answer extends BaseModel {
        constructor(data) {
            super(data);
        }

        /***
         * @ngdoc method
         * @name getQuestion
         * @methodOf BB.Models:Answer
         * @description
         * Build an array of questions
         *
         * @returns {promise} A promise for the question/s
         */
        getQuestion() {
            let defer = $q.defer();
            if (this.question) {
                defer.resolve(this.question);
            }
            if (this._data.$has('question')) {
                this._data.$get('question').then(question => {
                        this.question = question;
                        return defer.resolve(this.question);
                    }
                );
            } else {
                defer.resolve([]);
            }
            return defer.promise;
        }
    }
);

