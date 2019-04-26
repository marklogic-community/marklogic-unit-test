import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-meets-minimum-threshold(2, 2),
test:assert-meets-minimum-threshold(2, (3, 4, 5, 6)),
test:assert-throws-error-with-message(
  function() {
    test:assert-meets-minimum-threshold(2, 1)
  },
  "ASSERT-MEETS-MINIMUM-THRESHOLD-FAILED",
  "actual: 1 is less than minimum: 2"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-meets-minimum-threshold(2, (1, 2, 3), "Failure message")
  },
  "ASSERT-MEETS-MINIMUM-THRESHOLD-FAILED",
  "Failure message; actual: (1, 2, 3) is less than minimum: 2"
)
