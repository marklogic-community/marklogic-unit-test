---
layout: inner
title: Assert Functions
lead_text: ''
permalink: /docs/assertions/
---

## Assert Functions

The testing component has a [helper library](https://github.com/marklogic-community/marklogic-unit-test/blob/master/marklogic-unit-test-modules/src/main/ml-modules/root/test/test-helper.xqy) that provides several assert functions:

* assert-http-get-status($url as xs:string, $options as item()?, $status-code)
* assert-http-get-status($url as xs:string, $options as item()?, $status-code, $message as xs:string\*)
* assert-http-post-status($url as xs:string, $options as item()?, $data as node()?, $status-code)
* assert-http-post-status($url as xs:string, $options as item()?, $data as node()?, $status-code, $message as xs:string\*)
* assert-http-put-status($url as xs:string, $options as item()?, $data as node()?, $status-code)
* assert-http-put-status($url as xs:string, $options as item()?, $data as node()?, $status-code, $message as xs:string\*)
* assert-all-exist($expected-count as xs:unsignedInt, $actuals as item()\*)
* assert-all-exist($expected-count as xs:unsignedInt, $actuals as item()\*, $message as xs:string\*)
* assert-exists($item as item()\*)
* assert-exists($item as item()\*, $message as xs:string\*)
* assert-not-exists($item as item()\*)
* assert-not-exists($item as item()\*, $message as xs:string\*)
* assert-at-least-one-equal($expected as item()\*, $actual as item()\*)
* assert-at-least-one-equal($expected as item()\*, $actual as item()\*, $message as xs:string\*)
* assert-same-values($expected as item()\*, $actual as item()\*)
* assert-same-values($expected as item()\*, $actual as item()\*, $message as xs:string\*)
* assert-equal($expected as item()\*, $actual as item()\*)
* assert-equal($expected as item()\*, $actual as item()\*, $message as xs:string\*)
* assert-not-equal($not-expected as item()\*, $actual as item()\*)
* assert-not-equal($not-expected as item()\*, $actual as item()\*, $message as xs:string\*)
* assert-equal-xml($expected, $actual)
* assert-equal-xml($expected, $actual, $message as xs:string\*)
* assert-equal-json($expected, $actual)
* assert-equal-json($expected, $actual, $message as xs:string\*)
* assert-equal-json-recursive($object1, $object2) as xs:boolean
* assert-true($conditions as xs:boolean\*)
* assert-true($conditions as xs:boolean\*, $message as xs:string?)
* assert-false($conditions as xs:boolean\*)
* assert-false($conditions as xs:boolean\*, $message as xs:string\*)
* assert-meets-minimum-threshold($minimum as xs:decimal, $actual as xs:decimal+)
* assert-meets-minimum-threshold($minimum as xs:decimal, $actual as xs:decimal+, $message as xs:string\*)
* assert-meets-maximum-threshold($maximum as xs:decimal, $actual as xs:decimal+)
* assert-meets-maximum-threshold($maximum as xs:decimal, $actual as xs:decimal+, $message as xs:string?)
* assert-throws-error-with-message($function as xdmp:function, $expected-error-code as xs:string, $expected-message as xs:string)
* assert-throws-error-with-message($function as xdmp:function, $expected-error-code as xs:string, $expected-message as xs:string, $message as xs:string\*)
* assert-throws-error($function as xdmp:function)
* assert-throws-error($function as xdmp:function, $error-code as xs:string?)
* assert-throws-error($function as xdmp:function, $param as item()\*, $error-code as xs:string?)

It is good practice to use a specific assert function. So rather than:

```xquery
test:assert-equal(fn:true(), $actual)`
```

use this instead:

```xquery
test:assert-true($actual)`
```

Using specific asserts makes your intentions more clear to developers who read your test code. 
