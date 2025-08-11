const test = require("/test/test-helper.xqy");

const list = fn.head(xdmp.apply(xdmp.function(fn.QName("http://marklogic.com/test", "list"), "/test/test-controller.xqy")));

function assertThrowsError(f, errorName)
{
  try {
    f();
    test.fail('Function did not fail');
  }
  catch (e) {
    test.success();
    xdmp.log(e, 'error');
    let actual = e.stack.substr(0, e.stack.indexOf(" at "))
    if (!e.stack.includes(errorName)) {
      test.fail(`Function failed, but did not contain expected error [${errorName}] actual: [${actual}]`);
    }
  }
}

const assertions = [];
assertions.push(
  test.assertTrue(true),

  assertThrowsError(
    function() {
      test.assertTrue(false);
    },
    "ASSERT-TRUE-FAILED"
  ),

  assertThrowsError(
    function() {
      test.assertTrue(null);
    },
    "ASSERT-TRUE-FAILED"
  ),

  assertThrowsError(
    function() {
      test.assertTrue(undefined);
    },
    "ASSERT-TRUE-FAILED"
  )
);
assertions;
