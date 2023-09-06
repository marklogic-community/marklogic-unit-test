xquery version "1.0-ml";
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

((
  test:assert-same-values(
    array-node { },
    array-node { },
    "Two empty arrays, should be equal."
  )
,
  test:assert-same-values(
    array-node { 1 },
    array-node { 1 },
    "Two arrays with the same single elements, should be equal."
  )
,
  test:assert-same-values(
    array-node { 1, 2, 4, 3 },
    array-node { 3, 4, 1, 2 },
    "Two arrays with the same elements, in a different order, should be equal."
  )
,
  test:assert-same-values(
    array-node { 1, 2, 4, 3, 4 },
    array-node { 3, 4, 1, 4, 2 },
    "Two arrays with the same elements (including duplicates), in a different order, should be equal."
  )
,
  test:assert-same-values(
    array-node { "A", "F", "BG", "E", "BC" },
    array-node { "BC", "F", "A", "E", "BG" },
    "Two arrays with the same string elements, in a different order, should be equal."
  )
,
  test:assert-throws-error-with-message(
    function() {
      test:assert-same-values(
        array-node { 1, 2, 4, 5 },
        array-node { 1, 2, 4, 5, 5 },
        "An array with a duplicate should not equal an array without that duplicate."
      )
    },
    "ASSERT-EQUAL-FAILED",
    "An array with a duplicate should not equal an array without that duplicate.; expected: (1, 2, 4, ...) actual: (1, 2, 4, ...)"
  )
,
  test:assert-throws-error-with-message(
    function() {
      test:assert-same-values(
        array-node { 1, 2, 4 },
        array-node { 1, 2, 4, 5 },
        "A longer Actual array should not equal a shorter Expected array."
      )
    },
    "ASSERT-EQUAL-FAILED",
    "A longer Actual array should not equal a shorter Expected array.; expected: (1, 2, 4) actual: (1, 2, 4, ...)"
  )
,
  test:assert-throws-error-with-message(
    function() {
      test:assert-same-values(
        array-node { 1, 2, 4 },
        array-node { 1, 2 },
        "A shorter Actual array should not equal a longer Expected array."
      )
    },
    "ASSERT-EQUAL-FAILED",
    "A shorter Actual array should not equal a longer Expected array.; expected: (1, 2, 4) actual: (1, 2)"
  )
,
  test:assert-throws-error-with-message(
    function() {
      test:assert-same-values(
        array-node { 1, 2, 4 },
        array-node { 1, 2, object-node {"A": "4"} },
        "This actually causes an exception since the items are not comparable."
      )
    },
    "err:XPTY0004",
    "Items not comparable"
  )
))
