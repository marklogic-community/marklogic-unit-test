"use strict";

const BOOM_QNAME = xs.QName("MATCH-BOOM");
const BOOM_ERROR = "The values matched";

function mightBoom(param1, param2) {
  xdmp.log(`mightBoom; param1=${param1.toString()}; param2=${typeof param2}`);
  if (param1 === param2) {
    fn.error(BOOM_QNAME, BOOM_ERROR);
  }
  xdmp.log("mightBoom; the parameters are different");
  return param1;
}

module.exports = {
  BOOM_ERROR,
  mightBoom,
};
