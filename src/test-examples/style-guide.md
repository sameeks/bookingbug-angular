### CoffeeScript|AngularJS Style Guide
###### This module uses style guides that should be used across the project.
 

##### The best pure JS style guide is the one created by [Papa John](https://github.com/johnpapa/angular-styleguide/blob/master/a1/README.md) 
##### There's available CS shift of above created by [*Plateful*](https://github.com/Plateful/plateful-mobile/wiki/AngularJS-CoffeeScript-Style-Guide)
##### Below you can find more recommended style guides - Please feel free to contribute if have some suggestions on how to write clean and testable CS/AngularJS code 


1) Always use `return` explicitly - don't rely on CS adding `return` automatically as you can run into troubles easily. See the example below

``` coffeescript
controller = () ->
  'ngInject' 
  
  vm = this
  vm.hello = () ->  alert "hello!"
  
app.module('test').controller 'MyController', controller  
```

> Angular treats controllers as constructors so code above will return vm.hello method from constructor function which is wrong. To fix it just add simply ```return``` as the last line of controller (transpiled js code will have no return statement at all)
CS supposed to make code more readable - implicit `return` makes it only more vulnerable. 
      

2) Use 'ngInject' string literals to assure safe minification process when creating sdk builds. *Bespoke* repository project has to start using gulp-ng-annotate node package when processing sdk scripts.
 
In AngularJS any injectable function can be made minification-safe by creating **$inject** property on it with an ordered array of 'dependencies' as a value. See the example below.

``` coffeescript
controller = ($log, $uibModal, $state) -> 
  return  
  
app.module('test').controller 'MyController', controller

controller.$inject = ['$log', '$uibModal', '$state']
```

> Unfortunately doing it manually is hard to maintain (especially if you have many dependencies injected)

*ngAnnotate* package allows as to use 'ngInject' string literal as a first line of injectable function. See the example below.

``` coffeescript
controller = ($log, $uibModal, $state) ->
 'ngInject'
 
  return  
app.module('test').controller 'MyController', controller
```
> during minification process, ngAnnotate will detect 'ngInject' literal and will produce `controller.$inject = ['$log', '$uibModal', '$state']` for surrounding function automatically  

3) Use named functions wherever it's possible - keep your code shallow. 

Wrong way
``` coffeescript
app.module('test').controller 'MyController', ($log, someService, otherService) ->
    'ngInject'

    vm = this
    vm.func1 = (param1) ->
        alert "hello " + param1

    vm.func2 = () ->
        someService.then (response) ->
            otherService.then (response) ->
                $log.info 'other service response', response

    return
```

> By not using named functions you can get easily into callback hell. It's very simple example but it has already the pyramid created by 4 levels of indentation at `$log.info` line - it reduces code readability a lot.

Proper way
``` coffeescript
controller = ($log, someService, otherService) ->
    'ngInject'

    vm = this

    init = () ->
        return

    func1 = (param1) ->
        alert "hello " + param1

    func2 = () ->
        someService.then someServiceHandler

    someServiceHandler = (response) ->
        otherService.then otherServiceHandler

    otherServiceHandler = (response) ->
        $log.info 'other service response', response

    init()
    
    vm.func1 = func1
    vm.func2 = func2

    return

app.module('test').controller 'MyController', controller
```

> By using named functions we reduced indentation pyramid to 2 levels only - code is much more readable right now

4) Controllers

  * If you need to pass anything to thew view do it by using `controllerAs` syntax. Example below   
  
    ``` coffeescript
      app.module('test').controller 'MyController', () ->
        'ngInject'
    
        /* jshint validthis: true */
        vm = this
        vm.someProperty = 'someValue'
        
        init = () ->
          vm.someFunc = someFun
          vm.someFunc2 = someFun2
        
          return
          
        someFunc = () ->
          return
          
        someFunc2 = () ->
          return
        
        init()
    
        return
    ```    
    > you can choose whatever name you like for *controllerAs* value but conventionally *vm* is being used and we should stick to it
       
  * $scope should be use only if it's really needed
    - for publish and subscribe to events: $scope.$emit, $scope.$broadcast, and $scope.$on.
    - for watch values or collections: $scope.$watch, $scope.$watchCollection        
  * controllers should be skinny as much as possible:
      - move all possible logic to services
      - do it even if new service won't be used anywhere else (the situation may change in the future and it's much easier to refactor service than bloated controller)
  
5) Modularization

  * Create modules around features and not file types - it simply makes sense.
  
6) Naming conventions

  * Directories and file names should be lower-cased & hyphenated.

  * **feature-name.type.js.coffee** is a recommended pattern for _file names_.
      - it provides consistent way to quickly identify components 
      - it provides pattern matching for any automated tasks
            
  * **feature-name.type.spec.js.coffee** is a recommended pattern for _unit test file names_. They should be named the same way and stay at the same place as the files they test.
                    
  * **modulesAcronymFeatureName** is a recommended pattern for _registered components names_.
      - controllers should always be capitalized as they return constructor function
      - services should be capitalized only if they return constructor function
      - it's the best way to avoid name collisions across all business modules
          - example1: if we want to create Article service within bbTe.someFeature module whe should actually name it **bbTeSfArticle** 
          - example2: if we want to create Article service within bbTe.anotherFeature module whe should actually name it **bbTeAfArticle**
             
    
| Component | Registerd Component Name | Component File Name |
| :--- | :--- | :--- |
| Modules                                | bbTe               |	bb-te.module.js.coffee |
| Sub Modules                            | bbTe.blogArticle   | bb-te.blog-article.module.js.coffee |
| bbTe.blogArticle module: Configuration | N/A                | bb-te.blog-article.config.js.coffee |
| bbTe.blogArticle module: Routes        | N/A                | bb-te.blog-article.routes.js.coffee |
| bbTe.blogArticle module: _SomeSample_ Directive  | bbTeBaSomeSample     | some-sample.directive.js.coffee |       
| bbTe.blogArticle module: _SomeSample_ Filter     | bbTeBaSomeSample     | some-sample.filter.js.coffee |
| bbTe.blogArticle module: _SomeSample_ Service    | bbTeBaSomeSample     | some-sample.service.js.coffee |
| bbTe.blogArticle module: _SomeSample_ Factory    | bbTeBaSomeSample     | some-sample.factory.js.coffee |
| bbTe.blogArticle module: _SomeSample_ Provider   | bbTeBaSomeSample     | some-sample.provider.js.coffee |
| bbTe.blogArticle module: _SomeSample_ Controller | **B**bTeBaSomeSample | some-sample.controller.js.coffee |
