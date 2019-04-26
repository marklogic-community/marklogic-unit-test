import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";

test:assert-equal("hello", "hello")
