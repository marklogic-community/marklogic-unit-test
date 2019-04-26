import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-not-exists(()),
test:assert-throws-error-with-message(
  function() {
    test:assert-not-exists("a")
  },
  "ASSERT-NOT-EXISTS-FAILED",
  "Found unexpected items: ""a"""
),

test:assert-throws-error-with-message(
  function() {
    test:assert-not-exists("a", "Failure message")
  },
  "ASSERT-NOT-EXISTS-FAILED",
  "Failure message; Found unexpected items: ""a"""
)
