xquery version "1.0-ml";

xdmp:collection-delete("helpers-test-docs"),

xdmp:invoke-function(
  function() { 
    xdmp:collection-delete("helpers-test-docs"),
    xdmp:directory-delete("/remove-modules-dir-test/")
  },
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
)
