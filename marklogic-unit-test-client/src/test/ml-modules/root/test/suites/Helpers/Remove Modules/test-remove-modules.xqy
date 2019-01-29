xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";
import module namespace td="remove-modules-module" at "test-data/td.xqy";

let $_ := test:remove-modules(map:keys($td:TEST-DATA))

return 
  xdmp:invoke-function(
    function() { 
      for $uri in map:keys($td:TEST-DATA)
      return test:assert-false(fn:doc-available($uri))
    },
    <options xmlns="xdmp:eval">
      <database>{xdmp:modules-database()}</database>
    </options>
  ) 
