xquery version "1.0-ml";

module namespace td="load-test-file-module";

declare variable $URI-WITH-PERMS := "/test/load-test-data-suite/doc-with-perms.xml";
declare variable $URI-WITH-COLLECTIONS := "/test/load-test-data-suite/doc-with-collections.xml";
declare variable $URI-BASIC := "/test/load-test-data-suite/basic.xml";

declare variable $PERMS := (
	xdmp:permission("app-user", "read"),
	xdmp:permission("app-user", "update")
);

declare variable $COLLECTIONS := ("cats", "dogs");