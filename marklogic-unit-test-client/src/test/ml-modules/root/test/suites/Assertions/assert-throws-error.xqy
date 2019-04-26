import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

declare function local:div-by-zero() {
  5 div 0
};

declare function local:div-by-zero($num)
{
  $num div 0
};

test:assert-throws-error( local:div-by-zero#0),

test:assert-throws-error(local:div-by-zero#0, "XDMP-DIVBYZERO"),

try {
  test:assert-throws-error(local:div-by-zero#0, "XDMP-DIVBYZERO2"),
  test:fail("Did not Throw error and should have")
}
catch($ex) {
  if ($ex/error:name eq "ASSERT-THROWS-ERROR-FAILED") then
    test:success()
  else
    test:fail($ex)
},

try {
  test:assert-throws-error(
    function() {
      5 div 5
    }
  ),
  test:fail("Did not Throw error and should have")
}
catch($ex) {
  if ($ex/error:name eq "ASSERT-THROWS-ERROR-FAILED") then
    test:success()
  else
    test:fail($ex)
},

test:assert-throws-error(local:div-by-zero#1, 5, ()),

test:assert-throws-error(local:div-by-zero#1, 5, "XDMP-DIVBYZERO"),

try {
  test:assert-throws-error-with-message(function() {()}, "EXPECTED-CODE", "EXPECTED-MESSAGE", "Custom failure message")
}
catch($ex) {
  test:assert-equal(
    "Custom failure message; Did not throw an error",
    $ex//error:message/fn:string(),
    "Did not find the custom failure message in the failure")
}
