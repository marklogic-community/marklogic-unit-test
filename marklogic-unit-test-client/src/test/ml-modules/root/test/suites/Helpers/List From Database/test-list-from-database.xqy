xquery version "1.0-ml";

import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-doc-2007-01.xqy";
import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";
import module namespace td="list-from-db-module" at "test-data/td.xqy";


let $path-1-uris := map:keys($td:TEST-DATA-PATH-1)
let $list-path := fn:concat(functx:substring-before-last($path-1-uris[1], "/"), "/")

let $uris := test:list-from-database(xdmp:database(), $list-path)
return (
  (: should only have uris from path 1, none from path 2 :)
  test:assert-same-values($path-1-uris, $uris)
)