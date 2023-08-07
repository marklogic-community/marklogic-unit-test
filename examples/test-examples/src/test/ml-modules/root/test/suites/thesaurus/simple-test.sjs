const test = require("/test/test-helper.xqy");
const lib = require("/example/lib.sjs");

const result = lib.lookupTerm("Car").toArray();
[
  test.assertEqual(1, result.length),
  test.assertEqual("Car", result[0].term),
  test.assertEqual(3, result[0].synonyms.length, "3 synonyms are expected for 'Car'.")
];
