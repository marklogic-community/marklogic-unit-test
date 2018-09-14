---
layout: inner
title: Testing With Server-side JavaScript
lead_text: ''
permalink: /docs/testing-with-sjs
---

# Testing with Server-side JavaScript

Roxy can unit test XQuery with XQuery, SJS with XQuery, and SJS with SJS. (TODO) No testing XQuery with SJS yet. The examples below assume that /lib/simple.sjs exports a function called addOne(). 

    module.exports = {
      addOne: addOne
    };

    function addOne(value) {
      return value + 1;
    }

## Testing XQuery using SJS

TODO


## Testing Server-side JavaScript with Server-side JavaScript

There are a couple differences when using SJS to test SJS code. Below is an example. 

    var test = require('/test/test-helper.xqy');
    var simple = require('/lib/simple.sjs');

    function addOnePlusOne() {
      var actual = simple.addOne(1);
      return [
        test.assertEqual(2, actual),
        test.assertNotEqual(5, actual)
      ];
    };

    function addOnePlusTwo() {
      var actual = simple.addOne(2);
      return test.assertEqual(3, actual);
    };

    [].concat(
      addOnePlusOne(),
      addOnePlusTwo()
    )

We use `require` to import both the XQuery library module with the testing functions and the SJS module that defines the function we want to test. 

Two things to note: first, wrap your tests in [Immediately Invoked Function Expressions](http://en.wikipedia.org/wiki/Immediately-invoked_function_expression), or else call them explicitly after defining them. Although a function name is not technically necessary in an IIFE, it's useful when looking at the stack trace if a test fails. Either way, you must return the assert results and capture them. (Otherwise, the counts of successes and failures will be inaccurate.) 

Second, as with XQuery-based tests, you must return the results of the assert functions in order to get test counts. If you use more than one assert with a test, put them in an array. Note that you need a flat array, hence the use of `[].concat`. 

If you use IIFE, you can structure it like this: 

    let results = (function testOne() {
      // do stuff
      return [
        test.assert...(...),
        test.assert...(...)
      ];
    })();

    results = results.concat(
      (function testTwo() {
        // do stuff
        return [
          test.assert...(...),
          test.assert...(...)
        ]
      })();
    );
