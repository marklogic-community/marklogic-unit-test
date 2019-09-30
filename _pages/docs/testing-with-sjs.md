---
layout: inner
title: Testing With Server-side JavaScript
lead_text: ''
permalink: /docs/testing-with-sjs/
---

# Testing with Server-side JavaScript

You can use ML Unit Test to test library modules written in SJS or in XQuery. 

Your tests need to return the results of calling assertion functions. To do this with JavaScript tests, build an array
of assertion results and return the array. Note that this needs to be a flat array -- that is, an array of assertion
results, not an array of arrays of assertion results. 

The assertion functions compare expected results with the actual results. If the result of calling the function that 
you're testing is complex enough to warrant multiple assertions, a convention is to hold the results in a variable 
called `actual`. This makes it clear to those reading your tests exactly what is being tested. 

## Testing JavaScript with JavaScript

Here's an example of testing a JavaScript module with a JavaScript test. Assume that the module `fibonacci.sjs` exposes a
function called `getFibbed` that returns a specified number of values from the Fibonacci sequence. The function takes
two parameters: the index of the first number in the sequence to return and the number of values to return. The values 
are to be returned in an array. The index is one-based. 

```javascript
const test = require('/test/test-helper.xqy');
const fib = require('/lib/fibonacci.sjs');

let assertions = [];

// Scenario 1: start at the beginning, get back a few numbers

let actual = fib.getFibbed(1, 4);

assertions.push(
  test.assertEqual(4, actual.length),
  test.assertEqual(1, actual[0]),
  test.assertEqual(1, actual[1]),
  test.assertEqual(2, actual[2]),
  test.assertEqual(3, actual[3])
);

// Scenario 2: start later in the sequence

let actual = fib.getFibbed(3, 3);

assertions.push(
  test.assertEqual(3, actual.length),
  test.assertEqual(2, actual[0]),
  test.assertEqual(3, actual[1]),
  test.assertEqual(5, actual[2])
);

assertions
```

Note that the last line returns the `assertions` array. 

### Testing For Expected Errors

```javascript
const test = require('/test/test-helper.xqy');

try {
    throw "wrong error message";
} catch (error) {
    test.assertEqual("expected error message", error, "Did not find expected error message");
}
```

## Testing XQuery using SJS

ML Unit Test also allows you to test XQuery library modules with JavaScript. If the `getFibbed` function above was 
written in XQuery, the code to test it is very similar. In the library module `/lib/fibonacci.xqy`, the function was
likely called `get-fibbed` and exists in some namespace. JavaScript modules can `require` XQuery modules to load them.
The namespace is essentially ignored, and names are converted from "worm case" (`get-fibbed`) to camel case 
(`getFibbed`). Thus the testing code is nearly identical, except that the required module has a `.xqy` extension. 

```javascript
const test = require('/test/test-helper.xqy');
const fib = require('/lib/fibonacci.xqy');

let assertions = [];

// Scenario 1: start at the beginning, get back a few numbers

let actual = fib.getFibbed(1, 4);

assertions.push(
  test.assertEqual(4, actual.length),
  test.assertEqual(1, actual[0]),
  test.assertEqual(1, actual[1]),
  test.assertEqual(2, actual[2]),
  test.assertEqual(3, actual[3])
);

// Scenario 2: start later in the sequence

let actual = fib.getFibbed(3, 3);

assertions.push(
  test.assertEqual(3, actual.length),
  test.assertEqual(2, actual[0]),
  test.assertEqual(3, actual[1]),
  test.assertEqual(5, actual[2])
);

assertions
```