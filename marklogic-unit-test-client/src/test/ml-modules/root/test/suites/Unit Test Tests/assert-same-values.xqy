import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

declare option xdmp:mapping "false";

(: Same size sequences; all items match; same order. :)

test:assert-same-values((), ()),
test:assert-same-values((1), (1)),
test:assert-same-values((2, 4, 6, 8), (2, 4, 6, 8)),

(: Same size sequences; all items match; different order. :)

test:assert-same-values((2, 4, 6, 8), (4, 8, 6, 2)),
test:assert-same-values(("bb", "c", "a"), ("a", "bb", "c")),

(: Same size sequences; same order; item mismatch. :)

test:assert-throws-message(
  function () { test:assert-same-values((1), (2)) },
  "Item 1 differs. expected: 1, actual: 2"),

test:assert-throws-message(
  function () { test:assert-same-values((6, 3, 1), (3, 9, 1)) },
  "Item 3 differs. expected: 6, actual: 9"),

test:assert-throws-message(
  function () { test:assert-same-values(("a", "bb", "c"), ("a", "bc", "c")) },
  "Item 2 differs. expected: bb, actual: bc"),

(: Same size sequences; different order; item mismatch. :)

test:assert-throws-message(
  function () { test:assert-same-values((1, 3, 6), (1, 3, 9)) },
  "Item 3 differs. expected: 6, actual: 9"),

(: Different size sequences :)

test:assert-throws-message(
  function () { test:assert-same-values((1, 2), (1, 3, 6)) },
  "Item 2 differs. expected: 2, actual: 3"),

test:assert-throws-message(
  function () { test:assert-same-values((1, 2), (1, 2, 3)) },
  "Item count differs. expected: 2, actual: 3"),

test:assert-throws-message(
  function () { test:assert-same-values((1, 2, 3), (1, 4)) },
  "Item 2 differs. expected: 2, actual: 4"),

test:assert-throws-message(
  function () { test:assert-same-values((1, 2, 3), (1, 2)) },
  "Item count differs. expected: 3, actual: 2")
