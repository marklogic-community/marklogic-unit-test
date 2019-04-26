xquery version "1.0-ml";

(: create a directory in the modules database :)
xdmp:invoke-function(
  function() {
    xdmp:directory-create("/remove-modules-dir-test/")
  },
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
);

(: call test helper to remove the directory :)
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
test:remove-modules-directories("/remove-modules-dir-test/");

(: Confirm the directory has been removed :)
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
xdmp:invoke-function(
  function() {
    test:assert-not-exists(xdmp:document-properties("/remove-modules-dir-test/"))
  },
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
)
