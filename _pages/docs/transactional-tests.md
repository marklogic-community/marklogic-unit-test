---
layout: inner
title: Transactional Unit Tests
lead_text: ''
permalink: /docs/transactional
---

# Transactional Unit Tests

*TODO: best practice check; differences for SJS?*

Sometimes your unit tests will need to commit a transaction and check the results. Here's how to go about it. 

Scenario: suppose you have `tag-lib.xqy`, which manages tags in your documents. In `tag-lib.xqy`, you have 
`tag:add($docid, $tag)`, which will add the tag to the matching document if the tag isn't already there, and do nothing 
if it already is. 

## The problem
In your unit test, you call the `tag:add()` function and update the target document. The problem is that the change 
won't be visible until the transaction completes, as discussed [in the Application Developer's Guide][transactions]. 
To be an effective test, we need to check that the results were written correctly. 

## Solutions

We'll assume we have a suite called tag-lib (`src/test/suites/tag-lib/`) and that we'll test the `tag:add` function in 
`add.xqy`. 

### First Approach: setup.xqy
The first approach is to create a document in `setup.xqy` (a simple `xdmp:document-insert` with a fixed URL and a basic 
sample document). You'll use `setup.xqy` instead of `suite-setup.xqy`, because `setup.xqy` will be run before each test, 
overwriting the result of your change. 

In your test module, `add.xqy`, you'll import `tag-lib.xqy` and call the `tag:add` function. If all goes well, the 
document will get updated with the new tag. In order to see it, we need to end the transaction and start a new one. We 
can use the semicolon operator for this. 

```
(: tag.xqy :)
import module namespace tag = "http://marklogic.com/roxy/tag-lib" at "/app/modules/tag-lib.xqy";
tag:add("/test1.xml", "tag1")

;

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
test:assert-exists(fn:doc("/test1.xml")/doc/meta/tags/tag[./text() = "tag1"]`
```

(Note that to isolate knowledge of how tags are stored, you might want to use a tag module function to retrieve it. The tradeoff is that if the retrieving function breaks, it will look like `add()` doesn't work either.)

Anyway, the semicolon ends one transaction, allowing the change to be fully committed. Then in the second transaction 
(after the semicolon), we can check whether or not it worked. 

### Second approach: test-specific setup and teardown
The first approach sets up data for all tests. You might have a test that needs data that are different from the of 
the test suite, and thus you don't want to put it into setup.xqy (or suite-setup.xqy). This second pattern shows you 
how to do this. 

In a nutshell, you'll use four transactions (three semicolons) within your test module: setup, test, verify, and teardown. 

```
(: add.xqy
  : setup
  :)
xdmp:document-insert("/test1.xml", 
  <doc>
    <meta>
      <tags/>
    </meta>
  </doc>)

;

(: test :)
import module namespace tag = "http://marklogic.com/roxy/tag-lib" at "/app/modules/tag-lib.xqy";

try {
  tag:add("/test1.xml", "tag1")
} catch ($e) {
  xdmp:log("tag:add() threw an exception: " || xdmp:quote($e))
}

;

(: verify :)
import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

try {
  test:assert-exists(fn:doc("/test1.xml")/doc/meta/tags/tag[./text() = "tag1"])
} catch ($e) {
  if (fn:matches($e/error:name, "ASSERT-.*-FAILED")) then
    xdmp:rethrow()
  else
    xdmp:log("tag:add() verification threw an exception: " || xdmp:quote($e))
}

;

(: teardown :)
xdmp:document-delete("/test1.xml")
```

Note the try/catches in the test and verify stages. The reason for these is that if an exception were thrown and not 
caught, the teardown section would not get run, polluting your test database with something that's not supposed to be 
there. If one of the assertions fails, that will trigger an exception. If the exception is a failed assertion, we need 
to rethrow to make sure the results get counted. Otherwise, everything can look okay even when there is a failing test. 

*Note from Dave Cassel: this second approach can be a bit error prone, with mistakes leading to quietly failing tests. Based on that, I'd use the first approach whenever possible.*

[transactions]: http://docs.marklogic.com/guide/app-dev/transactions#id_85012
