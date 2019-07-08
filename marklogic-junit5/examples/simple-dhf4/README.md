This project shows an example of using both marklogic-junit5 and marklogic-unit-test within a 
Data Hub Framework version 4 project. 

To try this out locally, first initialize the DHF project:

    ./gradlew hubInit
    
Then add the following lines to gradle.properties:

```
mlModulePaths=src/main/ml-modules,src/test/ml-modules
mlTestDbName=data-hub-TEST
mlTestDbFilename=final-database.json
mlTestServerFilename=final-server.json
mlTestServerName=data-hub-TEST
mlTestPort=8015
mlTestUsername=someuser
mlTestPassword=someuser's password
```

You can now deploy both the normal DHF application and the test resources defined in build.gradle via:

    ./gradlew mlDeploy testDeploy

There are two marklogic-unit-test test modules under ./src/main/ml-modules/root/test. You can run these 
via Gradle:

    ./gradlew test

And Gradle should report "BUILD SUCCESSFUL" as none of the tests should fail.

Or import this project into your favorite IDE and execute "RunDataHubUnitTestsTest". Each test module 
will be executed as a separate JUnit test. 
