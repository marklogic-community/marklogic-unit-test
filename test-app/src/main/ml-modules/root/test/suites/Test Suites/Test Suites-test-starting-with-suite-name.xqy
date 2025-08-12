xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-controller.xqy",
                                                                   "/test/test-helper.xqy";

let $list := test:list()

return test:assert-exists(
  $list/test:suite[@path="Test Suites"]/test:tests/test:test[@path="Test Suites-test-starting-with-suite-name.xqy"],
  "Did not find test with Suite name in the test name in the list of tests.")
