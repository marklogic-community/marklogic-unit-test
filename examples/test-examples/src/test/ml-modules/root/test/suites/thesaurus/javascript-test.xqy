xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

declare namespace thsr = "http://marklogic.com/xdmp/thesaurus";

let $script := "const ex = require('/example/lib.sjs'); ex.lookupTerm('Car', 'elements')"
let $result := xdmp:javascript-eval($script)

return (
  test:assert-equal("Car", $result/thsr:term/fn:string()),
  test:assert-equal(3, fn:count($result/thsr:synonym))
)
