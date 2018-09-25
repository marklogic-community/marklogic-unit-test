---
layout: inner
title: Loading Data
lead_text: ''
permalink: /docs/loading-data/
---

## Loading Data

*TODO: replace Roxy content with marklogic-unit-test*

MarkLogic Unit Test simplifies loading data for your tests. Files to be loaded can be placed in a sub-directory of your test suite called `test-data`. The test helper provides a function which will automatically use this directory as the location of test files to be loaded.

    test:load-data-file(<name-of-file-to-be-loaded-without-path>,database id, <URI>)

Suppose our test suite has a `lib/lib.xqy` file that declares a variable `$URI` with the value "/test-article.xml". Our
setup script could look like this in JavaScript:

```javascript
const test = require("/test/test-helper.xqy");
const lib = require("lib/lib.xqy");

test.loadTestFile("test-article.xml", xdmp.database(), lib.URI);
```

... and in XQuery:

```xquery
import module namespace test = "http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
import module namespace lib = "http://example.com/test/lib" at "lib/lib.xqy";

test:load-test-file("test-article.xml", xdmp:database(), $lib:URI)
```

The first parameter should be set to the filename without any path elements. 

The database id can be determined by using the API `xdmp:database()`. You can also specify the name of the database as in input string to this function if need be. The URI will be the URI of the file in the database.

This should be included in the appropriate suite or test setup JavaScript or XQuery file. In the corresponding 
teardown, remove the data files by referring to the URI.

teardown.sjs:

```javascript
const lib = require("lib/lib.xqy");

xdmp.documentDelete(lib.URI);
```

teardown.xqy:

```
import module namespace lib = "http://example.com/test/lib" at "lib/lib.xqy";

xdmp:document-delete($lib:URI)
```

When loading data you 
* create the data in the `test-data` subdir mentioned above
* then load the data (and any test modules) by running `gradle mlLoadModuels`. This loads all modules, including the data files. 
* at runtime the test data is loaded into your test-content-db from the modules database (or filesystem if you are running out of the filesystem). 
 