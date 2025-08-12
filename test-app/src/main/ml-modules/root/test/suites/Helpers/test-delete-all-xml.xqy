xquery version "1.0-ml";

(: add a few xml documents and an xlsx doc :)
xdmp:document-insert("/delete-all-test/doc1.xml", <doc>1</doc>, xdmp:default-permissions(), "helpers-test-docs"),
xdmp:document-insert("/delete-all-test/doc2.xlsx", <doc>2</doc>, xdmp:default-permissions(), "helpers-test-docs"),
xdmp:document-insert("/config/config.xml", <config></config>, xdmp:default-permissions(), "helpers-test-docs");

(: call helper to delete xml/xlsx documents :)
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
test:delete-all-xml();

(: confirm all xml/xlsx docs except config.xml have been deleted :)
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
test:assert-not-exists(fn:doc("/delete-all-test/doc1.xml")),
test:assert-not-exists(fn:doc("/delete-all-test/doc2.xlsx")),
test:assert-exists(fn:doc("/config/config.xml"));
