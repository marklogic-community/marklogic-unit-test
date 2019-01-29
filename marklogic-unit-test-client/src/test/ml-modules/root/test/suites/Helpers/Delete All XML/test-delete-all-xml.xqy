xquery version "1.0-ml";

import module namespace test="http://marklogic.com/test/unit" at "/test/test-helper.xqy";
import module namespace td="delete-all-xml-module" at "test-data/td.xqy";

let $_ := test:delete-all-xml()

(: check that it worked in separate transaction :)
return 
  xdmp:invoke-function(
    function() { 
      let $xml-files :=
        for $x in (cts:uri-match("*.xml"), cts:uri-match("*.xlsx"))
        where fn:not(fn:contains($x, "config/config.xml"))
        return $x

      return test:assert-equal(0, fn:count($xml-files))
    }
  )
