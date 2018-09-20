# MarkLogic Unit Test

marklogic-unit-test includes the [original Roxy unit test framework for MarkLogic](https://github.com/marklogic-community/roxy/wiki/Unit-Testing) and 
provides a few new features:

1. A REST endpoint for listing and running unit tests
1. A small Java library for integrating MarkLogic unit tests into existing test frameworks like JUnit
1. The ability to depend on this module as a true third-party dependency via ml-gradle

To try this out locally, check out the [ml-gradle example project](https://github.com/marklogic-community/ml-gradle/tree/dev/examples/unit-test-project). 
You can use that project's build.gradle file as an example of how to use marklogic-unit-test in your own project.

## Publishing

To publish this project, you need to publish both marklogic-unit-test-modules and marklogic-unit-test-client. 

1. In `{PROJECT}/gradle.properties`:
  - Increment the `version` property
  - Add these properties to your  `myBintrayUser`, `myBintrayKey`
2. `cd marklogic-unit-test-client`
3. `gradle bintrayUpload`
4. `cd ../marklogic-unit-test-modules`
5. `gradle bintrayUpload`
6. Point a browser to `https://bintray.com/marklogic-community/Maven/marklogic-unit-test-modules` and click "Publish"
6. Point a browser to `https://bintray.com/marklogic-community/Maven/marklogic-unit-test-client` and click "Publish"
