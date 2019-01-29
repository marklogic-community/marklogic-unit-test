xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";
import module namespace td="delete-all-xml-module" at "test-data/td.xqy";

for $uri in map:keys($td:TEST-DATA)
return test:load-test-file(map:get($td:TEST-DATA, $uri), xdmp:database(), $uri)
