let service = function($log) {
  'ngInject';

  let currentText = null;

  let lowercase = () => currentText = currentText.toLowerCase();

  let shorten = () => currentText = currentText.substr(0, 10);

  let trim = () => currentText = currentText.trim();

  let sanitize = function(text){
    currentText = text;

    trim();
    shorten();
    lowercase();

    return currentText;
  };

  return {
    sanitize
  };
};

angular
.module('bbTe.blogArticle')
.service('bbTeBaTextSanitizer', service);
