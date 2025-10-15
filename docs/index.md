---
layout: default
title: Introduction
nav_order: 1
---

marklogic-unit-test enables you to write and run automated tests for the custom 
[JavaScript modules](https://docs.marklogic.com/guide/getting-started/javascript) and 
[XQuery modules](https://docs.marklogic.com/guide/getting-started/xquery) that you 
can write and deploy to MarkLogic. Tests can be written in either JavaScript or XQuery and can test modules written
in either language as well. By getting tests in place for your custom modules, you can speed up development of your 
MarkLogic applications and ensure that they can be changed as easily as possible as new requirements are introduced.

marklogic-unit-test includes the following components:

1. A MarkLogic library module to help you write your test modules.
2. A simple web interface for running tests.
3. Java libraries for running your tests via [JUnit5](https://junit.org/junit5/) and for integrating with other 
   popular Java testing frameworks. 
4. A REST endpoint for integrating with testing frameworks in any language.

Please see the [Getting started guide](getting-started.md) to learn how to include marklogic-unit-test in your 
project and to start writing and running tests.

If you wish to use the Java-based support, you will need to use Java 17 or higher when using either `marklogic-junit5`
or `marklogic-unit-test-client` version 2.0.0 or higher. Prior to 2.0.0, Java 8 is required.

If you have any questions or run into issues while using marklogic-unit-test, try one of the following:

1. Check for a similar question [on Stack Overflow](https://stackoverflow.com/questions/tagged/marklogic).
2. If you don't find a similar question, [ask one yourself](https://stackoverflow.com/questions/ask?tags=marklogic).
3. Or [submit an issue](https://github.com/marklogic-community/marklogic-unit-test/issues/new); expect a response 
   within a day or two. 
