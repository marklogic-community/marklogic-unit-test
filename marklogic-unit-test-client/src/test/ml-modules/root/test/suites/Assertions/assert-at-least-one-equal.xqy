import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-at-least-one-equal(0, 0),
test:assert-at-least-one-equal(0, (0, 1, 2)),
test:assert-at-least-one-equal((0, 1, 2), 0),
test:assert-at-least-one-equal((0, 1, 2), (0, 3, 4)),

test:assert-throws-error(
  function() {
    test:assert-at-least-one-equal((0, 1, 2), 4)
  },
  "ASSERT-AT-LEAST-ONE-EQUAL-FAILED"
),

test:assert-throws-error(
  function() {
    test:assert-at-least-one-equal(4, (0, 1, 2))
  },
  "ASSERT-AT-LEAST-ONE-EQUAL-FAILED"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-at-least-one-equal((0, 1, 2), (4, 5, 6))
  },
  "ASSERT-AT-LEAST-ONE-EQUAL-FAILED",
  "nothing was equal between (0, 1, 2) and (4, 5, 6)"
),

test:assert-throws-error-with-message(
  function() {
    test:assert-at-least-one-equal((), (), "Failure Message")
  },
  "ASSERT-AT-LEAST-ONE-EQUAL-FAILED",
  "Failure Message; nothing was equal between () and ()"
)
