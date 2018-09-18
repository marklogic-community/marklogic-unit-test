---
layout: inner
title: How to Run Your Tests
lead_text: ''
permalink: /running/
---

# Running Unit Tests
ML Unit Test provides a few options about how to run your tests. Before running your tests, you need to load the 
configuration you set up (see [How to Include ML Unit Test](./include/)). 

First, deploy the application:

    gradle mlDeploy
    
This will deploy the application along with the ml-unit-test modules. 

The examples below assume that your test application server is on port 8042. 

## Running from the UI

You can run the original UI test runner by going to:

- http://localhost:8042/test/default.xqy

Use the UI to select which test suites and test cases you want to run. You can also disable running the teardown after each suite and after each test. 

## Running from gradle

Tests can be run from the command line as a gradle task:

    gradle mlUnitTest

This runs your tests and gives a report on the results. 

You can get usage information by asking gradle: 

    gradle help --task=mlunittest

At this time, ml-gradle runs all test suites; there is not way to specify running just a set of suites or test cases. 

## Running from REST

You can also access the ml-unit-test REST endpoints directly: http://localhost:8042/v1/resources/ml-unit-test

The response will look like this:

```xml
<t:tests xmlns:t="http://marklogic.com/roxy/test">
  <t:suite path="auditing">
    <t:tests>
      <t:test path="document-history.sjs"/>
      <t:test path="history-single-merge.sjs"/>
      <t:test path="normalize-value-for-tracing.xqy"/>
      <t:test path="property-history.xqy"/>
      <t:test path="remerge.sjs"/>
    </t:tests>
  </t:suite>
</t:tests:>
```

In most cases, you'll have more than one suite defined. 

With no parameters, this endpoint returns a list of available tests. Add the `rs:func=run` parameter and ML Unit Test
will execute the requested tests. The following parameters control the test run: 

- `rs:suite`: the name of a test suite to run. This value comes from the `@path` attribute of a `t:suite` element. The endpoint expects exactly one suite. To run multiple suites, send multiple requests. 
- `rs:tests`: a comma-separated list of test cases to run. The values come from the `@path` attribute of `t:test` elements. If this parameter is not provided or is left blank, all tests within the specified suite will be run.
- `rs:runsuiteteardown`: Defaults to true. If false, skip running the suite-level teardown after the tests. 
- `rs:runteardown`: Defaults to true. If false, skip running the teardown after each test. 
- `rs:format`: The format to use for returning results. Default is "xml". You can also specify "junit". 
- `rs:calculatecoverage`: Whether to include code coverage data. Default is "false". *Note that this feature is still experimental.*

## Running from an IDE

*TODO*

This project includes the Gradle Java plugin, which allows you to run tests under src/test/java. This project includes
an example of a JUnit Parameterized test that invokes each ml-unit-test module separately - you can try it like this:

    gradle test

Again, two tests will run, and one will intentionally fail. The Parameterized test can be run in an IDE as well, allowing
you to take advantage of your IDE's support for JUnit tests.


