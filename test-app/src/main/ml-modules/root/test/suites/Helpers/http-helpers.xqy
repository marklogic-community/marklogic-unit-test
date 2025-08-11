import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";


test:assert-http-get-status("v1/search?format=xml", $test:DEFAULT_HTTP_OPTIONS, 200),
test:assert-http-post-status("v1/search?format=xml", $test:DEFAULT_HTTP_OPTIONS, (), 200)
