xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";
import module namespace td="list-from-db-module" at "test-data/td.xqy";

(
  for $uri in map:keys($td:TEST-DATA-PATH-1)
  return xdmp:document-delete($uri),

  for $uri in map:keys($td:TEST-DATA-PATH-2)
  return xdmp:document-delete($uri)  
)
