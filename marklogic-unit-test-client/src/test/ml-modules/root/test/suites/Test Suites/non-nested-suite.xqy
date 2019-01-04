xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test/unit" at "/test/test-controller.xqy",
                                                                   "/test/assert.xqy";

let $list := test:list()

return test:assert-exists($list/test:suite[@path="Assertions"]/test:tests/test:test[@path="assert-exists.xqy"])
