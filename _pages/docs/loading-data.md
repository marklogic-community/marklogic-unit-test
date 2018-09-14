---
layout: inner
title: Loading Data
lead_text: ''
permalink: /docs/loading-data
---

## Loading Data

*TODO: replace Roxy content with ml-unit-test*

ML Unit Test simplifies loading data for your tests. Files to be loaded can be placed in a sub-directory of your test suite called `test-data`. The test helper provides a function which will automatically use this directory as the location of test files to be loaded.

     test:load-data-file(<name-of-file-to-be-loaded-without-path>,database id, <URI>)

example:

     test:load-test-file("test-article.xml", xdmp:database(), "/test-article.xml")

The first parameter should be set to the filename without any path elements. 
The database id can be determined by using the API `xdmp:database()`. You can also specify the name of the database as in input string to this function if need be. The URI will be the URI of the file in the database.

This should be included in the appropriate suite or test setup xquery file. In the corresponding teardown, remove the data files by referring to the URI.

```
let $name := "/test-article.xml"
return
  xdmp:document-delete($name)`
```

When loading data you 
* create the data in the `test-data` subdir mentioned above
* then load the data (and any test modules) by running `ml <env> deploy modules`. This copies all data to the Server
* at runtime the test data is loaded into your test-content-db from the modules database or filesystem if you are running out of the filesystem.  
 
