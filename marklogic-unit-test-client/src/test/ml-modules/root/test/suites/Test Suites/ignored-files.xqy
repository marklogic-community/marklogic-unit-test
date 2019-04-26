xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-controller.xqy",
                                                                   "/test/test-helper.xqy";

let $list := test:list()

return (
  test:assert-not-exists($list/test:suite[@path="Setup and Teardown"]/test:tests/test:test[@path="setup.xqy"]),
  test:assert-not-exists($list/test:suite[@path="Setup and Teardown"]/test:tests/test:test[@path="teardown.xqy"]),
  test:assert-not-exists($list/test:suite[@path="Setup and Teardown"]/test:tests/test:test[@path="setup.sjs"]),
  test:assert-not-exists($list/test:suite[@path="Setup and Teardown"]/test:tests/test:test[@path="teardown.sjs"]),
  test:assert-not-exists($list/test:suite[@path="Setup and Teardown"]/test:tests/test:test[@path="suite-setup.xqy"]),
  test:assert-not-exists($list/test:suite[@path="Setup and Teardown"]/test:tests/test:test[@path="suite-teardown.xqy"]),
  test:assert-not-exists($list/test:suite[@path="Setup and Teardown"]/test:tests/test:test[@path="suiteSetup.sjs"]),
  test:assert-not-exists($list/test:suite[@path="Setup and Teardown"]/test:tests/test:test[@path="suiteTeardown.sjs"])
)
