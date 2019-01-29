xquery version "1.0-ml";

xdmp:invoke-function(
  function() { 
    let $dir := "/remove-modules-dir-test/"
    return
      if(xdmp:document-properties($dir)) then 
        xdmp:directory-delete($dir)
      else ()
  },
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
) 
