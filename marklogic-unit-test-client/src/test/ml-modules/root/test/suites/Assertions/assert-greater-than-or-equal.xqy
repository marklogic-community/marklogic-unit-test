import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-greater-than-or-equal(2, 2),
test:assert-greater-than-or-equal(2, (3, 4, 5, 6)),
test:assert-throws-error-with-message(
  function() {
    test:assert-greater-than-or-equal(2, 1)
  },
  "ASSERT-GREATER-THAN-OR-EQUAL-FAILED",
  "actual: 1 is not greater than or equal to value: 2"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-greater-than-or-equal(2, (1, 2, 3), "Failure message")
  },
  "ASSERT-GREATER-THAN-OR-EQUAL-FAILED",
  "Failure message; actual: (1, 2, 3) is not greater than or equal to value: 2"
)
