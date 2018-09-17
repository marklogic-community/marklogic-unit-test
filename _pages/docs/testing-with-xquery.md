---
layout: inner
title: Testing With XQuery
lead_text: ''
permalink: /docs/testing-with-xquery/
---

# Testing With XQuery

*TODO*

## Testing XQuery With XQuery

*TODO*

## Test Server-side JavaScript with XQuery

*TODO: is this information current?*

You can write unit tests in XQuery to test code written in JavaScript. The one tricky part is that you can't import an .sjs module (such as the code you want to test) in XQuery. You can use [xdmp:javascript-eval()](https://docs.marklogic.com/xdmp:javascript-eval) to get around this. 

```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

let $actual := xdmp:javascript-eval(
  "var simple = require ('/lib/simple.sjs');

    simple.addOne(1);")

return (
  test:assert-equal(2, $actual)
)
```

This is very similar overall to testing XQuery with XQuery, except that generating the $actual response happens in an eval. 

