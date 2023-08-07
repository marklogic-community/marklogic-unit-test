const test = require("/test/test-helper.xqy");
const lib = require("/example/lib.xqy");

const result = lib.lookupTerm("Car", "objects");
[
  test.assertEqual("Car", result.term),
  test.assertEqual(3, result.synonyms.length)
];
