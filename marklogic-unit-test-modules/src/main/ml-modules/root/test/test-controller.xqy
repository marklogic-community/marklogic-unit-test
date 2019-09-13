xquery version "1.0-ml";

(:
Defines functions that are used by the default.xqy test runner and by the REST endpoint.
:)

module namespace test = "http://marklogic.com/test";

import module namespace cover = "http://marklogic.com/test/coverage" at "/test/test-coverage.xqy";
import module namespace cvt = "http://marklogic.com/cpf/convert" at "/MarkLogic/conversion/convert.xqy";
import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-nodoc-2007-01.xqy";
import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";

declare variable $XSL-PATTERN as xs:string := "\.xslt?$";
declare variable $TEST-SUITES-ROOT := "/test/suites/";
declare variable $db-id as xs:unsignedLong := xdmp:modules-database();
declare variable $root as xs:string := xdmp:modules-root();


(:
 : Returns a list of the available tests. This list is magically computed based on the modules
 :)
declare function list()
{
	let $directories-to-ignore := map:new((
    ".svn", "CVS", ".DS_Store", "Thumbs.db", "thumbs.db", "test-data", "lib"
  ) ! map:entry(., .))

  let $files-to-ignore := map:new((
		"setup.xqy", "teardown.xqy", "setup.sjs", "teardown.sjs",
		"suite-setup.xqy", "suite-teardown.xqy", "suiteSetup.sjs", "suiteTeardown.sjs"
	) ! map:entry(., .))

  let $suites := map:map()

  let $_ :=
    for $uri in test:list-from-database($db-id, $root || "test/suites/")
      let $test-path := fn:replace($uri, fn:concat($root, "test/suites/?"), "")
      let $suite-path := cvt:basepath($test-path)
      let $test-name := fn:replace($test-path, $suite-path || "(\\|/)", "")

      let $suite-is-valid :=
        let $path-not-in-ignored-directory :=
          fn:empty(fn:tokenize($suite-path, "(\\|/)") ! map:get($directories-to-ignore, .))
        return $suite-path and $path-not-in-ignored-directory

      let $test-is-valid :=
        $test-name
          and fn:not(fn:contains($test-name, "(\\|/)"))
          and fn:empty(map:get($files-to-ignore, $test-name))
          and fn:matches($test-name, "(\.sjs|\.xqy)$")

      where $suite-is-valid and $test-is-valid
      return map:put($suites, $suite-path, (map:get($suites, $suite-path), $test-name))

  let $main-formats as xs:string* := fn:distinct-values(
    for $uri in test:list-from-database($db-id, $root || "test/formats/")
      let $path := fn:replace($uri, fn:concat($root, "test/formats/"), "")
      where $path ne "" and fn:not(fn:contains($path, "/")) and fn:empty(map:get($files-to-ignore, $path)) and (fn:matches($path, $XSL-PATTERN))
      return $path
  )
	return
		element test:tests {
				for $suite as xs:string in map:keys($suites)
          let $tests as xs:string* :=
            for $test-name in map:get($suites, $suite)
              order by $test-name
              return $test-name
          where $tests
          order by $suite
          return
            element test:suite {
              attribute path {$suite},
              element test:tests {
                for $test in $tests
                return
                  element test:test {
                    attribute path {$test}
                  }
              }
            },
				if ($main-formats) then
					element test:formats {
						for $main-format in $main-formats
						return
							element test:format {
								attribute path {$main-format}
							}
					}
				else ()
		}
};

(:~
: Execute all of the test suites and report with code coverage information
:)
declare function run-tests() {
	let $run-suite-teardown := fn:true()
	let $run-teardown := fn:true()
	let $calculate-coverage := fn:true()
	let $test-results :=
		element test:tests {
			for $suite in list()/test:suite
			let $suite-name as xs:string := $suite/@path
			let $test-modules as xs:string* := $suite/test:tests/test:test/@path
			return run-suite($suite-name, $test-modules, $run-suite-teardown, $run-teardown, $calculate-coverage)
		}
	return
		cover:summary($test-results)
};

(:~
 : Execute the suite tests with the options specified. Default behavior is not to calculate code coverage.
 :)
declare function run-suite(
	$suite as xs:string,
	$tests as xs:string*,
	$run-suite-teardown as xs:boolean,
	$run-teardown as xs:boolean)
{
	run-suite($suite, $tests, $run-suite-teardown, $run-teardown, fn:false())
};

(:~
 : Execute the suite tests with the options specified.
 :)
