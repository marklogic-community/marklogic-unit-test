![GitHub release](https://img.shields.io/github/release/marklogic-community/marklogic-unit-test.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/marklogic-community/marklogic-unit-test.svg)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# Testing MarkLogic

marklogic-unit-test is an [ml-gradle bundle](https://github.com/marklogic-community/ml-gradle/wiki/Bundles) that allows
a project to test MarkLogic code.  With one import a project immediately has access to:

1. A framework for writing and running MarkLogic unit tests, including several built in assertion functions
1. A UI for viewing and running unit tests entirely within MarkLogic
1. A REST endpoint to run and report unit tests with other tools

Testing MarkLogic from a Java project is made easy with marklogic-junit:

1. Write MarkLogic tests entirely from Java
1. Easily integrate MarkLogic unit tests into your favorite Java testing frameworks

# Start using marklogic-unit-test

If you'd like to use marklogic-unit-test check out this 
[ml-gradle example project](https://github.com/marklogic-community/ml-gradle/tree/dev/examples/unit-test-project). 
You can use that project's build.gradle file as an example of how to use marklogic-unit-test in your own project.

### Add marklogic-unit-test to `build.gradle`

```aidl
buildscript {
  repositories {
    jcenter()
    mavenLocal()
  }
  dependencies {
    classpath "com.marklogic:marklogic-unit-test-client:1.0.beta"
    classpath "com.marklogic:ml-gradle:3.14.0"
  }
}

apply plugin: "com.marklogic.ml-gradle"

repositories {
  jcenter()
}

dependencies {
  mlBundle "com.marklogic:marklogic-unit-test-modules:1.0.beta"
}
```

### Add Test Properties to `gradle.properties`

```aidl
// Settings for any ml-gradle project
mlHost=localhost    // Assuming local development
mlAppName=my-app    // Application name, defaults to my-app
mlRestPort=8003     // Application Port, defaults to 8003
mlUsername=         // Username used to manage MarkLogic
mlPassword=         // Password used to manage MarkLogic


// Settings specific to marklogic-unit-test
mlTestRestPort=8004 // Testing port, view and run tests from this port

mlModulePaths=src/main/ml-modules,src/test/ml-modules  // Add test directory to ml-gradle configuration so tests are
                                                       // loaded.  Only necessary on automated testing environments.

```

### Deploy tests using ml-gradle

Now that the environment is configured to load tests and setup a test application servier its time to deploy everything.
```aidl
> gradlew mlDeploy
```

To enable quicker feedback between code updates and automated test runs, use the mlWatch task to automatically deploy
changes to MarkLogic
```aidl
> gradlew mlWatch
```

### Access marklogic-unit-test UI

Open a web browser to http://localhost:8004/test/.  This is where tests are displayed, ran, and results are displayed.

If this is a project that's new to marklogic-unit-tests no test suites are displayed because there are no tests.

### Creating a test suite

Creating test suites is easy using the mlGenerateUnitTestSuite gradle task.  Run the following to setup a sample test suite:
```aidl
> gradlew mlGenerateUnitTestSuite
```

Now a new test suite has been generated in `src/test/ml-modules/root/test/suites` called `SampleTestSuite`.

If `mlWatch` is being used, refreshing the web browser at http://localhost:8004/test/ will now show the newly created
`SampleTestSuite`.  The suite can be ran using the Run Tests button at the top or bottom of the page.



# Start using marklogic-junit
Check out the [marklogic-junit sub-project](https://github.com/marklogic-community/marklogic-unit-test/tree/master/marklogic-junit)
to get started using marklogic-junit.
