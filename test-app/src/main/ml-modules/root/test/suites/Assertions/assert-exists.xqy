import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-exists("1"),
test:assert-exists(("1", "2")),
test:assert-exists(<a/>),

test:assert-throws-error-with-message(
  function() {
    test:assert-exists(())
  },
  "ASSERT-EXISTS-FAILED",
  "() does not exist"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-exists((), "Failure message")
  },
  "ASSERT-EXISTS-FAILED",
  "Failure message; () does not exist"
)
