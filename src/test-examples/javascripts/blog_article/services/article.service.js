// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
let service = function($log) {
  'ngInject';
  class BbTeBlogArticle {
    constructor(title, content) {
      if (title == null) { title = 'default title'; }
      if (content == null) { content = 'default content'; }
      this.title = title;
      this.content = content;
    }

    getTitle() {
      return this.title;
    }

    setTitle(title) {
      this.title = title;
    }
  }

  return BbTeBlogArticle;
};

angular
.module('bbTe.blogArticle')
.service('BbTeBaBlogArticle', service);
