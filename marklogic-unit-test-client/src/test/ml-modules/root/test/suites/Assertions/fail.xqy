import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-throws-error-with-message(
  function() {
    test:fail("Failure message")
  },
  "USER-FAIL",
  "Failure message"
)
