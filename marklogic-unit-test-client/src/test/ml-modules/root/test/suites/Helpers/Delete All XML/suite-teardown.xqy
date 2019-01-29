xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";
import module namespace td="delete-all-xml-module" at "test-data/td.xqy";

for $uri in map:keys($td:TEST-DATA)
return 
  if(fn:doc-available($uri)) then 
    xdmp:document-delete($uri)
  else ()
