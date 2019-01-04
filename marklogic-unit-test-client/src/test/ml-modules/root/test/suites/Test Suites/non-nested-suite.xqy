xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy",
"/test/test-controller.xqy";

declare namespace t = "http://marklogic.com/roxy/test";


let $list := test:list()

return test:assert-exists($list/t:suite[@path="Unit Test Tests"]/t:tests/t:test[@path="assert-all-exist.xqy"])
