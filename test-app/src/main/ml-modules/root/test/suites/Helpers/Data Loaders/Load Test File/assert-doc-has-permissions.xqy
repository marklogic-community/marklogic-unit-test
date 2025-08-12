xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace td="load-test-file-module" at "test-data/td.xqy";

declare namespace sec="http://marklogic.com/xdmp/security";

(:
 : This test makes sure all permissions that we attempted to add in the suite setup were actually added
 :)

let $all-perms :=
	for $perm in xdmp:document-get-permissions($td:URI-WITH-PERMS)
	return fn:concat($perm/sec:role-id/text(), "-", $perm/sec:capability/text())

let $expected-perms :=
	for $perm in $td:PERMS
	return fn:concat($perm/sec:role-id/text(), "-", $perm/sec:capability/text())

return
(
	test:assert-true(fn:doc-available($td:URI-WITH-PERMS)),

	for $expected-perm in $expected-perms
	return test:assert-at-least-one-equal($expected-perm, $all-perms)
)
