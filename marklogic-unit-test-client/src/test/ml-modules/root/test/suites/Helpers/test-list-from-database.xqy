xquery version "1.0-ml";

(: add test docs in two different paths :)
xdmp:document-insert("/list-from-db-test/path-1/doc1.xml", <doc>path1 doc1</doc>, xdmp:default-permissions(), "helpers-test-docs"),
xdmp:document-insert("/list-from-db-test/path-1/doc2.xml", <doc>path1 doc2</doc>, xdmp:default-permissions(), "helpers-test-docs"),
xdmp:document-insert("/list-from-db-test/path-2/doc1.xml", <doc>path2 doc1</doc>, xdmp:default-permissions(), "helpers-test-docs");

(: call helper to list docs in a path and confirm we only get the two in that path :)
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
let $uris := test:list-from-database(xdmp:database(), "/list-from-db-test/path-1/")
return (
  test:assert-same-values(("/list-from-db-test/path-1/doc1.xml", "/list-from-db-test/path-1/doc2.xml"), $uris)
);
