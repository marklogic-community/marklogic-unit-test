import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";

(: TODO - fill this out with meaningful tests :)

test:assert-throws-error-with-message(
  function() {
    test:assert-equal("a", "b")
  },
  "ASSERT-EQUAL-FAILED",
  "expected: ""a"" actual: ""b"""
),

test:assert-throws-error-with-message(
  function() {
    test:assert-equal(("a", "b"), ("a", "c"))
  },
  "ASSERT-EQUAL-FAILED",
  "expected: (""a"", ""b"") actual: (""a"", ""c"")"
)

