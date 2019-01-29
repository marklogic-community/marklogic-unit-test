xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";
import module namespace td="remove-modules-module" at "test-data/td.xqy";

xdmp:invoke-function(
  function() { 
    for $uri in map:keys($td:TEST-DATA)
    return 
      if(fn:doc-available($uri)) then xdmp:document-delete($uri) else ()
  },
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
)
