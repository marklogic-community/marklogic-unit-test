# MarkLogic Unit Test

marklogic-unit-test includes the [original Roxy unit test framework for MarkLogic](https://github.com/marklogic-community/roxy/wiki/Unit-Testing) and 
provides a few new features:

1. A REST endpoint for listing and running unit tests
1. A small Java library for integrating MarkLogic unit tests into existing test frameworks like JUnit
1. The ability to depend on this module as a true third-party dependency via ml-gradle

To try this out locally, check out the 
[ml-gradle example project](https://github.com/marklogic-community/ml-gradle/tree/dev/examples/unit-test-project). 
You can use that project's build.gradle file as an example of how to use marklogic-unit-test in your own project.

# Contributing

Contributions are welcome.  Here are some steps to get you started:
1. Please start by forking the project on GitHub
1. Check out your fork of the project
1. Make your changes
1. Add tests to cover your changes
1. Make sure the tests pass by running `gradle build test`
1. Check in your changes to your fork on GitHub
1. Once the changes are ready, create a pull request
1. Wait for the pull request to be reviewed and accepted into the baseline

## Testing
Please make sure that all changes to the project include sufficient unit tests to cover the feature being added.  Pull 
requests without automated tests will not be accepted.

Tests can be added to  `{PROJECT}/marklogic-unit-test-client/src/test/ml-modules/root/test/suites` and can be ran with 
the `gradle build test` target.

If you're using an IDE with Junit support tests can be ran from the IDE by running the test at
`{PROJECT}/marklogic-unit-test-client/src/test/java/com/marklogic/test/unit/ParameterizedTest.java`

## Releasing

To do a release:

1. Increment the `version` property in `{PROJECT}/gradle.properties`
2. In `{PROJECT}/`, run `github_changelog_generator --token $your-github-token --future-release v1.0.0`
   - If running on Windows, you'll need to use different cache file paths, such as 
   `--cache-file C:\tmp\github-changelog-http-cache --cache-log C:\tmp\github-changelog-logger.log`. 
3. Commit the CHANGELOG.md
4. Push changes to GitHub
5. Do a PR to bring changes from the develop branch onto master
6. Follow the steps on [creating releases](https://help.github.com/articles/creating-releases/). 

### Publishing to bintray

To publish this project, you need to publish both marklogic-unit-test-modules and marklogic-unit-test-client. 

1. In `{PROJECT}/gradle.properties`, add these properties `myBintrayUser`, `myBintrayKey`
2. `cd marklogic-unit-test-client`
3. `gradle bintrayUpload`
4. `cd ../marklogic-unit-test-modules`
5. `gradle bintrayUpload`
6. Open [marklogic-unit-test-modules](https://bintray.com/marklogic-community/Maven/marklogic-unit-test-modules) on 
Bintray and click "Publish"
6. Open [marklogic-unit-test-client](https://bintray.com/marklogic-community/Maven/marklogic-unit-test-client) on 
Bintray and click "Publish"
