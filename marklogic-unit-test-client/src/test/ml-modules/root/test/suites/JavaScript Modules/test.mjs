import { testHelperProxy } from "/test/test-helper";

const list = fn.head(xdmp.apply(xdmp.function(fn.QName("http://marklogic.com/test", "list"), "/test/test-controller.xqy")));

const assertions = [];
assertions.push(testHelperProxy.assertExists(list.xpath(`test:suite[@path="JavaScript Modules"]
/test:tests/test:test[@path="test.mjs"]`)));
assertions.push(testHelperProxy.assertExists(cts.doc("/test/mjs/suiteSetup.json")));
assertions.push(testHelperProxy.assertExists(cts.doc("/test/mjs/setup.json")));
assertions;
