import module namespace test="http://marklogic.com/test/unit" at "/test/assert.xqy";

declare namespace t="http://marklogic.com/test/unit";

test:assert-equal(<t:result type="success"/>, test:success())
