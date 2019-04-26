
// Given two JSON objects or arrays, determine whether they are the same.

const test = require("/test/test-helper.xqy");

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

function assertThrowsErrorWithMessage(f, errorName, errorMessage)
{
  try {
    f();
    test.fail('Function did not fail');
  }
  catch (e) {
    test.success();
    xdmp.log(e, 'info');
    let actual = e.stack.substr(0, e.stack.indexOf(" at "))
    if (!e.stack.includes(errorName)) {
      test.fail(`Function failed, but did not contain expected error [${errorName}] actual: [${actual}]`);
    }
    if (!e.stack.includes(errorMessage)) {
      test.fail(`Function failed, but did not contain expected message [${errorMessage}] actual [${actual}]`);
    }
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

  assertThrowsErrorWithMessage(
    function() {
      test.assertEqualJson({}, {"key":"value"}, "Failure message");
    },
    "ASSERT-EQUAL-JSON-FAILED",
    "Failure message; expected json:object() actual {\"key\":\"value\"}"
  )
]
