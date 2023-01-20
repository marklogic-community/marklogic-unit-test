"use strict";

const test = require("/test/test-helper.xqy");
const ex = require("/lib/example.sjs");

const SAME_PARAM = "1";

let assertions = [
  test.assertEqual(
    1,
    ex.mightBoom(1, 2),
    "Different values should not blow up"
  ),
  test.assertThrowsError(
    xdmp.function(xs.QName("mightBoom"), "/lib/example.sjs"),
    SAME_PARAM,
    SAME_PARAM,
    ex.BOOM_ERROR
  ),
];

assertions;
