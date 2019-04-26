import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-meets-maximum-threshold(6, 6),
test:assert-meets-maximum-threshold(6, (3, 4, 5, 6)),
test:assert-throws-error-with-message(
  function() {
    test:assert-meets-maximum-threshold(6, 7)
  },
  "ASSERT-MEETS-MAXIMUM-THRESHOLD-FAILED",
  "actual: 7 is greater than maximum: 6"
),
test:assert-throws-error-with-message(
  function() {
    test:assert-meets-maximum-threshold(6, (5, 6, 7), "Failure message")
  },
  "ASSERT-MEETS-MAXIMUM-THRESHOLD-FAILED",
  "Failure message; actual: (5, 6, 7) is greater than maximum: 6"
)
