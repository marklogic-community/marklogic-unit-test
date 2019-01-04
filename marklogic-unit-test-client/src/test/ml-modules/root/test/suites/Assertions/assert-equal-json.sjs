
// Given two JSON objects or arrays, determine whether they are the same.

const test = require("/test/assert.xqy");

let j0 =
  {
    "PersonNameType":{
      "PersonSurName":"SMITH",
      "PersonGivenName":"LINDSEY"
    }
  };

let j1 =
  {
    "PersonNameType":{
      "PersonSurName":"JONES",
      "PersonGivenName":"LINDSEY"
    },
    "charges": [1,true,"a",null]
  };

let j2 =
  {
    "PersonNameType":{
      "PersonSurName":"JONES",
      "PersonGivenName":"LINDSEY"
    },
    "charges": [1,true,"a",null]
  };

let j3 =
  {
    "PersonNameType":{
      "PersonGivenName":"LINDSEY",
      "PersonSurName":"JONES"
    },
    "charges": [1,true,"a",null]
  };

let j4 =
  {
    "PersonNameType":{
      "PersonGivenName": "LINDSEY",
      "PersonSurName": "JONES"
    },
    "charges": [1, true, "a", null]
  };

let j5 =
  {
    "PersonNameType":{
      "PersonGivenName": "LINDSEY",
      "PersonSurName": "JONES"
    },
    "charges": [1, true, "a", null]
  };

/**
 * test.assertEqualJson expects an xdmp:function, but a JS function is not one of those.
 * @param f
 * @param msg
 */
function assertThrowsError(f, msg)
{
  try {
    f();
    test.fail(msg);
  }
  catch (e) {
    test.success();
  }
}

[
  test.assertEqualJson(j1, j2),
  test.assertEqualJson(j1, j3),
  test.assertEqualJson(j2, j3),
  test.assertEqualJson(j4, j5),
  test.assertEqualJson(j2, j4),
  test.assertEqualJson(j2, j5),

  test.assertEqualJson(1, 1),
  test.assertEqualJson('a', 'a'),

  assertThrowsError(
    function() {
      test.assertEqualJson(j0, j5)
    },
    "ASSERT-EQUAL-JSON-FAILED"
  )
]
