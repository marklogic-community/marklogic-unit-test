const test = require('/test/test-helper.xqy');

function assertThrowsErrorWithMessage(f, errorName, errorMessage)
{
  try {
    f();
    test.fail('Function did not fail');
  }
  catch (e) {
    xdmp.log(e, 'info');
    let actual = e.stack.substr(0, e.stack.indexOf(" at "))
    if (!e.stack.includes(errorName)) {
      test.fail(`Function failed, but did not contain expected error [${errorName}] actual: [${actual}]`);
    }
    if (!e.stack.includes(errorMessage)) {
      test.fail(`Function failed, but did not contain expected message [${errorMessage}] actual [${actual}]`);
    }
    return test.success();
  }
}

[
  test.assertSameValues([], []),
  test.assertSameValues([1], [1]),
  test.assertSameValues([1, 2, 4, 3], [3, 4, 1, 2]),
  test.assertSameValues([1, 2, 4, 3, 4], [3, 4, 1, 4, 2]),
  test.assertSameValues(["A", "F", "BG", "E", "BC"], ["BC", "F", "A", "E", "BG"]),
  assertThrowsErrorWithMessage(
    function() {
      test.assertSameValues([1, 2, 4, 5], [1, 2, 4, 5, 5], "An array with a duplicate should not equal an array without that duplicate.")
    },
    "ASSERT-EQUAL-FAILED",
    "An array with a duplicate should not equal an array without that duplicate.; expected: (1, 2, 4, ...) actual: (1, 2, 4, ...)"
  ),
  assertThrowsErrorWithMessage(
    function() {
      test.assertSameValues([1, 2, 4], [1, 2, 4, 5], "A longer Actual array should not equal a shorter Expected array.")
    },
    "ASSERT-EQUAL-FAILED",
    "A longer Actual array should not equal a shorter Expected array.; expected: (1, 2, 4) actual: (1, 2, 4, ...)"
  ),
  assertThrowsErrorWithMessage(
    function() {
      test.assertSameValues([1, 2, 4], [1, 2], "A shorter Actual array should not equal a longer Expected array.")
    },
    "ASSERT-EQUAL-FAILED",
    "A shorter Actual array should not equal a longer Expected array.; expected: (1, 2, 4) actual: (1, 2)"
  ),
  assertThrowsErrorWithMessage(
    function() {
      test.assertSameValues([1, 2, 4], [1, 2, "S"], "This actually causes an exception since the items are not comparable.")
    },
    "err:XPTY0004",
    "Items not comparable"
  ),
  assertThrowsErrorWithMessage(
    function() {
      test.assertSameValues([{"A": "a"}, {"B": "b"}], [{"B": "b"}, {"A": "a"}], "This actually causes an exception since we do not handle JSON objects and the items are not comparable.")
    },
    "err:XPTY0004",
    "Items not comparable"
  )
]
