xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace ex="http://example.org" at "/example/lib.xqy";

declare namespace thsr = "http://marklogic.com/xdmp/thesaurus";

let $result := ex:lookup-term("Car", "elements")
return (
  test:assert-equal("Car", $result/thsr:term/fn:string()),
  test:assert-equal(3, fn:count($result/thsr:synonym))
)

