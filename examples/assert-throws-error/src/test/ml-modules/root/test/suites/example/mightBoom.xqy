xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace ex = "http://marklogic.com/example" at "/lib/example.xqy";

declare variable $SAME_PARAM := "1";


(
  test:assert-throws-error(
    xdmp:function(fn:QName("http://marklogic.com/example", "mightBoom"), "/lib/example.xqy"),
    $SAME_PARAM,
    $SAME_PARAM,
    $ex:BOOM_ERROR
  )
)
