xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace lib = "http://marklogic.com/example" at "/example/boom-lib.xqy";

declare variable $SAME_PARAM := "1";


(
  test:assert-throws-error(
    xdmp:function(fn:QName("http://marklogic.com/example", "mightBoom"), "/example/boom-lib.xqy"),
    $SAME_PARAM,
    $SAME_PARAM,
    $lib:BOOM_ERROR
  )
)
