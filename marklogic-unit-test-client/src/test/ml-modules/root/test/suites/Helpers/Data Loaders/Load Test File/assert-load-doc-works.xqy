xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace td="load-test-file-module" at "test-data/td.xqy";


(: make sure perm/collection changes didn't affect adding a document with out either :)
(
	test:assert-true(fn:doc-available($td:URI-BASIC))
)

