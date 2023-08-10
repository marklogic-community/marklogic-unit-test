---
layout: default
title: Assertion functions
nav_order: 6
permalink: /docs/assertions
---

The list below captures the assertion functions available in the marklogic-unit-test `/test/test-helper.xqy` module.
You can also [browse the source code](https://github.com/marklogic-community/marklogic-unit-test/blob/master/marklogic-unit-test-modules/src/main/ml-modules/root/test/test-helper.xqy)
for this module to examine these functions.

```
assert-all-exist($expected-count as xs:unsignedInt, $actuals as item()*)
assert-all-exist($expected-count as xs:unsignedInt, $actuals as item()*, $message as xs:string*)
assert-at-least-one-equal($expected as item()*, $actual as item()*)
assert-at-least-one-equal($expected as item()*, $actual as item()*, $message as xs:string*)
assert-equal($expected as item()*, $actual as item()*)
assert-equal($expected as item()*, $actual as item()*, $message as xs:string*)
assert-equal-json($expected, $actual)
assert-equal-json($expected, $actual, $message as xs:string*)
assert-equal-json-recursive($object1, $object2) as xs:boolean
assert-equal-xml($expected, $actual)
assert-equal-xml($expected, $actual, $message as xs:string*)
assert-exists($item as item()*)
assert-exists($item as item()*, $message as xs:string*)
assert-false($conditions as xs:boolean*)
assert-false($conditions as xs:boolean*, $message as xs:string*)
assert-greater-than($value as xs:decimal, $actual as xs:decimal+)
assert-greater-than($value as xs:decimal, $actual as xs:decimal+, $message as xs:string*)
assert-greater-than-or-equal($minimum as xs:decimal, $actual as xs:decimal+)
assert-greater-than-or-equal($value as xs:decimal, $actual as xs:decimal+, $message as xs:string*)
assert-http-get-status($url as xs:string, $options as item()?, $status-code)
assert-http-get-status($url as xs:string, $options as item()?, $status-code, $message as xs:string*)
assert-http-post-status($url as xs:string, $options as item()?, $data as node()?, $status-code)
assert-http-post-status($url as xs:string, $options as item()?, $data as node()?, $status-code, $message as xs:string*)
assert-http-put-status($url as xs:string, $options as item()?, $data as node()?, $status-code)
assert-http-put-status($url as xs:string, $options as item()?, $data as node()?, $status-code, $message as xs:string*)
assert-less-than($value as xs:decimal, $actual as xs:decimal+)
assert-less-than($value as xs:decimal, $actual as xs:decimal+, $message as xs:string?)
assert-less-than-or-equal($maximum as xs:decimal, $actual as xs:decimal+)
assert-less-than-or-equal($value as xs:decimal, $actual as xs:decimal+, $message as xs:string?)
assert-not-equal($not-expected as item()*, $actual as item()*)
assert-not-equal($not-expected as item()*, $actual as item()*, $message as xs:string*)
assert-not-exists($item as item()*)
assert-not-exists($item as item()*, $message as xs:string*)
assert-same-values($expected as item()*, $actual as item()*)
assert-same-values($expected as item()*, $actual as item()*, $message as xs:string*)
assert-throws-error($function as xdmp:function)
assert-throws-error($function as xdmp:function, $error-code as xs:string?)
assert-throws-error($function as xdmp:function, $param1 as item()*, $error-code as xs:string?)
assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $error-code as xs:string?)
assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $error-code as xs:string?)
assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $error-code as xs:string?)
assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $param5 as item()*, $error-code as xs:string?)
assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $param5 as item()*, $param6 as item()*, $error-code as xs:string?)
assert-throws-error-with-message($function as xdmp:function, $expected-error-code as xs:string, $expected-message as xs:string)
assert-throws-error-with-message($function as xdmp:function, $expected-error-code as xs:string, $expected-message as xs:string, $message as xs:string*)
assert-true($conditions as xs:boolean*)
assert-true($conditions as xs:boolean*, $message as xs:string?)
```
