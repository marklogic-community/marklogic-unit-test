import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

declare namespace t="http://marklogic.com/test";

test:assert-equal(<t:result type="success"/>, test:success())
