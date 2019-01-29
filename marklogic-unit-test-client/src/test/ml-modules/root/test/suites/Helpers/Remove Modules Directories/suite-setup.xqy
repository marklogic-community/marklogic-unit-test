xquery version "1.0-ml";

xdmp:invoke-function(
  function() { 
    xdmp:directory-create("/remove-modules-dir-test/")
  },
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
) 
