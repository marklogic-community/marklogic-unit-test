xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";

let $dir := "/remove-modules-dir-test/"
let $_ := test:remove-modules-directories($dir)

return 
  xdmp:invoke-function(
    function() { 
      test:assert-not-exists(xdmp:document-properties($dir))
    },
    <options xmlns="xdmp:eval">
      <database>{xdmp:modules-database()}</database>
    </options>
  ) 