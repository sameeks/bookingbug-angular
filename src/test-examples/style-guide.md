### CoffeeScript|AngularJS Style Guide
###### This module uses style guides that should be used across the project.
 

##### The best pure JS style guide is the one created by [Papa John](https://github.com/johnpapa/angular-styleguide/blob/master/a1/README.md) 
##### There's available CS shift of above created by [*Plateful*](https://github.com/polarmobile/coffeescript-style-guide)
##### Below you can find more recommended style guides - Please feel free to contribute if have some suggestions on how to write clean and testable CS/AngularJS code 


1) Always use `return` explicitly - don't rely on CS adding `return` automatically as you can run into troubles easily _see example below_

``` coffeescript
controller = () ->
  'ngInject' 
  
  vm = this
  vm.hello = () ->  alert "hello!"
  
app.module('test').controller 'MyController', controller  
```

> Angular treats controllers as constructors so code above will return vm.hello method from constructor function which is totally wrong. To fix it just add simply ```return``` as the last line of controller (transpiled js code will have no return statement at all)
CS supposed to make code more readable - implicit `return` doesn't makes code more readable it makes it vulnerable. 
      

2) Use 'ngInject' string literals to assure safe minification process when creating sdk builds. *Bespoke* repository project has to start using gulp-ng-annotate node package when processing sdk scripts.
 
In AngularJS any injectable function can be made minification-safe by creating **$inject** property on it with an ordered array of 'dependencies' as a value. See example below.

``` coffeescript
controller = ($log, $uibModal, $state) -> 
  return  
  
app.module('test').controller 'MyController', controller

controller.$inject = ['$log', '$uibModal', '$state']
```

> Unfortunately doing it manually is hard to maintain (especially if you have many dependencies being injected)

*ngAnnotate* package allows as to use 'ngInject' string literal as a first line of injectable function. See example below.

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

> By not using named functions you can get easily in callback hell. It's very simple example but it has already the pyramid created by 4 levels of indentation at `$log.info` line - it reduces code readability a lot.

Proper way of doing it
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

4) Modularization

  * Create modules around features and not file types - it simply makes sense.
  
  * Module file name should be post fixed with *.module.js.coffee* `someFeatureName.module.js.coffee` - might be useful when creating gulp globs

5) Controllers

  * If you need to pass anything to thew view do it by using `controllerAs` syntax. Example below   
  
    ``` coffeescript
      app.module('test').controller 'MyController', () ->
        'ngInject'
    
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
  
6) Naming conventions

Element | Example element name | Example filename | Notes
:---|:---|:---
Modules | bbTe |	bbTe.module.js.coffee | keep element name as short as possible - should end with module.js.coffee  
Modules | bbTe.blogArticle | 	bbTeBlogArticle.module.js.coffee | keep element name as short as possible - should end with module.js.coffee
Directives | bbTeSomeSample | bbTeSomeSample.js.coffee | |       
Filters | bbTeSomeSample | bbTeSomeSample.js.coffee | |
Factories | bbTeSomeSample | bbTeSomeSample.js.coffee | |
Providers | BbTeSomeSample | BbTeSomeSample.js.coffee |  should end with provider.js.coffee to distinguish
Controllers|	BbTeSomeSampleCtrl | BbTeSomeSampleCtrl.js.coffee | postfix element name with 'Ctrl' as it's done in example
Services | BbTeSomeSample | BbTeSomeSample.js.coffee | |

   
 



