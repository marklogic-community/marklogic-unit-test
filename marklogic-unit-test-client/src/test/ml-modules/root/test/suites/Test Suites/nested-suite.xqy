import module namespace test = "http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy",
"/test/test-controller.xqy";

declare namespace t = "http://marklogic.com/roxy/test";


let $list := test:list()
let $_ := xdmp:log($list, "info")
return (
  test:assert-exists($list/t:suite[@path="Nested Directory/Another Nested Directory"]
    /t:tests/t:test[@path="nested-test.xqy"]),

  test:assert-exists($list/t:suite[@path="Nested Directory/Another Nested Directory/Double Nested Test Suite"]
    /t:tests/t:test[@path="double-nested-test.xqy"])
)


