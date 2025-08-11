xquery version "1.0-ml";

(: add a module to the modules database :)
xdmp:invoke-function(
  function() {
    let $mod := <foo><![CDATA[
      xquery version "1.0-ml";

      "Hello World"
      ]]></foo>/text()

    return xdmp:document-insert("/remove-mods-test/mod1.xqy", $mod, xdmp:default-permissions(), "helpers-test-docs")
  },
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
);

(: call the helper to remove the module :)
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
test:remove-modules("/remove-mods-test/mod1.xqy");

(: confirm the module has been removed :)
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
xdmp:invoke-function(
  function() {
    test:assert-not-exists(fn:doc("/remove-mods-test/mod1.xqy"))
  },
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
);
