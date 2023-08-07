const test = require("/test/test-helper.xqy");
const lib = require("/example/lib.sjs");

const result = lib.lookupTerm("Car");
[
  test.assertEqual("Car", result.term),
  test.assertEqual(1, result.entries.length),
  test.assertEqual(3, result.entries[0].synonyms.length, "3 synonyms are expected for 'Car'.")
];

// LEAVING THIS IN FOR NOW. Going to move it to a separate test when I do the "Writing tests" page.

// const assertions = [];
//
// let result = lib.lookupTerm("Car");
// assertions.push(
//   test.assertEqual("Car", result.term),
//   test.assertEqual(1, result.entries.length),
//   test.assertEqual(3, result.entries[0].synonyms.length)
// );
//
// assertions;
//
// result = lib.lookupTerm("Truck");
// assertions.push(
//   test.assertEqual("Truck", result.term),
//   test.assertEqual(1, result.entries.length, "The thesaurus is not expected to contain any entries for 'Truck'.")
// );
//
// assertions;