declare function run-suite(
	$suite as xs:string,
	$tests as xs:string*,
	$run-suite-teardown as xs:boolean,
	$run-teardown as xs:boolean,
	$calculate-coverage as xs:boolean)
{
	let $start-time := xdmp:elapsed-time()
	let $tests as xs:string* :=
		if ($tests) then $tests
		else list()/test:suite[@path eq $suite]/test:tests/test:test/@path
	let $coverage :=
		if ($calculate-coverage) then
			(
				run-setup-teardown(fn:true(), $suite),
				let $coverage-modules := cover:list-coverage-modules()[fn:not(fn:starts-with(., $TEST-SUITES-ROOT))]
				let $test-modules :=	$tests ! fn:concat($TEST-SUITES-ROOT, $suite, "/", .)
			  return cover:prepare($coverage-modules, $test-modules),
				if ($run-suite-teardown eq fn:true()) then
					run-setup-teardown(fn:false(), $suite)
				else ()
			)
		else ()
	let $results :=
		element test:run {
			test:log(" "),
			test:log(text {"SUITE:", $suite}),
			run-setup-teardown(fn:true(), $suite),

			test:log(" - invoking tests"),
			for $test in $tests
			return
				run($suite, $test, fn:concat($TEST-SUITES-ROOT, $suite, "/", $test), $run-teardown, $coverage),

			if ($run-suite-teardown eq fn:true()) then
				run-setup-teardown(fn:false(), $suite)
			else test:log(" - not running suite teardown"),
			test:log(" ")
		}
	let $end-time := xdmp:elapsed-time()
	return
		element test:suite {
			attribute name { $suite },
			attribute total { fn:count($results/test:test/test:result) },
			attribute passed { fn:count($results/test:test/test:result[@type = 'success']) },
			attribute failed { fn:count($results/test:test/test:result[@type = 'fail']) },
			attribute time { functx:total-seconds-from-duration($end-time - $start-time) },
			$results/test:test
		}
};

declare function run(
	$suite as xs:string,
	$name as xs:string,
	$module as xs:string,
	$run-teardown as xs:boolean,
	$coverage as map:map?)
{
	test:log(text { "    TEST:", $name }),
	let $start-time := xdmp:elapsed-time()
	let $setup := run-setup-or-teardown(fn:true(), $suite)
	let $result :=
		try {
			if (fn:not($setup/@type = "fail")) then
			(: Avoid returning result of test:log :)
				let $_ := test:log("    ...running")
				return
					if (fn:empty($coverage)) then xdmp:invoke($module)
					else prof:invoke($module)
			else ()
		}
		catch($ex) {
			test:fail($ex)
		}
	(: If we had a .sjs test module, we may get arrays back. Convert the array
	 : of results to a sequence of results.
	 :)
	let $result :=
		(
			for $value in $result
			where $value instance of json:array
			return json:array-values($value),
			(: there may be other result nodes, such as code coverage, that we want to preserve :)
			for $value in $result
			where not($value instance of json:array)
			return $value
		)
	let $teardown :=
		if ($run-teardown eq fn:true() and fn:not($setup/@type = "fail")) then
			run-setup-or-teardown(fn:false(), $suite)
		else
			test:log("    ...not running teardown")
	let $end-time := xdmp:elapsed-time()
	return
		element test:test {
			attribute name { $name },
			attribute path { $module },
			attribute time { functx:total-seconds-from-duration($end-time - $start-time) },
			$setup,
			if (fn:empty($coverage)) then $result
			else cover:results($coverage, $result),
			$teardown
		}
};


declare function format($result as element(), $format as xs:string, $suite-name as xs:string)
{
	if ($format eq "junit") then
		format-junit($result)
	else
		let $format-uris := test:list-from-database($db-id, $root || "test/formats/")
		let $xsl-match :=
			for $uri in $format-uris
			return
				if (fn:matches(fn:tokenize($uri, '/')[fn:last()], '^' || $format || $XSL-PATTERN)) then $uri
				else ()
		return
			if ($xsl-match) then
				let $xsl := $xsl-match[1]
				let $params := map:map()
				let $_ := map:put($params, "hostname", fn:tokenize(xdmp:get-request-header("Host"), ":")[1])
				let $_ := map:put($params, "timestamp", fn:current-dateTime())
				return xdmp:xslt-invoke($xsl, $result, $params)/element()
			else $result
};


