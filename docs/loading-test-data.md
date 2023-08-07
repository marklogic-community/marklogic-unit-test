---
layout: default
title: Loading test data
nav_order: 5
---

marklogic-unit-test includes a simple mechanism for loading test data specific to a test suite. Doing so is useful when 
a test or suite requires a set of documents to exist, and those documents may not apply to any other suite. 

To use this feature, begin by creating a folder named "test-data" within a test suite directory. Each file stored in the
"test-data" directory can then be loaded via marklogic-unit-test by specifying the name of the file.

For example, if a test suite's "test data" directory contains a file named `sample-doc.json`, the following could be 
added to either a `suiteSetup.sjs` or `setup.js` module for the test suite to load the file as a new document:

```
const test = require("/test/test-helper.xqy");
test.loadTestFile(
  "sample-doc.json", xdmp.database(), "/sample-doc.json",
  [xdmp.permission("rest-reader", "read", "element"), xdmp.permission("rest-writer", "update", "element")],
  ["collection1", "collection2"]
);
```

The same can be accomplished in XQuery via a `setup.xqy` module - this example also shows that the fourth and fifth
arguments for permissions and collections are optional:

```
import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
test:load-test-file("sample-doc.json", xdmp:database(), "/sample-doc.json")
```

The above examples can also be implemented in either `suiteSetup.sjs` or `suite-setup.xqy` if desired - see the 
[guide on writing tests](writing-tests.md) for more information on setup and teardown modules.

You can also use a teardown module to delete the data that was loaded. However, leaving data in place after a test 
concludes is often helpful for both manually verifying what it's in the database and for debugging test failures. 
Instead of deleting data after a test runs, consider deleting data before a test runs to ensure the database is in a 
"clean" state. For example, a suite setup module can be used to delete all documents in a database (perhaps excluding a 
collection of documents that are read-only and won't be impacted by any tests), and a setup module can insert certain
documents that may be modified by tests.

