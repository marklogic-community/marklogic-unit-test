xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy",
"/test/test-controller.xqy";

declare namespace t = "http://marklogic.com/roxy/test";


let $list := test:list()
(: should only find tests that end with .sjs or .xqy :)
return test:assert-not-exists($list//t:test[fn:matches(@path, "([^.xqy|.sjs])$")])
