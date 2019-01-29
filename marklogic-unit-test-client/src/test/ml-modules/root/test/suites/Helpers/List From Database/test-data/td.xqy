xquery version "1.0-ml";

module namespace td="list-from-db-module";

declare variable $TEST-DATA-PATH-1 :=
  map:new((
    map:entry("/list-from-db/path-1/doc1.xml", "doc1.xml"),
    map:entry("/list-from-db/path-1/doc2.xml", "doc2.xml")
  ));

declare variable $TEST-DATA-PATH-2 :=
  map:new((
    map:entry("/list-from-db/path-2/doc3.xml", "doc3.xml")
  ));  