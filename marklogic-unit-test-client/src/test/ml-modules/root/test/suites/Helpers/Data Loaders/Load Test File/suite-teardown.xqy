xquery version "1.0-ml";

import module namespace td="load-test-file-module" at "test-data/td.xqy";

(
	xdmp:document-delete($td:URI-BASIC),
	xdmp:document-delete($td:URI-WITH-PERMS),
	xdmp:document-delete($td:URI-WITH-COLLECTIONS)
)
