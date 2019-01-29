xquery version "1.0-ml";

module namespace td="remove-modules-module";

declare variable $TEST-DATA :=
  map:new((
    map:entry("/remove/modules/test/test-module-1.xqy", "test-module-1.xqy"),
    map:entry("/remove/modules/test/test-module-1.xqy", "test-module-2.xqy")
  ));