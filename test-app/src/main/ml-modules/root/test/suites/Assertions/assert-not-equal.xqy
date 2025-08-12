import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-not-equal(0, 1),
test:assert-not-equal((0, 1, 2), (0, 2, 1)),
test:assert-not-equal((0, 1, 2), ()),
test:assert-not-equal(<a/>, <g/>),
test:assert-not-equal(<a><aa/></a>, <g/>),
test:assert-throws-error-with-message(
  function() {
    test:assert-not-equal(0, 0)
  },
  "ASSERT-NOT-EQUAL-FAILED",
  "items were equal; not expected: 0 actual: 0"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-not-equal(<a/>, <a/>, "Failure message")
  },
  "ASSERT-NOT-EQUAL-FAILED",
  "Failure message; items were equal; not expected: <a/> actual: <a/>"
)
