xquery version "1.0-ml";

module namespace td="delete-all-xml-module";

declare variable $TEST-DATA :=
  map:new((
    map:entry("/delete-all-xml/test/doc1.xml", "doc1.xml"),
    map:entry("/delete-all-xml/test/doc2.xml", "doc2.xml"),
    map:entry("/delete-all-xml/test/doc3.xml", "doc3.xml")
  ));