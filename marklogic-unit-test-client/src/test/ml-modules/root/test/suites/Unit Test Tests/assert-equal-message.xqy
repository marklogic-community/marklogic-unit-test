import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

declare function local:case1()
{
  test:assert-equal-message(<a class="1"/>, <g class="2"/>, "Case 1")
};

declare function local:case2()
{
  test:assert-equal-message((<a/>, <b/>, <c/>), (<a/>, <b/>), "Case 2")
};

declare function local:case3()
{
  test:assert-equal-message((<a/>, <b/>), (<a/>, <b/>, <c/>), "Case 3")
};

declare function local:case4()
{
  test:assert-equal-message((<a/>, <b/>, <c/>), (<a/>, <c/>, <b/>), "Case 4")
};

declare function local:case5()
{
  test:assert-equal-message((<a><aa/></a>, <b/>, <c/>), (element a { element aaa { } }, element b {}, element c {}), "Case 5")
};

test:assert-throws-error(xdmp:function(xs:QName("local:case1")), "ASSERT-EQUAL-FAILED"),
test:assert-throws-message(xdmp:function(xs:QName("local:case1")), "Case 1"),

test:assert-equal-message(<a class="1"/>, element a { attribute class { "1" } }, "Does not throw"),

test:assert-throws-error(xdmp:function(xs:QName("local:case2")), "ASSERT-EQUAL-FAILED"),
test:assert-throws-message(xdmp:function(xs:QName("local:case2")), "Case 2"),

test:assert-throws-error(xdmp:function(xs:QName("local:case3")), "ASSERT-EQUAL-FAILED"),
test:assert-throws-message(xdmp:function(xs:QName("local:case3")), "Case 3"),

test:assert-throws-error(xdmp:function(xs:QName("local:case4")), "ASSERT-EQUAL-FAILED"),
test:assert-throws-message(xdmp:function(xs:QName("local:case4")), "Case 4"),

test:assert-equal((<a/>, <b/>, <c/>), (<a/>, <b/>, <c/>), "Does not throw"),

test:assert-equal((<a/>, <b/>, <c/>), (element a {}, element b {}, element c {}), "Does not throw"),

test:assert-equal((<a><aa/></a>, <b/>, <c/>), (element a { element aa { } }, element b {}, element c {}), "Does not throw"),

test:assert-equal(5, 5, "Does not throw"),

test:assert-equal("a", "a", "Does not throw"),

test:assert-equal((), (), "Does not throw"),

test:assert-throws-error(xdmp:function(xs:QName("local:case5")), "ASSERT-EQUAL-FAILED"),
test:assert-throws-message(xdmp:function(xs:QName("local:case5")), "Case 5")
