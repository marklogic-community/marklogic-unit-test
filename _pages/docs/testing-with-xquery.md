---
layout: inner
title: Testing With XQuery
lead_text: ''
permalink: /docs/testing-with-xquery/
---

## Testing XQuery With XQuery

### Scenario 1 - Test assert all exist and this is a failing test case
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $count := 2
let $testSequence := (1,2)
return test:assert-all-exist($count, $testSequence, "Did not find expected number of items in the sequence")
```
### Scenario 2 - Test assert same values with same sequences for expected and actual. This is a success test case
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $expected := ("a","b","c")
let $actual := ("a","b","c")
return test:assert-same-values($expected, $actual)
```
### Scenario 3 - Test assert same values with different sequences for expected and actual. This is a failing test case
```
 xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $expected := ("a","d","c")
let $actual := ("a","b","c")
return test:assert-same-values($expected, $actual, "Expected values did not match with actual values")
```
### Scenario 4 - Test assert equal xml - all attributes and elements matched. This is a success test case
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $actual := <element attribute="attribute-value">element value</element>
let $expected := <element attribute="attribute-value">element value</element>

return test:assert-equal-xml($expected, $actual)
```
### Scenario 5 - Test assert equal xml - attributes mis-match. This is a failing test case
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $expected := <xml attribute="attribute-value-expected">expected value</xml>
let $actual := <xml attribute="attribute-value-unexpected">expected value</xml>
return test:assert-equal-xml($expected, $actual)
```
#### Scenario 6 - Test assert equal xml - element value mis-match. This is a failing test case
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $expected := <xml>expected value</xml>
let $actual := <xml>unexpected value</xml>
return test:assert-equal-xml($expected, $actual)
```
### Scenario 7 - Test assert equal JSON - Object node properties match. This is a success test case
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $expected := object-node {
  "firstProperty": "first value",
  "secondProperty": "second value"
}

let $actual := object-node {
  "firstProperty": "first value",
  "secondProperty": "second value"
}
return test:assert-equal-json($expected, $actual)
```
### Scenario 8 - Test assert equal JSON - Node property missing. This is a failing test case
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $expected := object-node {
  "firstProperty": "first value",
  "secondProperty": "second value",
  "thirdProperty": "third value"
}

let $actual := object-node {
  "firstProperty": "first value",
  "secondProperty": "second value"
}
return test:assert-equal-json($expected, $actual, "missing object node property thirdproperty in actual")
```
### Scenario 9 - Test assert equal JSON - Node value mismatch for one of the property. This is a failing test case
```
xquery version "1.0-ml";
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $expected := object-node {
  "firstProperty": "first value",
  "secondProperty": "second value",
  "thirdProperty": "third value"
}

let $actual := object-node {
  "firstProperty": "first value",
  "secondProperty": "second value",
  "thirdProperty": "unexpected value"
}

return test:assert-equal-json($expected, $actual)
This test fails because the actual JSON property 'thirdProperty' had a value of unexpected value, when the expected JSON property 'thirdProperty' had a value of third value.
```
### Scenario 10 - Test assert-http-get-status - Look for a document that doesn't exist after a valid authentication
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $url := "http://localhost:8000/v1/documents?uri=document_does_not_exist.xml"
let $options :=      
<options xmlns="xdmp:http">
   <authentication method="digest">
     <username>%%mlUsername%%</username>
     <password>%%mlPassword%%</password>
   </authentication>
</options>
let $status-code := 404
return test:assert-http-get-status( $url, $options, $status-code)
Note that the username and password are substituted from gradle.properties for authentication
```

## Test Server-side JavaScript with XQuery

You can write unit tests in XQuery to test code written in JavaScript. The one tricky part is that you can't import an .sjs module (such as the code you want to test) in XQuery. You can use [xdmp:javascript-eval()](https://docs.marklogic.com/xdmp:javascript-eval) to get around this. 

```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $actual := xdmp:javascript-eval(
  "var simple = require ('/lib/simple.sjs');

    simple.addOne(1);")

return (
  test:assert-equal(2, $actual)
)
```

This is very similar overall to testing XQuery with XQuery, except that generating the $actual response happens in an eval. 

