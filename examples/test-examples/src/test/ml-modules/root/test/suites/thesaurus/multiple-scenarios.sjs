const test = require("/test/test-helper.xqy");
const lib = require("/example/lib.sjs");

const assertions = [];

let result = lib.lookupTerm("Car").toArray();
assertions.push(test.assertEqual(1, result.length));

result = lib.lookupTerm("Truck").toArray();
assertions.push(test.assertEqual(0, result.length));

assertions;
