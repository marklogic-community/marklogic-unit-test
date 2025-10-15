---
layout: default
title: Running tests
nav_order: 4
---

Tests written using marklogic-unit-test can be run in several ways, each of which is described below. 

## Using Gradle 

The [ml-gradle plugin for Gradle](https://github.com/marklogic/ml-gradle) provides an `mlUnitTest` task for running 
all of your marklogic-unit-test tests. As noted in the [Getting started guide](getting-started.md), you will need to 
include the following block at the top of your `build.gradle` file to ensure this task can run successfully:

```
buildscript {
  repositories {
    mavenCentral()
  }
  dependencies {
    classpath "com.marklogic:marklogic-unit-test-client:2.0.0"
  }
}
```

You can then run the task:

    ./gradlew mlUnitTest

The output of this task will capture how many tests passed and how many failed. A failure message will be displayed for
each test that fails. 

Please see 
[the ml-gradle example project for marklogic-unit-test](https://github.com/marklogic/ml-gradle/tree/master/examples/unit-test-project)
for more information on how tests are run, along with more information on how to configure the connection to a MarkLogic
App Server.

## Using the web application

Once you have deployed your application along with the marklogic-unit-test modules, as described in the
[Getting started guide](getting-started.md), you will be able to access a custom endpoint via any MarkLogic HTTP
App Server associated with the modules database containing your application modules. The path of that endpoint is
`/test/default.xqy`. For example, since the App Server in the [Getting started guide](getting-started.md) listens on
port 8024, the endpoint would be accessible at <http://localhost:8024/test/default.xqy>.

The web application at this custom endpoint provides a functional, albeit antiquated-looking, interface for running
one or more tests and/or suites at a time. Use the checkboxes under "Run" and "Run All Tests" to select which tests
and suites you would like to run. Click the "Run Tests" button in the upper right-hand corner to run the selected
tests. Any failed test will display a message capturing the assertion failure.

## Using JUnit5

The [marklogic-junit5 library](https://github.com/marklogic-community/marklogic-unit-test/tree/master/marklogic-junit5) 
within this project provides support for testing REST endpoints in MarkLogic. It also supports running your 
marklogic-unit-test tests as part of a JUnit test suite. This allows for a single test run to execute and report on 
all of your tests - both your JUnit5 tests that invoke REST endpoints in MarkLogic and each of your marklogic-unit-test
test modules.

For further information, see 
[the marklogic-junit5 example project](https://github.com/marklogic-community/marklogic-unit-test/tree/master/marklogic-junit5/examples/simple-ml-gradle)
that describes the configuration necessary.

## Using the marklogic-unit-test REST extension

The marklogic-unit-test library includes a 
[REST extension](https://docs.marklogic.com/guide/rest-dev/extensions) 
available at `/v1/resources/marklogic-unit-test`. This extension is used to both list and run tests. You can 
use this to integrate the execution of marklogic-unit-test tests into any testing framework that can invoke HTTP 
endpoints. 

To list tests, send a GET request to the extension endpoint. You will receive an XML response similar to the one shown
below:

```
<test:tests xmlns:test="http://marklogic.com/test">
  <test:suite path="thesaurus">
    <test:tests>
      <test:test path="simple-test.sjs"/>
    </test:tests>
  </test:suite>
  <test:formats>
    <test:format path="j-unit.xsl"/>
  </test:formats>
</test:tests>
```

To run a suite of tests, send a POST request to the extension with the following querystring parameters defined:

- `rs:suite` = required; the name of the test suite to run.
- `rs:tests` = optional; comma-separated list of test names to run within a suite.
- `rs:runsuiteteardown` = optional, defaults to true; if false, skip running the teardown module for the suite.
- `rs:runteardown` = optional, defaults to true; if false, skip running the teardown module after each test.
- `rs:format` = optional, defaults to "xml"; the format to use for returning results; can specify "junit" instead.
