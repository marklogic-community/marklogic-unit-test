
const helperExportFunctions = {};

/*
 * XQuery code cannot be directly imported into JavaScript modules. This proxy provides a way to access marklogic-unit-test helper
 * functions in a JavaScript friendly (e.g., assertExists instead of assert-exists) without duplicating the test-helper code.
 */
const testHelperProxy = new Proxy(helperExportFunctions, {
  get: (target, prop) => {
    if (!target[prop]) {
      const xqueryFunctionName = prop.replace(/([a-z])([A-Z])/g, "$1-$2").toLowerCase();
      target[prop] = xdmp.function(fn.QName("http://marklogic.com/test", xqueryFunctionName), "/test/test-helper.xqy");
    }
    const fun = target[prop];
    if (!(fun instanceof xdmp.function)) {
      throw new TypeError(`${prop} is not a test helper function.`);
    }
    return (...args) => xdmp.apply(fun, ...args);
  }
});

export {
  testHelperProxy
}
