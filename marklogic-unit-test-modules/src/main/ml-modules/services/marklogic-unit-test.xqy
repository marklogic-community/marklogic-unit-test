xquery version "1.0-ml";

module namespace resource = "http://marklogic.com/rest-api/resource/marklogic-unit-test";

import module namespace test = "http://marklogic.com/test" at "/test/test-controller.xqy";

declare function get(
	$context as map:map,
	$params as map:map
) as document-node()*
{
	document {
		if (map:get($params, "func") = "run") then run($params)
		else
      test:list()
	}
};

declare function post(
	$context as map:map,
	$params as map:map,
	$input as document-node()*
) as document-node()*
{
	document {
		run($params)
	}
};


declare private function run($params as map:map)
{
	let $suite := map:get($params, "suite")
	let $tests := fn:tokenize(map:get($params, "tests"), ",")[. ne ""]
	let $run-suite-teardown as xs:boolean := map:get($params, "runsuiteteardown") eq "true"
	let $run-teardown as xs:boolean := map:get($params, "runteardown") eq "true"
	let $format as xs:string := (map:get($params, "format"), "xml")[1]
	let $calculate-coverage as xs:boolean := map:get($params, "calculatecoverage") eq "true"
	return
		if ($suite) then
			let $result := test:run-suite($suite, $tests, $run-suite-teardown, $run-teardown, $calculate-coverage)
			return
				if ($format) then
					test:format($result, $format, $suite)
				else
					$result
		else ()
};
