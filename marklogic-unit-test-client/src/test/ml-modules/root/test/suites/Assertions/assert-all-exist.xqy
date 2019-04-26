import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-all-exist(0, ()),
test:assert-all-exist(1, "1"),
test:assert-all-exist(2, ("1", "2")),

test:assert-throws-error-with-message(
  function() {
    test:assert-all-exist(1, (<a/>, <b/>, <c/>))
  },
  "ASSERT-ALL-EXIST-FAILED",
  "expected 1 items but found 3 items"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-all-exist(4, (<a/>, <b/>, <c/>))
  },
  "ASSERT-ALL-EXIST-FAILED",
  "expected 4 items but found 3 items"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-all-exist(1, (), "Failure message")
  },
  "ASSERT-ALL-EXIST-FAILED",
  "Failure message; expected 1 items but found 0 items"
)
