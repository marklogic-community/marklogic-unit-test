import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

declare option xdmp:mapping "false";

(: Same size sequences; all items match. :)

test:assert-equal-seq((), ()),
test:assert-equal-seq((1), (1)),
test:assert-equal-seq((2, 4, 6, 8), (2, 4, 6, 8)),
test:assert-equal-seq(("a", "bb", "c"), ("a", "bb", "c")),

(: Same size sequences; item mismatch. :)

test:assert-throws-message(
  function () { test:assert-equal-seq((1), (2)) },
  "Item 1 differs. expected: 1, actual: 2"),

test:assert-throws-message(
  function () { test:assert-equal-seq((1, 3, 6), (1, 3, 9)) },
  "Item 3 differs. expected: 6, actual: 9"),

test:assert-throws-message(
  function () { test:assert-equal-seq(("a", "bb", "c"), ("a", "bc", "c")) },
  "Item 2 differs. expected: bb, actual: bc"),

(: Different size sequences :)

test:assert-throws-message(
  function () { test:assert-equal-seq((1, 2), (1, 3, 6)) },
  "Item 2 differs. expected: 2, actual: 3"),

test:assert-throws-message(
  function () { test:assert-equal-seq((1, 2), (1, 2, 3)) },
  "Item count differs. expected: 2, actual: 3"),

test:assert-throws-message(
  function () { test:assert-equal-seq((1, 2, 3), (1, 4)) },
  "Item 2 differs. expected: 2, actual: 4"),

test:assert-throws-message(
  function () { test:assert-equal-seq((1, 2, 3), (1, 2)) },
  "Item count differs. expected: 3, actual: 2")
