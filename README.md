ml-unit-test includes the [original Roxy unit test framework for MarkLogic](https://github.com/marklogic-community/roxy/wiki/Unit-Testing) and 
provides a few new features:

1. A REST endpoint for listing and running unit tests
1. A small Java library for integrating MarkLogic unit tests into existing test frameworks like JUnit
1. The ability to depend on this module as a true third-party dependency via ml-gradle

To try this out locally, check out the [ml-gradle example project](https://github.com/marklogic-community/ml-gradle/tree/dev/examples/unit-test-project). 
You can use that project's build.gradle file as an example of how to use ml-unit-test in your own project.

