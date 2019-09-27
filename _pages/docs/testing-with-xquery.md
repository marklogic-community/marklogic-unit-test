---
layout: inner
title: Testing With XQuery
lead_text: ''
permalink: /docs/testing-with-xquery/
---

## Testing XQuery With XQuery

### Scenario 1 - Test assert all exist with assert-equal for success
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

let $count := 2
let $testSequence := (1,2)
let $result := test:assert-all-exist($count, $testSequence)
return test:assert-equal($result/@type/string(), "success")
```
### Scenario 2 - Test assert all exist with assert-equal for exception error
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
declare namespace error = "http://marklogic.com/xdmp/error";

let $count := 3
let $testSequence := (1,2)
let $errorMessage := "Assert All Exist failed"
let $result := 
try{
  test:assert-all-exist($count, $testSequence)
} catch($err) {
  $err
}
return test:assert-equal($result//error:code/string(), $errorMessage)
```
### Scenario 3 - Test assert same values with same sequences for left and right
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

let $leftSequence := ("a","b","c")
let $rightSequence := ("a","b","c")
return test:assert-same-values($leftSequence, $rightSequence)
```
### Scenario 4 - Test assert same values with different sequences for left and right. This generates an exception that is validated with the actual value to get success status
```
 xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
declare namespace error = "http://marklogic.com/xdmp/error";

let $leftSequence := ("a","d","c")
let $rightSequence := ("a","b","c")
let $formattedErrorMessage := "Assert Equal failed (ASSERT-EQUAL-FAILED): a c d a b c"
return 
try{
  test:assert-same-values($leftSequence, $rightSequence)
} catch($err) {
  test:assert-equal($err//error:format-string/string(), $formattedErrorMessage)
}
```
### Scenario 5 - Test assert equal xml - all attributes and elements matched
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
declare namespace t = "http://marklogic.com/roxy/test";

let $actual := <t:test type="actual" xmlns:t="http://marklogic.com/roxy/test"><code>abc</code></t:test>
let $expected := <t:test  type="actual" xmlns:t="http://marklogic.com/roxy/test"><code>abc</code></t:test>
return
try{
	test:assert-equal-xml($actual, $expected)
} catch($err) {
 $err
}
```
### Scenario 6 - Test assert equal xml - attributes mis-match and test expected error
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
declare namespace t = "http://marklogic.com/roxy/test";
declare namespace error = "http://marklogic.com/xdmp/error";

let $actual := <t:test type="actual" xmlns:t="http://marklogic.com/roxy/test"><code>abc</code></t:test>
let $expected := <t:test  type="expected" xmlns:t="http://marklogic.com/roxy/test"><code>abc</code></t:test>
let $errorMessageExpected := "Assert Equal failed (ASSERT-EQUAL-FAILED): actual expected  :  mismatched attribute text ($expected= /t:test/@type , $actual= /t:test/@type )"
return
try{
	test:assert-equal-xml($actual, $expected)
} catch($err) {
 test:assert-equal($err/error:format-string/string(), $errorMessageExpected)
}
```
#### Scenario 7 - Test assert equal xml - element value mis-match and test expected error
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
declare namespace t = "http://marklogic.com/roxy/test";
declare namespace error = "http://marklogic.com/xdmp/error";

let $actual := <t:test type="actual" xmlns:t="http://marklogic.com/roxy/test"><code>abc</code></t:test>
let $expected := <t:test  type="actual" xmlns:t="http://marklogic.com/roxy/test"><code>abcd</code></t:test>
let $errorMessageExpected := "Assert Equal failed (ASSERT-EQUAL-FAILED): abc abcd  :  mismatched element text ($expected= /t:test/code , $actual= /t:test/code )"
return
try{
	test:assert-equal-xml($actual, $expected)
} catch($err) {
 test:assert-equal($err/error:format-string/string(), $errorMessageExpected)
}
```
### Scenario 8 - Test assert equal JSON - same json node and values as json object
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

let $actual := json:object()
let $_ := map:put($actual,"a",111)
let $_ := map:put($actual,"b",222)

let $expected := json:object()
let $_ := map:put($expected,"a",111)
let $_ := map:put($expected,"b",222)

return
try{
	test:assert-equal-json($actual, $expected)
} catch($err) {
 $err
}
```
### Scenario 9 - Test assert equal JSON - same json node and values as json document
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

let $actual := json:object()
let $_ := map:put($actual,"a",111)
let $_ := map:put($actual,"b",222)

let $actualJson := xdmp:to-json($actual)
let $expected := json:object()
let $_ := map:put($expected,"a",111)
let $_ := map:put($expected,"b",222)
let $expectedJson := xdmp:to-json($expected)

return
try{
	test:assert-equal-json($actualJson, $expectedJson)
} catch($err) {
 $err
}
```
### Scenario 10 - Test assert equal JSON - Node mismatch as json document and validate expected error message
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

let $actual := json:object()
let $_ := map:put($actual,"a",111)
let $_ := map:put($actual,"b",222)
let $_ := map:put($actual,"c",333)

let $actualJson := xdmp:to-json($actual)
let $expected := json:object()
let $_ := map:put($expected,"a",111)
let $_ := map:put($expected,"b",222)
let $expectedJson := xdmp:to-json($expected)
let $errorMessageExpected := "Assert Equal Json failed (ASSERT-EQUAL-JSON-FAILED): " || $actualJson || " " || $expectedJson
return
try{
	test:assert-equal-json($actualJson, $expectedJson)
} catch($err) {
 test:assert-equal($err/error:format-string/string(), $errorMessageExpected)
}
```
### Scenario 11 - Test assert equal JSON - Node value mismatch as json document and validate expected error message
```
xquery version "1.0-ml";
import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

let $actual := json:object()
let $_ := map:put($actual,"a",111)
let $_ := map:put($actual,"b",222)
let $_ := map:put($actual,"c",333)

let $actualJson := xdmp:to-json($actual)
let $expected := json:object()
let $_ := map:put($expected,"a",111)
let $_ := map:put($expected,"b",222)
let $_ := map:put($expected,"c",444)
let $expectedJson := xdmp:to-json($expected)
let $errorMessageExpected := "Assert Equal Json failed (ASSERT-EQUAL-JSON-FAILED): " || $actualJson || " " || $expectedJson
return
try{
test:assert-equal-json($actualJson, $expectedJson)
} catch($err) {
 test:assert-equal($err/error:format-string/string(), $errorMessageExpected)
}
```
### Scenario 12 - Test assert http get status - Look for a document that does n't exist after a valid authentication with correct user name and passwd
```
xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

let $url := "http://localhost:8000/v1/documents?uri=document_does_not_exist.xml"
let $options :=      
<options xmlns="xdmp:http">
   <authentication method="digest">
     <username>admin</username>
     <password>admin</password>
   </authentication>
</options>
let $status-code := 404

return
try {
  test:assert-http-get-status( $url, $options, $status-code)
} catch ($err) {
  $err
}
```

## Test Server-side JavaScript with XQuery

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

