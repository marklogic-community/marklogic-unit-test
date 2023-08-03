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
