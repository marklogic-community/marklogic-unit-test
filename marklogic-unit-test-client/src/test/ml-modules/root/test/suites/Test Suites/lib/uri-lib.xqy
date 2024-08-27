xquery version "1.0-ml";

module namespace url-lib = "http://marklogic.com/url-lib";

import module namespace test = "http://marklogic.com/test" at "/test/test-controller.xqy", "/test/test-helper.xqy";

declare function url-lib:call-get-test-data-directory-uri($caller as xs:string) as xs:string
{
  test:get-test-data-directory-uri($caller)
};
