---
layout: default
title: Writing tests
nav_order: 3
---

This guide is a reference on the different kinds of test modules, setup modules, and teardown modules you can write 
and run with marklogic-unit-test. The examples shown in this page can be found
in the `src/test/ml-modules/root/test/suites/thesaurus` directory in the
[test-examples project](https://github.com/marklogic-community/marklogic-unit-test/tree/master/examples/test-examples).

## Location of test files

As described in the [Getting started guide](getting-started.md), marklogic-unit-test requires the URI of each module
to begin with `/test/suites/(name of suite)/`. Thus, all test files should be located in an 
[ml-gradle modules directory](https://github.com/marklogic/ml-gradle/wiki/How-modules-are-loaded) under 
`root/test/suites/(name of suite)/`. 

Test files should also ideally be kept separate from application files. This is typically achieved by adding the 
following configuration to the `gradle.properties` file in your project:

    mlModulePaths=src/main/ml-modules,src/test/ml-modules

With this approach, application module files are in `src/main/ml-modules` and test module files are in  
`src/test/ml-modules`. Test suites are then stored at `src/test/ml-modules/root/test/suites/(name of suite)`. 

## Writing JavaScript tests

JavaScript tests can either be "script" files or ["module" files](https://docs.marklogic.com/guide/jsref/modules). 
A script file has an extension of ".sjs" or ".js" and starts with the following:

    const test = require("/test/test-helper.xqy");

A module has an extension of ".mjs" and starts with the following:

    import { testHelperProxy } from "/test/test-helper";

Because a test is normally testing the functions of a single application module, it is common for the import of 
the test helper library to be followed by an import of the application module being tested - e.g.

    const test = require("/test/test-helper.xqy");
    const lib = require("/example/lib.sjs");

The test should then return the output of one or more [assertion functions](assertion-functions.md) 
found in the `test-helper` module. This can be done via a single array:

```
const result = lib.lookupTerm("Car").toArray();
[
  test.assertEqual(1, result.length),
  test.assertEqual("Car", result[0].term),
  test.assertEqual(3, result[0].synonyms.length, "3 synonyms are expected for 'Car'.")
];
```

Or an array can be declared and the output of assertion functions can be added to it. This is useful when testing more
than one scenario in a single test file:

```
const assertions = [];

let result = lib.lookupTerm("Car").toArray();
assertions.push(test.assertEqual(1, result.length));

result = lib.lookupTerm("Truck").toArray();
assertions.push(test.assertEqual(0, result.length));

assertions;
```

JavaScript tests can also import and test XQuery libraries. The MarkLogic documentation covers how to
[import and use XQuery libraries](https://docs.marklogic.com/guide/jsref/functions#id_67468) in a JavaScript module. 
The following shows an example of doing so:

```
const test = require("/test/test-helper.xqy");
const lib = require("/example/lib.xqy");

const result = lib.lookupTerm("Car");
[
  test.assertEqual("Car", result.term),
  test.assertEqual(3, result.entries.synonyms.length)
];
```

## Writing XQuery tests

Similar to JavaScript tests, an XQuery test will import the marklogic-unit-test helper library, typically followed by 
the application library containing the function to be tested:

```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace ex="http://example.org" at "/example/lib.xqy";
```

The test will then call the function to be tested and use the helper library to invoke one or more
[assertion functions](assertion-functions.md), returning the results of those assertions:

```
let $result := ex:lookup-term("Car", "elements")
return (
  test:assert-equal("Car", $result/thsr:term/fn:string()),
  test:assert-equal(3, fn:count($result/thsr:synonym))
)
```

If the application library is written in JavaScript, it cannot be imported in an XQuery module. Instead, the 
[xdmp:javascript-eval function](https://docs.marklogic.com/xdmp:javascript-eval) can be used to invoke the desired
JavaScript function:

```
let $script := "const ex = require('/example/lib.sjs'); ex.lookupTerm('Car', 'elements')"
let $result := xdmp:javascript-eval($script)

return (
  test:assert-equal("Car", $result/thsr:term/fn:string()),
  test:assert-equal(3, fn:count($result/thsr:synonym))
)
```

### Multiple transactions in an XQuery test

MarkLogic extends the XQuery language to support multiple transactions in a single XQuery module 
[via the semicolon operator](https://docs.marklogic.com/guide/app-dev/transactions#id_11899). This can be 
leveraged in a test when it's beneficial to run a transaction that writes data and then run a separate transaction
that reads the data and verifies it. With a single transaction, the "read" operation won't be able to see the data
that was written as the transaction hasn't yet been committed. The semicolon operator can solve this problem by 
allowing you to run as many transactions as you'd like in a single test module.

## Writing setup and teardown files

marklogic-unit-test supports setup and teardown files for running custom code before and after test modules are run. 
A setup file can run before a suite starts or before each test starts, and a teardown file can run after a suite 
finishes or after each test finishes. Each of these files will be added to a test suite directory.

The table below defines the name of the file to add to a test suite directory based on the desired behavior and 
language. You are free to add any logic you would like to these files. For example, a common use case is to ensure a 
database is in a known state before and after a test finishes by either deleting or insert certain documents.

| File type  | JavaScript | JavaScript Modules | XQuery |
| --- | --- | --- | --- |
|Suite setup|suiteSetup.sjs|suiteSetup.mjs|suite-setup.xqy|
|Test setup|setup.sjs|setup.mjs|setup.xqy|
|Test teardown|teardown.sjs|teardown.mjs|teardown.xqy|
|Suite teardown|suiteTeardown.sjs|suiteTeardown.mjs|suite-teardown.xqy|

## Using a testing framework for endpoints

Most modern programming languages offer multiple testing frameworks for invoking HTTP endpoints and verifying the 
response. These frameworks can easily be used to verify the behavior of any custom HTTP endpoints you add to your 
MarkLogic application. When considering how to complement these frameworks with a testing framework like 
marklogic-unit-test, consider the following rule of thumb:

1. Use marklogic-unit-test to verify as many scenarios as possible, where the details of an HTTP request and 
   response do not matter. This involves identifying various kinds of inputs and ensuring the library function 
   returns the correct outputs.
2. Use an HTTP testing framework to verify HTTP-specific details, such as HTTP status codes. 

The above approach suggests the following approach for organizing your custom application code that you deploy to 
MarkLogic:

1. Keep your HTTP endpoints as lean as possible, delegating to application libraries for all non-HTTP-specific behavior.
2. Put as much non-HTTP-specific logic as possible into application libraries that can be easily and quickly tested 
   via marklogic-unit-test.
