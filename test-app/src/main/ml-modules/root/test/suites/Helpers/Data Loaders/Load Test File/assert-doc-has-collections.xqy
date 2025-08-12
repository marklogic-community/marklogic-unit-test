xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace td="load-test-file-module" at "test-data/td.xqy";

(:
 : This test makes sure all collections that we attempted to add in the suite setup were actually added
 :)

let $all-collections := xdmp:document-get-collections($td:URI-WITH-COLLECTIONS)
let $expected-collections := $td:COLLECTIONS

return (
	test:assert-true(fn:doc-available($td:URI-WITH-COLLECTIONS)),

	for $collection in $expected-collections
	return test:assert-at-least-one-equal($collection, $all-collections)
)
