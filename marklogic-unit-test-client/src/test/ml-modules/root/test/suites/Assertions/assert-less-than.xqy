import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-less-than(6, 5),
test:assert-less-than(7, (3, 4, 5, 6)),
test:assert-throws-error-with-message(
  function() {
    test:assert-less-than(6, 6)
  },
  "ASSERT-LESS-THAN-FAILED",
  "actual: 6 is not less than value: 6"
),
test:assert-throws-error-with-message(
  function() {
    test:assert-less-than(6, 7)
  },
  "ASSERT-LESS-THAN-FAILED",
  "actual: 7 is not less than value: 6"
),
test:assert-throws-error-with-message(
  function() {
    test:assert-less-than(6, (5, 6, 7), "Failure message")
  },
  "ASSERT-LESS-THAN-FAILED",
  "Failure message; actual: (5, 6, 7) is not less than value: 6"
)
