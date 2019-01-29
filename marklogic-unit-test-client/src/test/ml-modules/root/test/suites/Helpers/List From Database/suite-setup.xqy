xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";
import module namespace td="list-from-db-module" at "test-data/td.xqy";

(: load docs in two different paths :)
(
  for $uri in map:keys($td:TEST-DATA-PATH-1)
  return test:load-test-file(map:get($td:TEST-DATA-PATH-1, $uri), xdmp:database(), $uri),

  for $uri in map:keys($td:TEST-DATA-PATH-2)
  return test:load-test-file(map:get($td:TEST-DATA-PATH-2, $uri), xdmp:database(), $uri)
)
