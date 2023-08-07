const lib = require("/example/lib.sjs");

function get(context, params) {
  return lib.lookupTerm(params["term"]);
};

exports.GET = get;
