// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:Question
*
* @description
* Representation of an Question Object
*
* @property {integer} company_id The company id
* @property {array} question An array with questions
*///


angular.module('BB.Models').factory("QuestionModel", ($q, $filter, BBModel,
  BaseModel, QuestionService) =>

  class Question extends BaseModel {

    constructor(data) {
      // weirdly quesiton is  not currently initited as a hal object
      super(data);

      if (this.price) {
        this.price = parseFloat(this.price);
      }
      if (this._data.default) {
        this.answer=this._data.default;
      }
      if (this._data.options) {
        for (let option of Array.from(this._data.options)) {
          if (option.is_default) {
            this.answer=option.name;
          }
          if (this.hasPrice()) {
            option.price = parseFloat(option.price);
            let currency = data.currency_code ? data.currency_code : 'GBP';
            option.display_name = `${option.name} (${$filter('currency')(option.price, currency)})`;
          } else {
            option.display_name = option.name;
          }
        }
      }
      if ((this._data.detail_type === "check") || (this._data.detail_type === "check-price")) {
        this.answer =(this._data.default && (this._data.default === "1"));
      }

      this.currentlyShown = true;
    }

    /***
    * @ngdoc method
    * @name hasPrice
    * @methodOf BB.Models:Question
    * @description
    * Check if it contains one of the following: "check-price", "select-price", "radio-price"
    *
    * @returns {boolean} If this contains detail_type
    */
    hasPrice() {
      return (this.detail_type === "check-price") || (this.detail_type === "select-price")  || (this.detail_type === "radio-price");
    }

    /***
    * @ngdoc method
    * @name selectedPrice
    * @methodOf BB.Models:Question
    * @description
    * Select price if detail type si equal with check-price
    *
    * @returns {float} The returned selected price
    */
    selectedPrice() {
      if (!this.hasPrice()) { return 0; }
      if (this.detail_type === "check-price") {
        return (this.answer ? this.price : 0);
      }
      for (let option of Array.from(this._data.options)) {
        if (this.answer === option.name) { return option.price; }
      }
      return 0;
    }

    /***
    * @ngdoc method
    * @name selectedPriceQty
    * @methodOf BB.Models:Question
    * @description
    * Select price quantity if selected price has been selected
    *
    * @returns {object} The returned selected price quantity
    */
    selectedPriceQty(qty) {
      if (!qty) { qty = 1; }
      let p = this.selectedPrice();
      if (this.price_per_booking) {
        p = p * qty;
      }
      return p;
    }

    /***
    * @ngdoc method
    * @name getAnswerId
    * @methodOf BB.Models:Question
    * @description
    * Get answer id
    *
    * @returns {object} The returned answer id
    */
    getAnswerId() {
      if (!this.answer || !this.options || (this.options.length === 0)) { return null; }
      for (let o of Array.from(this.options)) {
        if (this.answer === o.name) { return o.id; }
      }
      return null;
    }

    /***
    * @ngdoc method
    * @name showElement
    * @methodOf BB.Models:Question
    * @description
    * Show element
    *
    * @returns {boolean} If element is displayed
    */
    showElement() {
      return this.currentlyShown = true;
    }

    /***
    * @ngdoc hideElement
    * @name showElement
    * @methodOf BB.Models:Question
    * @description
    * Hide element
    *
    * @returns {boolean} If element is hidden
    */
    hideElement() {
      return this.currentlyShown = false;
    }

    /***
    * @ngdoc hideElement
    * @name getPostData
    * @methodOf BB.Models:Question
    * @description
    * Get post data
    *
    * @returns {object} The returned post data
    */
    getPostData() {
      let x = {};
      x.id = this.id;
      x.answer = this.answer;
      if ((this.detail_type === "date") && this.answer) { x.answer = moment(this.answer).toISODate(); }
      let p = this.selectedPrice();
      if (p) { x.price = p; }
      return x;
    }

    static $addAnswersByName(obj, keys) {
      return QuestionService.addAnswersByName(obj, keys);
    }

    static $addDynamicAnswersByName(questions) {
      return QuestionService.addDynamicAnswersByName(questions);
    }

    static $addAnswersFromDefaults(questions, answers) {
      return QuestionService.addAnswersFromDefaults(questions, answers);
    }

    static $checkConditionalQuestions(questions) {
      return QuestionService.checkConditionalQuestions(questions);
    }
  }
);

