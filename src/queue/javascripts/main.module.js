angular.module('BBQueue.controllers', []);
angular.module('BBQueue.services', []);
angular.module('BBQueue.directives', []);
angular.module('BBQueue.translations', []);

angular.module('BBQueue', [
    'BBQueue.controllers',
    'BBQueue.services',
    'BBQueue.directives',
    'BBQueue.translations',
    'ngDragDrop',
    'timer'
]);
