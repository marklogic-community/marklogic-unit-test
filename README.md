![GitHub release](https://img.shields.io/github/release/marklogic-community/marklogic-unit-test.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/marklogic-community/marklogic-unit-test.svg)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# Testing MarkLogic

marklogic-unit-test is a testing framework that allows a project to test MarkLogic code.  With one import a project
immediately has access to:

1. A framework for writing and running MarkLogic unit tests, including several built in assertion functions
1. A UI for viewing and running unit tests entirely within MarkLogic
1. A REST endpoint to run and report unit tests with other tools

Testing MarkLogic from a Java project is made easy with marklogic-junit5:

1. Write MarkLogic tests entirely from Java
1. Easily integrate MarkLogic unit tests into your JUnit 5 project

# Start using marklogic-unit-test

MarkLogic unit test can easily be integrated into your project as an [ml-bundle](https://github.com/marklogic-community/ml-gradle/wiki/Bundles).
  The following steps will configure a project to import and use marklogic-unit-tests.

If you'd like to skip straight to the end, you can check out a [working example project](https://github.com/marklogic-community/ml-gradle/tree/dev/examples/unit-test-project).
You can use that project's `build.gradle` file as an example of how to use marklogic-unit-test in your own project.

### Add marklogic-unit-test to `build.gradle`

```groovy
buildscript {
  repositories {
    mavenCentral()
  }
  dependencies {
    classpath "com.marklogic:marklogic-unit-test-client:1.2.0"
    classpath "com.marklogic:ml-gradle:4.2.1"
  }
}

apply plugin: "com.marklogic.ml-gradle"

repositories {
  mavenCentral()
}

dependencies {
  mlBundle "com.marklogic:marklogic-unit-test-modules:1.2.0"
}
```

### Add Test Properties to `gradle.properties`

```properties
# Settings for any ml-gradle project
mlHost=localhost    # Assuming local development
mlAppName=my-app    # Application name, defaults to my-app
mlRestPort=8003     # Application Port, defaults to 8003
mlUsername=         # Username used to manage MarkLogic
mlPassword=         # Password used to manage MarkLogic


# Settings specific to marklogic-unit-test
mlTestRestPort=8004 # Testing port, view and run tests from this port

# ml-gradle supports deploying to multiple environments (https://github.com/marklogic-community/ml-gradle/wiki/Configuring-ml-gradle#environment-based-properties).\
# Add the following line to gradle-{env}.properties files for which you would like to deploy the tests. Typically
# tests are only deployed to environments that execute automated tests, like local development and CI environments.
mlModulePaths=src/main/ml-modules,src/test/ml-modules
```

### Deploy tests using ml-gradle

Now that the environment is configured to load tests and setup a test application servier its time to deploy everything.
```sh
./gradlew mlDeploy
```

To enable quicker feedback between code updates and automated test runs, use the mlWatch task to automatically deploy
changes to MarkLogic
```sh
./gradlew mlWatch
```

### Access marklogic-unit-test UI

Open a web browser to http://localhost:8004/test/.  This is where tests are selected, run, and results are displayed.

If this is a project that's new to marklogic-unit-tests no test suites are displayed because there are no tests.

### Creating a test suite

Creating test suites is easy using the mlGenerateUnitTestSuite gradle task.  Run the following to setup a sample test suite:
```sh
./gradlew mlGenerateUnitTestSuite
```

More options exist for mlGenerateUnitTestSuite, consult the gradle help
```sh
./gradlew help --task mlGenerateUnitTestSuite
```

Now a new test suite has been generated in `src/test/ml-modules/root/test/suites` called `SampleTestSuite`.

If `mlWatch` is being used, refreshing the web browser at http://localhost:8004/test/ will now show the newly created
`SampleTestSuite`.  The suite can be run using the Run Tests button at the top or bottom of the page.

# Start using marklogic-junit
Check out the [marklogic-junit5 sub-project](https://github.com/marklogic-community/marklogic-unit-test/tree/master/marklogic-junit5)
to get started using marklogic-junit5.
