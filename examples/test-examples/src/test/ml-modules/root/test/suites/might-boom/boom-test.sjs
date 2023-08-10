"use strict";

const test = require("/test/test-helper.xqy");
const lib = require("/example/boom-lib.sjs");

const SAME_PARAM = "1";

let assertions = [
  test.assertEqual(
    1,
    lib.mightBoom(1, 2),
    "Different values should not blow up"
  ),
  test.assertThrowsError(
    xdmp.function(xs.QName("mightBoom"), "/example/boom-lib.sjs"),
    SAME_PARAM,
    SAME_PARAM,
    lib.BOOM_ERROR
  ),
];

assertions;
