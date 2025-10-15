---
layout: default
title: Getting started
nav_order: 2
---

This guide walks you through adding marklogic-unit-test to an existing project, followed by writing, loading, and 
running a simple test.

## Example project description 

The [example project](https://github.com/marklogic-community/marklogic-unit-test/tree/master/examples/getting-started)
for this guide is a simple MarkLogic application with a
[custom REST endpoint](https://docs.marklogic.com/guide/rest-dev/extensions) named "thesaurus". The endpoint
returns thesaurus entries via the `/example/lib.sjs` module located at `src/main/ml-modules/root` in the project.
The thesaurus entries are found in the `src/main/ml-data/thesaurus/example.xml` file which is loaded into the 
application's content database when the application is deployed. If you would like to try running the tests in this
application, you can deploy it by cloning this repository and running the below commands. The value of `mlPassword`
should be set to that of your MarkLogic admin user's password.

    cd examples/getting-started
    echo "mlPassword=admin" > gradle-local.properties
    ./gradlew -i mlDeploy

## Adding marklogic-unit-test to an existing project

marklogic-unit-test can be added to an existing [ml-gradle project](https://github.com/marklogic/ml-gradle) by 
adding the following configuration to the project's `build.gradle` file:

```
dependencies {
  mlBundle "com.marklogic:marklogic-unit-test-modules:2.0.0"
}
```

The above dependency is downloaded from the [Maven Central repository](https://central.sonatype.com/artifact/com.marklogic/marklogic-unit-test-modules), 
so you will need to ensure that your `build.gradle` file has that repository registered - i.e.:

```
repositories {
  mavenCentral()
}
```

This uses the [ml-gradle bundle feature](https://github.com/marklogic/ml-gradle/wiki/Bundles) for sharing and reusing
MarkLogic modules. After adding the above configuration (which you may instead add to an existing `dependencies` block
in your `build.gradle` file), run the following task to install marklogic-unit-test into your MarkLogic application:

    ./gradlew -i mlLoadModules

If you would like to [run your marklogic-unit-test tests](running-tests.md) via Gradle, you'll also need to include the 
following at the top of your `build.gradle` file:

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

The above configuration enables the ml-gradle `mlUnitTest` task to access the `marklogic-unit-test-client` library, 
allowing it to run your marklogic-unit-test tests.

If you are not using ml-gradle, you will need to manually add the marklogic-unit-test modules to your project. Please
see [the marklogic-unit-test releases](https://github.com/marklogic-community/marklogic-unit-test/releases) for 
zip files containing these modules. 

## Writing a test

marklogic-unit-test will be used to verify the behavior of the `lookupTerm` function in the `lib.sjs` module. The
assertions will be based on the known contents of the thesaurus file at `src/main/ml-data/thesaurus/example.xml` in 
the project.

### Configuring where test modules are located

Before writing a test module, we need to perform a one-time step to configure the project so that test modules can
be stored in a directory separate from the one containing application modules. This allows for the application to be 
deployed to non-development environments without including any of the test modules. Open your project's 
`gradle.properties` file and add the following property:

    mlModulePaths=src/main/ml-modules,src/test/ml-modules

By default, ml-gradle will only load modules from `src/main/ml-modules`. The above configuration allows for loading
modules from `src/test/ml-modules` as well (note that you can choose any directory path you wish). This configuration 
can later be overridden via an environment-specific Gradle properties file to only load from `src/main/ml-modules`.

Next, create a `src/test/ml-modules/root/test/suites` directory in your project. All test modules will be stored in 
child directories of this directory.

### Writing a test module

marklogic-unit-test requires test modules to have a URI beginning with `/test/suites/(name of suite)`. Test files must
therefore be stored in the `src/test/ml-modules/root/test/suites/(name of suite)` directory. 

A test suite can have any name; for this example, we will use "thesaurus" as the name. Test modules can have any name
as well with a few exceptions for setup and teardown modules; those exceptions are covered in the 
[guide for writing tests](writing-tests.md). We will use "simple-test.sjs" for this example, so we create a
file at `src/test/ml-modules/root/test/suites/thesaurus/simple-test.sjs` with the following initial content:

```
const test = require("/test/test-helper.xqy");
const lib = require("/example/lib.sjs");
```

The first line above imports the marklogic-unit-test module containing dozens of useful 
[assertion functions](assertion-functions.md); every test
module will need this imported. The second line imports the library module that we wish to verify. 

Next, add the following text to the file:

```
const result = lib.lookupTerm("Car");
[
  test.assertEqual("Car", result.term),
  test.assertEqual(1, result.entries.length),
  test.assertEqual(3, result.entries[0].synonyms.length, "3 synonyms are expected for 'Car'.")
];
```

The above code will invoke the `lookupTerm` function that we wish to test with a term that we know is in the 
application's thesaurus. Each `assertEqual` function call - along with every other assertion function in 
marklogic-unit-test - will return a success or failure. The test then returns an array of these successes and failures.
The different approaches for [running tests](running-tests.md) know how to collect these results and display how many
tests passed and how many failed.

## Configuring a connection to MarkLogic

In order to run the test we've written, the test must be loaded into a modules database in MarkLogic. Both loading and
running the test requires connecting to a MarkLogic App Server. ml-gradle supports both of these tasks, but a 
connection must be configured so that ml-gradle knows which App Server to connect to and how to authenticate. 

By default, ml-gradle will use either the App Server port defined by the `mlTestRestPort` property if set, or else it
will use the `mlRestPort` property. It will also use the 
[REST API server connection properties](https://github.com/marklogic/ml-gradle/wiki/Property-reference#rest-api-server-connection-properties)
for controlling how ml-gradle authenticates with the App Server. Note that the use of `mlTestRestPort` is optional; 
see [the ml-gradle docs](https://github.com/marklogic/ml-gradle/wiki/Setup-Test-Resources) for information on whether
you want to use this feature in your project. 

In the case of our example project, the following properties in `gradle.properties` are used to configure a connection
for loading and running tests:

```
mlHost=localhost
mlRestPort=8024
mlUsername=admin
mlPassword=this value will be set in gradle-local.properties
```

For more information on configuring the connection, please see this
[example project in ml-gradle](https://github.com/marklogic/ml-gradle/tree/master/examples/unit-test-project).

## Loading tests

Now that we've written a test and configured a connection to MarkLogic, we are ready to load the test into our 
application's modules database. ml-gradle offers a variety of tasks to accomplish this with `mlLoadModules` being the 
simplest one. However, having to execute this task every time a test module is updated slows down the development 
cycle. To address this, ml-gradle provides support for 
[watching for module changes](https://github.com/marklogic/ml-gradle/wiki/Watching-for-module-changes) and 
automatically loading them via the `mlWatch` task. It is recommended to execute this in a terminal window and leave
it running while you create and modify your modules:

    ./gradlew -i mlWatch

The Gradle "-i" flag for info-level logging results in the filename of each module being logged when it is loaded.

Once you execute either `mlWatch` or `mlLoadModules`, your test will be ready to be run. 

## Running a test

marklogic-unit-test provides [several ways to run tests](running-tests.md). We will look at the two primary ways to 
run the test module we just wrote and loaded into our application's modules database.

First, tests can be run via the ml-gradle `mlUnitTest` task, as long as you have included the 
`marklogic-unit-test-client` dependency in your `build.gradle` file as shown at the beginning of this guide:

    ./gradle -i mlUnitTest

You should see output like this:

```
> Task :mlUnitTest
Constructing DatabaseClient that will connect to port: 8024
Run teardown scripts: true
Run suite teardown scripts: true
Run code coverage: false
Running all suites...
Done running all suites; time: 11ms

1 tests completed, 0 failed
```

To see the output when a test fails, change one of the assertions in the `simple-test.sjs` file so that an incorrect
value is expected. If you have the ml-gradle `mlWatch` task running, it will be loaded after you save the file; 
otherwise, run the `mlLoadModules` task again. Then run `./gradlew mlUnitTest` to re-run the test, and you will see 
output like this:

```
> Task :mlUnitTest FAILED
Constructing DatabaseClient that will connect to port: 8024
Run teardown scripts: true
Run suite teardown scripts: true
Run code coverage: false
Running all suites...
Done running all suites; time: 15ms

simple-test.sjs > simple-test.sjs FAILED
    3 synonyms are expected for 'Car'.; expected: 4 actual: 3
```

marklogic-unit-test also provides a simple web interface for running tests. You can access this in your web 
browser via the port of your application's REST API server and the path `/test/default.xqy`. For example, for the 
example project, you can access it at <http://localhost:8024/test/default.xqy>, assuming that your MarkLogic server 
is accessible at "localhost". You can select the tests you wish to run and click on "Run Tests". 

## Summary

This guide has covered the following topics:

1. How to include marklogic-unit-test in your project.
2. How to write a test.
3. How to load a test.
4. How to run a test.

With the above information and the references on [writing tests](writing-tests.md) and 
[running tests](running-tests.md), you can now start writing tests for the library modules in your application, 
ensuring that you can quickly enhance your application without breaking any existing functionality. 
