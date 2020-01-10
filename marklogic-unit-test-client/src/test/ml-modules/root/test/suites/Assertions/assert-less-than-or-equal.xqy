import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-less-than-or-equal(6, 6),
test:assert-less-than-or-equal(6, (3, 4, 5, 6)),
test:assert-throws-error-with-message(
  function() {
    test:assert-less-than-or-equal(6, 7)
  },
  "ASSERT-LESS-THAN-OR-EQUAL-FAILED",
  "actual: 7 is not less than or equal to value: 6"
),
test:assert-throws-error-with-message(
  function() {
    test:assert-less-than-or-equal(6, (5, 6, 7), "Failure message")
  },
  "ASSERT-LESS-THAN-OR-EQUAL-FAILED",
  "Failure message; actual: (5, 6, 7) is not less than or equal to value: 6"
)
