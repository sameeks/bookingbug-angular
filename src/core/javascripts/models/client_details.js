/***
* @ngdoc service
* @name BB.Models:ClientDetails
*
* @description
* Representation of an ClientDetails Object
*
* @property {array} questions Questions of the client
* @property {integer} company_id The company id of the client company
*///


angular.module('BB.Models').factory("ClientDetailsModel", ($q, BBModel,
  BaseModel, ClientDetailsService) =>

  class ClientDetails extends BaseModel {

    constructor(data) {
      super(...arguments);
      this.questions = [];
      if (this._data) {
        for (let q of Array.from(data.questions)) {
          this.questions.push( new BBModel.Question(q));
        }
      }
      this.hasQuestions = (this.questions.length > 0);
    }


    /***
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:ClientDetails
    * @description
    * Get post data from client details according to questions
    *
    * @returns {object} The returned data
    */
    getPostData(questions) {
      let data = [];
      for (let q of Array.from(questions)) {
        data.push({answer: q.answer, id: q.id, price: q.price});
      }
      return data;
    }


    /***
    * @ngdoc method
    * @name setAnswers
    * @methodOf BB.Models:ClientDetails
    * @description
    * Set answers of the client details in function of answers
    *
    * @returns {object} The returned answers
    */
    // load the answers from an answer set - probably from loading an existing basket item
    setAnswers(answers) {
      // turn answers into a hash
      let ahash = {};
      for (let a of Array.from(answers)) {
        ahash[a.question_id] = a;
      }

      return (() => {
        let result = [];
        for (let q of Array.from(this.questions)) {
          let item;
          if (ahash[q.id]) {  // if we have answer for it
            item = q.answer = ahash[q.id].answer;
          }
          result.push(item);
        }
        return result;
      })();
    }

    static $query(company) {
      return ClientDetailsService.query(company);
    }
  }
);

