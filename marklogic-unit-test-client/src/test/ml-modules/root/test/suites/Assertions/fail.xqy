import module namespace test="http://marklogic.com/test/unit" at "/test/assert.xqy";

declare function local:case1()
{
  test:fail('i failed')
};

test:assert-throws-error(xdmp:function(xs:QName("local:case1")), "USER-FAIL")
