import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-true(fn:true()),
test:assert-true((fn:true(), fn:true())),
test:assert-true((fn:true(), fn:true()), "Failure message"),

test:assert-throws-error(
  function() {
    test:assert-true(fn:false())
  },
  "ASSERT-TRUE-FAILED"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-true((fn:true(), fn:false()))
  },
  "ASSERT-TRUE-FAILED",
  "Condition was not true."
),

test:assert-throws-error-with-message(
  function() {
    test:assert-true(fn:false(), "Failure message")
  },
  "ASSERT-TRUE-FAILED",
  "Failure message; Condition was not true."
)
