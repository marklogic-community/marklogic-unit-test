---
layout: default
title: Debugging tests
nav_order: 5
---

Like all unit testing frameworks, marklogic-unit-test is intended to speed up the cycle of developing, testing, and 
fixing code. A critical aspect of that is understanding why a test failed and how to fix it. This page provides 
guidance on how you can write your tests to ensure they can be easily debugged by any member of your development 
team. 

## Development setup

Before looking at how to write tests, you should ensure that you can change your application code and test the 
changes as quickly as possible. As mentioned in the [Getting started guide](getting-started.md), ml-gradle supports 
[watching for module changes](https://github.com/marklogic/ml-gradle/wiki/Watching-for-module-changes) so that when 
you modify either an application module file or test module file, the file will be immediately loaded into your 
application's modules database. This allows you to test your changes as quickly as possible.

To enable this, simply run the following Gradle task in its own terminal window:

    ./gradlew -i mlWatch

The Gradle "-i" flag - for info-level logging - results in each modified file being logged when it is loaded into 
MarkLogic. 

## Test assertion messages

Each [assertion function](assertion-functions.md) in marklogic-unit-test supports an assertion message as its final argument. 
These are recommended for when the intent of an assertion is not readily apparent from the two values being compared. 

For example, consider the following assertion:

    const actual = someLib.something();
    test.assertEqual(3, actual);

If that assertion fails because "actual" has a value of 2, marklogic-unit-test will throw the following error:

    expected: 3 actual: 2 (ASSERT-EQUAL-FAILED)

However, this doesn't explain why "3" is the expected value. The optional 3rd argument in `test.assertEqual` 
provides a test developer with a chance to explain why the value is expected - e.g.:

    const actual = someLib.something();
    test.assertEqual(3, actual, "Due to such-and-such reason, 3 should be returned");

The "such-and-such reason" would of course be replaced with a meaningful explanation in your test. 
marklogic-unit-test will then include this message in the failure message:

    Due to such-and-such reason, 3 should be returned; expected: 3 actual: 2 (ASSERT-EQUAL-FAILED)

## Using log statements

While tools such as [mlxprs](https://github.com/marklogic/mlxprs) exist to leverage the debugging capabilities within
MarkLogic, you may often find it helpful to include log statements both in your application module and in your test 
module. These can log the value of certain variables that are not returned by the function being tested but whose 
values provide insight into how the application code is behaving. 

For JavaScript code, use the following:

    const value = someLib.something();
    console.log("The value", value);

And for XQuery code, use the following:

    let $value := someLib:something()
    let $_ := xdmp:log(("The value", $value))

You can add these statements to your tests as well. 

Log messages will then appear in the MarkLogic log file named "PORT_ErrorLog.txt", where "PORT" is the port number 
of the MarkLogic app server that you are running the tests against.

## Examining the Gradle test report

When running tests via Gradle - either via `./gradlew test` or `./gradlew mlUnitTest` - one or more test failures will 
result in the task failing with the location of the test report being logged. The test report allows you to see details
on each test, including the failed assertion message and stacktrace for each failed test. 

When running `./gradlew test`, the test report will be available at "build/reports/tests/tests/index.html". You can 
open this file in a web browser to see the results; it is recommended to keep that window open and simply refresh it 
after re-running the Gradle `test` task. 

When running `./gradlew mlUnitTest`, the test report is a set of JUnit-formatted XML files available at 
"build/test-results/marklogic-unit-test". This approach does not result in an HTML web page that can be viewed in a web
browser, but each XML file will contain the results for the tests in a particular suite, including the failed assertion 
messages and stacktrace for each failed test.

