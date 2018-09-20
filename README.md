# MarkLogic Unit Test

marklogic-unit-test includes the [original Roxy unit test framework for MarkLogic](https://github.com/marklogic-community/roxy/wiki/Unit-Testing) and 
provides a few new features:

1. A REST endpoint for listing and running unit tests
1. A small Java library for integrating MarkLogic unit tests into existing test frameworks like JUnit
1. The ability to depend on this module as a true third-party dependency via ml-gradle

To try this out locally, check out the [ml-gradle example project](https://github.com/marklogic-community/ml-gradle/tree/dev/examples/unit-test-project). 
You can use that project's build.gradle file as an example of how to use marklogic-unit-test in your own project.

## Releasing

To do a release:

1. Increment the `version` property in `{PROJECT}/gradle.properties`
2. In `{PROJECT}/`, run `github_changelog_generator --token $your-github-token --future-release v1.0.0`

If running on Windows, you'll need to use different cache file paths, such as `--cache-file C:\tmp\github-changelog-http-cache --cache-log C:\tmp\github-changelog-logger.log`. 

3. Commit the CHANGELOG.md
4. Push changes to GitHub
5. Do a PR to bring changes from the develop branch onto master
6. Follow steps at https://help.github.com/articles/creating-releases/. 

### Publishing to bintray

To publish this project, you need to publish both marklogic-unit-test-modules and marklogic-unit-test-client. 

1. In `{PROJECT}/gradle.properties`, add these properties `myBintrayUser`, `myBintrayKey`
2. `cd marklogic-unit-test-client`
3. `gradle bintrayUpload`
4. `cd ../marklogic-unit-test-modules`
5. `gradle bintrayUpload`
6. Point a browser to `https://bintray.com/marklogic-community/Maven/marklogic-unit-test-modules` and click "Publish"
6. Point a browser to `https://bintray.com/marklogic-community/Maven/marklogic-unit-test-client` and click "Publish"
