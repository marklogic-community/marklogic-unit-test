import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-false(fn:false()),

test:assert-throws-error-with-message(
  function() {
    test:assert-false(fn:true())
  },
  "ASSERT-FALSE-FAILED",
  "condition was not false."
),

test:assert-throws-error-with-message(
  function() {
    test:assert-false((fn:false(), fn:true()), "Failure message")
  },
  "ASSERT-FALSE-FAILED",
  "Failure message; condition was not false."
)
