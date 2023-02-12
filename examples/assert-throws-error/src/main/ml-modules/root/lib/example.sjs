"use strict";

const BOOM_QNAME = xs.QName("MATCH-BOOM");
const BOOM_ERROR = "The values matched";

/**
 * Throw an error if the parameters match.
 * @param param1
 * @param param2
 * @returns
 */
function mightBoom(param1, param2) {
  // When an SJS test uses test-helper.xqy and passes a function, the parameters are wrapped as objects which may
  // impact how the application code has to be written or has to be tested. A future SJS version of test-helper.xqy
  // will avoid this issue.
  if (param1.toString() === param2.toString()) {
    fn.error(BOOM_QNAME, BOOM_ERROR);
  }
  return param1;
}

module.exports = {
  BOOM_ERROR,
  mightBoom,
};
