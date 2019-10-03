---
layout: inner
title: Assert Functions
lead_text: ''
permalink: /docs/assertions/
---

# Assert Functions

The testing component has a [helper library](https://github.com/marklogic-community/marklogic-unit-test/blob/master/marklogic-unit-test-modules/src/main/ml-modules/root/test/test-helper.xqy) that provides several assert functions:

## Assert Exists

### JavaScript:

```javascript
test.assertExists(
  $item as Object[],
  [$message as String[]]
)
```

### XQuery:

```xquery
test:assert-exists(
  $item as item()*,
  [$message as xs:string*]
)
```

## Assert Not Exists

### JavaScript:

```javascript
test.assertNotExists(
  item as Object[], 
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-not-exists(
  $item as item()*, 
  []$message as xs:string*]
)
```

## Assert All Exist

### JavaScript:

```javascript
test.assertAllExist(
  expectedCount as Number,
  actual as Object[],
  [$message as String[]]
)
```

### XQuery:

```xquery
test:assert-all-exist(
  $expected-count as xs:unsignedInt,
  $actual as item()*,
  [$message as xs:string*]
)
```
## Assert Equal

### JavaScript:

```javascript
test.assertEqual(
  expected as Object[],
  actual as Object[],
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-equal(
  $expected as item()*,
  $actual as item()*,
  [$message as xs:string*]
)
```

## Assert Not Equal

### JavaScript:

```javascript
test.assertNotEqual(
  notExpected as [],
  actual as [],
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-not-equal(
  $not-expected as item(),
  $actual as item()*,
  [$message as xs:string*])
```

## Assert At Least One Equal

### JavaScript:

```javascript
test.assertAtLeastOneEqual(
  expected as Object[],
  actual as Object[],
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-at-least-one-equal(
  $expected as item()*,
  $actual as item()*,
  [$message as xs:string*]
)
```

## Assert At Least One Equal

This assertion will compare two different arrays or sequences of values and return true
if they contain the same values, regardless of the order of the values in the array or sequence.

### JavaScript:

```javascript
test.assertSameValues(
  expected as Object[],
  actual as Object[],
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-same-values(
  $expected as item()*,
  $actual as item()*,
  [$message as xs:string*]
)
```
## Assert Equal XML

### JavaScript:

```javascript
test.assertEqualXml(
  expected as Node,
  actual as Node,
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-equal-xml(
  $expected as Node,
  $actual as Node,
  [$message as xs:string*]
)
```

## Assert Equal JSON

### JavaScript:

```javascript
test.assertEqualJson(
  expected,
  actual,
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-equal-json(
  $expected,
  $actual,
  [$message as xs:string*]
)
```

## Assert True

### JavaScript:

```javascript
test.assertTrue(
  condition as Boolean[],
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-true(
  $condition as xs:boolean*,
  [$message as xs:string*]
)
```

## Assert False

### JavaScript:

```javascript
test.assertFalse(
  condition as Boolean[],
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-false(
  $condition as xs:boolean*,
  [$message as xs:string*]
)
```

## Assert Meets Minimum Threshold
Fails if any number in the actual set of numbers is less than the minimum

### JavaScript:

```javascript
test.assertMeetsMinimumThreshold(
  minimum as Number,
  actual as Number[],
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-meets-minimum-threshold(
  $minimum as xs:decimal,
  $actual as xs:decimal+,
  [$message as xs:string*]
)
```

## Assert Meets Maximum Threshold
Fails if any number in the actual set of numbers is greater than the maximum

### JavaScript:

```javascript
test.assertMeetsMaximumThreshold(
  maximum as Number,
  actual as Number[],
  [message as String[]]
)
```

### XQuery:

```xquery
test:assert-meets-maximum-threshold(
  $maximum as xs:decimal,
  $actual as xs:decimal+,
  [$message as xs:string*]
)
```

## Assert Throws Error with Message
Fails if any number in the actual set of numbers is greater than the maximum

### JavaScript:

Since this method is implemented in XQuery it cannot invoke a JavaScript method.  Therefore for JavaScript it is
recommend to use a try catch block as follows:
```javascript
try {
  throw "error!";
} catch(error) {
  test.assertEqual("expected error", error, "Did not find the expected error");
}
```

### XQuery:

```xquery
test:assert-throws-error-with-message(
  $function as xdmp:function,
  $expected-error-code as xs:string,
  $expected-message as xs:string,
  [$message as xs:string*]
)
```

## Assert HTTP GET Status

### JavaScript:

```javascript
test.assertHttpGetStatus(
   url as String,
   options as Object,
   statusCode as Number,
   [message as String]
 )
```

### XQuery:

 ```xquery
 test:assert-http-get-status(
   $url as xs:string,
   $options as item()?,
   $status-code,
   [$message as xs:string*]
 )
```

## Assert HTTP POST Status

### JavaScript:

```javascript
test.assertHttpPostStatus(
   url as String,
   options as Object,
   statusCode as Number,
   [message as String]
 )
```

### XQuery:

 ```xquery
 test:assert-http-post-status(
   $url as xs:string,
   $options as item()?,
   $status-code,
   [$message as xs:string*]
 )
```

## Assert HTTP PUT Status

### JavaScript:

```javascript
test.assertHttpPutStatus(
   url as String,
   options as Object,
   statusCode as Number,
   [message as String]
 )
```

### XQuery:

 ```xquery
 test:assert-http-put-status(
   $url as xs:string,
   $options as item()?,
   $status-code,
   [$message as xs:string*]
 )
```

It is good practice to use a specific assert function. So rather than use the more generic `assert-equal()` function to 
test that a value is true, use the `assert-true()`.

Instead of this:


```xquery
test:assert-equal(fn:true(), $actual) (: bad :)
```

Do this instead:

```xquery
test:assert-true($actual) (: good :)
```
