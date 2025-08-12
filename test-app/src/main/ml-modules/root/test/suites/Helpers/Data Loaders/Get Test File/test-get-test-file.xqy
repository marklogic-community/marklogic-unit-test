xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

let $doc := test:get-test-file("basic-doc.xml")
return test:assert-exists($doc)
