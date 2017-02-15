let service = function (bbTeBaTextSanitizer, $http, $log, $q) {
    'ngInject';

    let endpoint = 'http://some.endpoint.com';

    let getArticles = function () {
        let defer = $q.defer();

        $http.get(endpoint + '/article')
            .then(function (response) {
                getArticlesSuccessHandler(defer, response);
            }).catch(function (response) {
            defer.reject('could not load articles');
        });

        return defer.promise;
    };

    var getArticlesSuccessHandler = function (defer, response) {
        let articles = response.data;

        for (let article of Array.from(articles)) {
            (function (article) {
                sanitizeArticle(article);
            })(article);
        }
        defer.resolve(articles);
    };

    let getArticle = function (articleId) {
        let defer = $q.defer();

        $http.get(endpoint + '/article/' + articleId)
            .then(function (response) {
                let article = response.data;
                sanitizeArticle(article);
                defer.resolve(article);
            }).catch(function (response) {
            defer.reject(`could not load article with id:${articleId}`);
        });

        return defer.promise;
    };

    let deleteArticle = function (articleId) {
        let defer = $q.defer();

        $http.delete(endpoint + '/article/' + articleId)
            .then(function (response) {
                if (response.data === 'OK') {
                    defer.resolve(true);
                } else {
                    deleteArticleErrorLog(articleId, response.data);
                    defer.reject(false);
                }
            }).catch(function (response) {
            deleteArticleErrorLog(articleId, response.data);
            defer.reject(false);
        });

        return defer.promise;
    };

    var deleteArticleErrorLog = function (articleId, responseData) {
        $log.error(`could not remove article with id:${articleId}`, responseData);
    };

    var sanitizeArticle = function (article) {
        article.content = bbTeBaTextSanitizer.sanitize(article.content);
    };

    return {
        getArticles,
        getArticle,
        deleteArticle
    };
};

angular
    .module('bbTe.blogArticle')
    .service('bbTeBaArticleGateway', service);

