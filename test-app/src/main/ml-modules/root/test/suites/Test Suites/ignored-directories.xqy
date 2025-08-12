xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy",
"/test/test-controller.xqy";

let $list := test:list()

return (
  test:assert-not-exists($list//element()[fn:contains(@path, "test-data")]),
  test:assert-not-exists($list//element()[fn:contains(@path, "/lib")])
)
