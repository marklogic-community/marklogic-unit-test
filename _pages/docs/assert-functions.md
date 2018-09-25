---
layout: inner
title: Assert Functions
lead_text: ''
permalink: /docs/assertions/
---

## Assert Functions

*TODO: check whether this list is up to date*

The testing component has a [helper library](https://github.com/marklogic-community/marklogic-unit-test/blob/master/marklogic-unit-test-modules/src/main/ml-modules/root/test/test-helper.xqy) that provides several assert functions:
* assert-true($supposed-truths as xs:boolean\*)
* assert-true($supposed-truths as xs:boolean\*, $msg as item()\*)
* assert-false($supposed-falsehoods as xs:boolean\*)
* assert-equal($expected as item()\*, $actual as item()\*)
* assert-not-equal($expected as item()\*, $actual as item()\*)
* assert-exists($item as item()\*)
* assert-all-exist($count as xs:unsignedInt, $item as item()\*)
* assert-not-exists($item as item()\*)
* assert-at-least-one-equal($expected as item()\*, $actual as item()\*)
* assert-same-values($expected as item()\*, $actual as item()\*) - Return true if and only if the two sequences have the same values, regardless of order.
* assert-meets-minimum-threshold($expected as xs:decimal, $actual as xs:decimal+)
* assert-meets-maximum-threshold($expected as xs:decimal, $actual as xs:decimal+)
* assert-throws-error($function as xdmp:function)
* assert-throws-error($function as xdmp:function, $error-code as xs:string?)
* assert-throws-error($function as xdmp:function, $params as item()\*, $error-code as xs:string?)
* assert-http-get-status($url as xs:string, $options as element(xdmp-http:options), $status-code)

It is good practice to use a specific assert function. So rather than:

```xquery
test:assert-equal(fn:true(), $actual)`
```

use this instead:

```xquery
test:assert-true($actual)`
```

Using specific asserts makes your intentions more clear to developers who read your test code. 
