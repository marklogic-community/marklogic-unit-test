xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace td="load-test-file-module" at "test-data/td.xqy";

(
	test:load-test-file("basic-doc.xml", xdmp:database(), $td:URI-BASIC),
	test:load-test-file("doc-with-perms.xml", xdmp:database(), $td:URI-WITH-PERMS, $td:PERMS),
	test:load-test-file("doc-with-collections.xml", xdmp:database(), $td:URI-WITH-COLLECTIONS, (), $td:COLLECTIONS)
)
