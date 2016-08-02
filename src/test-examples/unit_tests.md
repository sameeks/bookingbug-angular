### CoffeeScript|AngularJS Unit Tests
###### This module contains unit tests samples. Please feel free to contribute if have some interesting unit test samples you want to share with others.
 
#### Preset 
SDK consists of many submodules that have it's own bower.json files.

Each submodules will be tested separately by running new Karma servers. 
We cannot test submodules all together:
  - application behaviour may be modified just by loading dependencies (for example angular modules config/run time)
  - they may have different dependencies

If you want to run unit tests locally you need to ensure that you have installed bower components for each submodule.
You can do it easily by going to sdk project root folder and running bash script that is being used by travis.
   
```
bash travis/install.sh
```

If for any reason you want to remove existing bower_modules in all submodules you can do it easily by running following.
  
```
bash travis/remove.sh
```

#### Test Driven Development 
 
1. To run sdk submodules unit tests all together execute following in root of sdk repository

    `gulp test:unit`

    > It will start for each sub-module separate karma servers.
    > Tests are run in watch mode which means any code or tests modifications should rerun appropriate tests again.
    > Note that any bower dependencies changes require task restart 

2. If you work only on one particular sub-module than you can run just one of following

    ``` bash
    gulp test:unit:test-examples
    gulp test:unit:core
    gulp test:unit:admin
    gulp test:unit:admin-booking
    gulp test:unit:admin-dashboard
    gulp test:unit:events
    gulp test:unit:member
    gulp test:unit:services
    gulp test:unit:settings
    ```

    > Tests are run in watch mode which means any code or tests modifications should rerun appropriate tests again.
    > Note that any bower dependencies changes require task restart

3. To see test coverage html report for given sdk sub-module please cd to given sub-module 
   and open `unit-tests/reports/coverage-lcov/lcov-report/index.html` in browser of your preference.

#### Continuous Integration

- Every commit you push to your branch triggers *Travis* build task
- Builds are created for both branches and pull requests
- Every build executes unit tests `gulp test:unit-ci`. Any failed unit test will fail build as well.
- Ideally we should do pull request for any changes we want to merge into `master` - failing build means probably failing tests which you can confirm by going to travis build logs.
- Keep in mind that bower and npm dependencies are cached on travis. Every branch/pull request has it's own cache. 
- If you have bigger changes in npm/bower dependencies and unit tests fail for no particular reason - it might be good idea to delete cache for given branch/pull-request.      

   
