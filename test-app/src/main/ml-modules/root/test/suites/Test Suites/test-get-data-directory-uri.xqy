xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-controller.xqy", "/test/test-helper.xqy";
import module namespace url-lib = "http://marklogic.com/url-lib" at "/test/suites/Test Suites/lib/uri-lib.xqy";

(
  test:assert-equal("/test/suites/Test Suites/test-data/", test:get-test-data-directory-uri(test:get-caller())),
  test:assert-equal("/test/suites/Test Suites/test-data/", url-lib:call-get-test-data-directory-uri(test:get-caller()))
)
