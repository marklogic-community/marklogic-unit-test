xquery version "1.0-ml";

import module namespace td="load-test-file-module" at "test-data/td.xqy";

declare variable $deleteOptions as map:map := map:entry("ifNotExists", "allow");

let $safe-delete :=
  if (fn:function-available("xdmp:document-delete", 2)) then
    xdmp:document-delete(?, $deleteOptions)
  else
    function ($uri) {
      if (fn:doc-available($uri)) then xdmp:document-delete($uri) else ()
    }
return
  (
    $safe-delete($td:URI-BASIC),
    $safe-delete($td:URI-WITH-PERMS),
    $safe-delete($td:URI-WITH-COLLECTIONS)
  )
