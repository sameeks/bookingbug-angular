#### OPTIONS 

_**--env**_

 + default value is 'dev'
 + available options ['local', 'dev', 'staging', 'prod'] 

_**--project**_ 

 + default value is 'demo' 
 + can be used to run web server or e2e tests for sample project, value should be sample project directory name within '.test/projects/' directory
 
 
### SAMPLE PROJECT - run web server
`gulp sdk-test-project:watch --project=demo`
`gulp` (default task, runs "run-project:watch --project=demo")

--project option is required


### SAMPLE PROJECT - e2e tests
`gulp test-e2e --project=demo`

--project option is required


### SDK - unit tests
`gulp test-unit:watch`
`gulp test-unit` (one time run, used by CI)
   

