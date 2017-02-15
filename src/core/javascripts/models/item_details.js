/***
 * @ngdoc service
 * @name BB.Models:ItemDetails
 *
 * @description
 * Representation of an ItemDetails Object
 *
 * @property {string} self The self
 * @property {array} questions The questions
 * @property {array} survey_questions The survey questions
 * @property {string} hasQuestions Has questions about the item details
 * @property {string} hasSurveyQuestions Has survey questions about the item details
 * @property {string} checkConditionalQuestions Check conditional questions about the item details
 *///


angular.module('BB.Models').factory("ItemDetailsModel", ($q, $bbug, ItemDetailsService, BBModel, BaseModel) =>

    class ItemDetails extends BaseModel {

        constructor(data) {
            super(data);
            this._data = data;
            if (this._data) {
                this.self = this._data.$href("self");
            }
            this.questions = [];
            this.survey_questions = [];
            if (data) {
                for (let q of Array.from(data.questions)) {
                    if ((q.outcome) === false) {
                        if (data.currency_code) {
                            q.currency_code = data.currency_code;
                        }
                        this.questions.push(new BBModel.Question(q));
                    } else {
                        this.survey_questions.push(new BBModel.SurveyQuestion(q));
                    }
                }
            }
            this.hasQuestions = (this.questions.length > 0);
            this.hasSurveyQuestions = (this.survey_questions.length > 0);
        }

        /***
         * @ngdoc method
         * @name questionPrice
         * @methodOf BB.Models:ItemDetails
         * @description
         * Get question about price in according of quantity
         *
         * @returns {integer} The returned price
         */
        questionPrice(qty) {
            if (!qty) {
                qty = 1;
            }
            this.checkConditionalQuestions();
            let price = 0;
            for (let q of Array.from(this.questions)) {
                price += q.selectedPriceQty(qty);
            }
            return price;
        }

        /***
         * @ngdoc method
         * @name checkConditionalQuestions
         * @methodOf BB.Models:ItemDetails
         * @description
         * Checks if exist conditional questions
         *
         * @returns {boolean} The returned existing conditional questions
         */
        checkConditionalQuestions() {
            return BBModel.Question.$checkConditionalQuestions(this.questions);
        }

        /***
         * @ngdoc method
         * @name getPostData
         * @methodOf BB.Models:ItemDetails
         * @description
         * Get data
         *
         * @returns {array} The returned data
         */
        getPostData() {
            let data = [];
            for (let q of Array.from(this.questions)) {
                if (q.currentlyShown) {
                    data.push(q.getPostData());
                }
            }
            return data;
        }

        /***
         * @ngdoc method
         * @name setAnswers
         * @methodOf BB.Models:ItemDetails
         * @description
         * Load the answers from an answer set - probably from loading an existing basket item
         *
         * @returns {object} The returned answers set
         */
        // load the answers from an answer set - probably from loading an existing basket item
        setAnswers(answers) {
            // turn answers into a hash
            let ahash = {};
            for (let a of Array.from(answers)) {
                ahash[a.id] = a;
            }

            for (let q of Array.from(this.questions)) {
                if (ahash[q.id]) {  // if we have answer for it
                    q.answer = ahash[q.id].answer;
                }
            }
            return this.checkConditionalQuestions();
        }

        /***
         * @ngdoc method
         * @name getQuestion
         * @methodOf BB.Models:ItemDetails
         * @description
         * Get question about item details by id
         *
         * @returns {object} The returned question
         */
        getQuestion(id) {
            return _.findWhere(this.questions, {id});
        }

        static $query(prms) {
            return ItemDetailsService.query(prms);
        }
    }
);