declare function format-junit($result as element())
{
	element testsuite {
		attribute errors {"0"},
		attribute failures {fn:data($result/@failed)},
		attribute hostname {fn:tokenize(xdmp:get-request-header("Host"), ":")[1]},
		attribute name {fn:data($result/@name)},
		attribute tests {fn:data($result/@total)},
		attribute time {fn:data($result/@time)},
		attribute timestamp {""},
		for $test in $result/test:test
		return
			element testcase {
				attribute classname {fn:data($test/@name)},
				attribute name {fn:data($test/@name)},
				attribute time {fn:data($test/@time)},
				for $result in ($test/test:result)[1]
				where $result/@type = "fail"
				return
					element failure {
						attribute type {fn:data($result/error:error/error:name)},
						attribute message {fn:data($result/error:error/error:message)},
						format-result($result/error:error, ())
					}
			}
	}
};

declare private function format-result($result as element(), $tab as xs:string?) {
  for $node in $result/*
  let $tab := '&#9;' || $tab
  return (
    $tab || $node/fn:local-name() || ': ' || fn:normalize-space($node/text()) || '&#10;',
    if ($node/*) then format-result($node, $tab) else ()
  )
};

declare private function run-setup-or-teardown($setup as xs:boolean, $suite as xs:string)
{
	let $stage := if ($setup) then "setup" else "teardown"
	let $xquery-script := $stage || ".xqy"
	let $sjs-script := $stage || ".sjs"
	return
		try {
		(: We don't want the return value, so return () :)
			let $_ := test:log("    ...invoking " || $stage)
			let $_ := xdmp:invoke($TEST-SUITES-ROOT || $suite || "/" || $xquery-script)
			return ()
		}
		catch($ex) {
			if (($ex/error:code = "XDMP-MODNOTFOUND" and
				fn:matches($ex/error:stack/error:frame[1]/error:uri/fn:string(), "/" || $xquery-script || "$")) or
				($ex/error:code = "SVC-FILOPN" and
					fn:matches($ex/error:expr, $xquery-script))) then
				try {
					xdmp:invoke($TEST-SUITES-ROOT || $suite || "/" || $sjs-script)
				}
				catch($ex) {
					if (($ex/error:code = "XDMP-MODNOTFOUND" and
						fn:matches($ex/error:stack/error:frame[1]/error:uri/fn:string(), "/" || $sjs-script || "$")) or
						($ex/error:code = "SVC-FILOPN" and
							fn:matches($ex/error:expr, $sjs-script))) then
						()
					else
						element test:result {
							attribute type {"fail"},
							$ex
						}
				}
			else
				element test:result {
					attribute type {"fail"},
					$ex
				}
		}
};

declare private function run-setup-teardown(
	$is-setup as xs:boolean,
	$suite as xs:string
)
{
	let $start-time := xdmp:elapsed-time()
	let $stage := if ($is-setup) then "setup" else "teardown"
	let $xquery-script := "suite-" || $stage || ".xqy"
	let $sjs-script := "suite" || xdmp:initcap($stage) || ".sjs"
	return
		try {
			test:log(" - invoking suite " || $stage),
			xdmp:invoke($TEST-SUITES-ROOT || $suite || "/" || $xquery-script)
		}
		catch($ex) {
			if (($ex/error:code = "XDMP-MODNOTFOUND" and
				fn:matches($ex/error:stack/error:frame[1]/error:uri/fn:string(), "/" || $xquery-script || "$")) or
				($ex/error:code = "SVC-FILOPN" and
					fn:matches($ex/error:expr, $xquery-script))) then
				try {
					xdmp:invoke($TEST-SUITES-ROOT || $suite || "/" || $sjs-script)
				}
				catch ($ex) {
					if (($ex/error:code = "XDMP-MODNOTFOUND" and
						fn:matches($ex/error:stack/error:frame[1]/error:uri/fn:string(), "/" || $sjs-script || "$")) or
						($ex/error:code = "SVC-FILOPN" and
							fn:matches($ex/error:expr, $sjs-script))) then
						()
					else
						element test:test {
							attribute name { $sjs-script },
							attribute time { functx:total-seconds-from-duration(xdmp:elapsed-time() - $start-time) },
							element test:result {
								attribute type {"fail"},
								$ex
							}
						}
				}
			else
				element test:test {
					attribute name { $xquery-script },
					attribute time { functx:total-seconds-from-duration(xdmp:elapsed-time() - $start-time) },
					element test:result {
						attribute type {"fail"},
						$ex
					}
				}
		}
};
