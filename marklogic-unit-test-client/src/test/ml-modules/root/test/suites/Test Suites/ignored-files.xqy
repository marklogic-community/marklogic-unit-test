xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy",
"/test/test-controller.xqy";

declare namespace t = "http://marklogic.com/roxy/test";


let $list := test:list()

return (
  test:assert-not-exists($list/t:suite[@path="Setup and Teardown"]/t:tests/t:test[@path="setup.xqy"]),
  test:assert-not-exists($list/t:suite[@path="Setup and Teardown"]/t:tests/t:test[@path="teardown.xqy"]),
  test:assert-not-exists($list/t:suite[@path="Setup and Teardown"]/t:tests/t:test[@path="setup.sjs"]),
  test:assert-not-exists($list/t:suite[@path="Setup and Teardown"]/t:tests/t:test[@path="teardown.sjs"]),
  test:assert-not-exists($list/t:suite[@path="Setup and Teardown"]/t:tests/t:test[@path="suite-setup.xqy"]),
  test:assert-not-exists($list/t:suite[@path="Setup and Teardown"]/t:tests/t:test[@path="suite-teardown.xqy"]),
  test:assert-not-exists($list/t:suite[@path="Setup and Teardown"]/t:tests/t:test[@path="suiteSetup.sjs"]),
  test:assert-not-exists($list/t:suite[@path="Setup and Teardown"]/t:tests/t:test[@path="suiteTeardown.sjs"])
)
