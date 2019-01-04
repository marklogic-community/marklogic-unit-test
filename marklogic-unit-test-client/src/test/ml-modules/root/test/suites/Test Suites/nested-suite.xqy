import module namespace test = "http://marklogic.com/test/unit" at "/test/test-controller.xqy",
                                                                   "/test/assert.xqy";

let $list := test:list()
return (
  test:assert-exists($list/test:suite[@path="Nested Directory/Another Nested Directory"]
    /test:tests/test:test[@path="nested-test.xqy"]),

  test:assert-exists($list/test:suite[@path="Nested Directory/Another Nested Directory/Double Nested Test Suite"]
    /test:tests/test:test[@path="double-nested-test.xqy"])
)


