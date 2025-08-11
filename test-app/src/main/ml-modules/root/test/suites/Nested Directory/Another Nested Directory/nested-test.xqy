import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";
(:
  This file is used to ensure we detect  nested tests when returning a list of tests and suites.  The below assertion is
  not meaningful.
:)
test:assert-true(fn:true())
