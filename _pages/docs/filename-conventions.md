---
layout: inner
title: Filename Conventions
lead_text: ''
permalink: /docs/conventions/
---

## Filename Conventions
By convention, a test suite corresponds to a library module in your application. To get started, create a directory 
under src/test/suites/ named for your library module. 

Inside your test suite, you can create four specially-named files: 
* `setup.xqy`/`setup.sjs` - This module will be run before each test in your suite. Here you might insert a document 
into the test database that each of your tests will modify. 
* `teardown.xqy`/`teardown.sjs` - This module will run after each test in your suite. You might use this module to 
remove the document inserted by `setup.xqy`/`setup.sjs`. 
* `suite-setup.xqy`/`suiteSetup.sjs` - Run once when your suite is started. You can use this to insert some data that 
will not be modified over the course of the suite's tests. 
* `suite-teardown.xqy`/`suiteTeardown.sjs` - Run once when your suite is finished, to clean up after the suite's tests. 

You create your test modules in the test suite directory. Typically, a module has responsibility for testing a 
particular function. 

You can also create subdirectories in your test suite. The testing component will ignore these, so they are a good 
place for supporting files, like test data. Test data should be placed in a subdirectory called `test-data`.

As an example, consider a hypothetical library module that converts Comma Separated Values (CSV) to XML called 
`csv-lib.xqy`. Let's suppose it has a function called convert. We might test that with files like the following:

* suites/csv-lib/suite-setup.xqy
* suites/csv-lib/convert.xqy
* suites/csv-lib/suite-teardown.xqy
* suites/csv-lib/test-data/td.xqy

Why put test data into a separate module and not into `suite-setup.xqy`/`suiteSetup.sjs`? Because this way, setup, teardown and the test(s) can all refer to the same data source, making it easier to update the tests. 

