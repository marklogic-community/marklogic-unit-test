xquery version "1.0-ml";

(:
Defines functions that are used by the default.xqy test runner and by the REST endpoint.
:)

module namespace helper="http://marklogic.com/roxy/test-helper";

import module namespace cvt = "http://marklogic.com/cpf/convert" at "/MarkLogic/conversion/convert.xqy";
import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-nodoc-2007-01.xqy";
import module namespace helper = "http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

declare namespace t="http://marklogic.com/roxy/test";

declare variable $FS-PATH as xs:string := if (xdmp:platform() eq "winnt") then "\" else "/";
declare variable $TEST-SUITES-ROOT := "/test/suites/";
declare variable $db-id as xs:unsignedLong := xdmp:modules-database();
declare variable $root as xs:string := xdmp:modules-root();


(:
 : Returns a list of the available tests. This list is magically computed based on the modules
 :)
declare function list()
{
	let $suite-ignore-list := (".svn", "CVS", ".DS_Store", "Thumbs.db", "thumbs.db", "test-data")
	let $test-ignore-list := (
		"setup.xqy", "teardown.xqy", "setup.sjs", "teardown.sjs",
		"suite-setup.xqy", "suite-teardown.xqy", "suiteSetup.sjs", "suiteTeardown.sjs"
	)
	return
		element t:tests {
			let $suites as xs:string* :=
				if ($db-id = 0) then
					xdmp:filesystem-directory(fn:concat($root, $FS-PATH, "test/suites"))/dir:entry[dir:type = "directory" and fn:not(dir:filename = $suite-ignore-list)]/dir:filename
				else
					let $uris := helper:list-from-database($db-id, $root, (), 'suites')
					return
						fn:distinct-values(
							for $uri in $uris
							let $path := fn:replace(cvt:basepath($uri), fn:concat($root, "test/suites/?"), "")
							where $path ne "" and fn:not(fn:contains($path, "/")) and fn:not($path = $suite-ignore-list)
							return
								$path)
			let $main-formats as xs:string* :=
				if ($db-id = 0) then
					xdmp:filesystem-directory(fn:concat($root, $FS-PATH, "test/formats"))/dir:entry[dir:type = "file" and fn:not(dir:filename = $test-ignore-list)]/dir:filename[fn:ends-with(., ".xsl")]
				else
					let $uris := helper:list-from-database($db-id, $root, (), 'formats')
					return
						fn:distinct-values(
							for $uri in $uris
							let $path := fn:replace($uri, fn:concat($root, "test/formats/"), "")
							where $path ne "" and fn:not(fn:contains($path, "/")) and fn:not($path = $test-ignore-list) and (fn:ends-with($path, ".xsl"))
							return
								$path)
			return (
			    for $suite as xs:string in $suites
			    let $tests as xs:string* :=
				    if ($db-id = 0) then
				        xdmp:filesystem-directory(fn:concat($root, $FS-PATH, "test/suites/", $suite))/dir:entry[dir:type = "file" and fn:not(dir:filename = $test-ignore-list)]/dir:filename[fn:ends-with(., ".xqy") or fn:ends-with(., ".sjs")]
				    else
				        let $uris := helper:list-from-database(
						    $db-id, $root, fn:concat($suite, '/'), 'suites')    
					    return
						    fn:distinct-values(
						        for $uri in $uris
						        let $path := fn:replace($uri, fn:concat($root, "test/suites/", $suite, "/"), "")
						        where $path ne "" and fn:not(fn:contains($path, "/")) and fn:not($path = $test-ignore-list) and (fn:ends-with($path, ".xqy") or fn:ends-with($path, ".sjs"))
						        return
						            $path)
			    let $formats as xs:string* :=
			        if ($db-id = 0) then
			            xdmp:filesystem-directory(fn:concat($root, $FS-PATH, "test/suites/", $suite, "/formats"))/dir:entry[dir:type = "file" and fn:not(dir:filename = $test-ignore-list)]/dir:filename[fn:ends-with(., ".xsl")]
				    else
					    let $uris := helper:list-from-database(
						    $db-id, $root, fn:concat($suite, '/formats/'), 'suites')    
					    return
						    fn:distinct-values(
							    for $uri in $uris
							    let $path := fn:replace($uri, fn:concat($root, "test/suites/", $suite, "/formats/"), "")
							    where $path ne "" and fn:not(fn:contains($path, "/")) and fn:not($path = $test-ignore-list) and (fn:ends-with($path, ".xsl"))
							    return
								    $path)
			    where $tests
			    return 
				    element t:suite {
					    attribute path {$suite},
					    element t:tests {
						    for $test in $tests
						    return
							    element t:test {
								    attribute path {$test}
							    }
					    },
					    if ($formats) then
   					        element t:formats {
                               for $format in $formats
                               return
                                   element t:format {
                                       attribute path {$format}
                                   }
                           }
                        else ()
				    },
				if ($main-formats) then
				    element t:formats {
				        for $main-format in $main-formats
				        return
				            element t:format {
				                attribute path {$main-format}
				            }
				    }
				else ()
			)
		}
};

declare function run-suite($suite as xs:string, $tests as xs:string*, $run-suite-teardown as xs:boolean, $run-teardown as xs:boolean) {
	let $start-time := xdmp:elapsed-time()
	let $results :=
		element t:run {
			helper:log(" "),
			helper:log(text {"SUITE:", $suite}),
			run-setup-teardown(fn:true(), $suite),

			helper:log(" - invoking tests"),

			let $tests as xs:string* :=
				if ($tests) then $tests
				else
					list()/t:suite[@path = $suite]/t:tests/t:test/@path
			for $test in $tests
			return
				run($suite, $test, fn:concat($TEST-SUITES-ROOT, $suite, "/", $test), $run-teardown),

			if ($run-suite-teardown eq fn:true()) then
				run-setup-teardown(fn:false(), $suite)
			else helper:log(" - not running suite teardown"),
			helper:log(" ")
		}
	let $end-time := xdmp:elapsed-time()
	return
		element t:suite {
			attribute name { $suite },
			attribute total { fn:count($results/t:test/t:result) },
			attribute passed { fn:count($results/t:test/t:result[@type = 'success']) },
			attribute failed { fn:count($results/t:test/t:result[@type = 'fail']) },
			attribute time { functx:total-seconds-from-duration($end-time - $start-time) },
			$results/*/self::t:test
		}
};

declare function run($suite as xs:string, $name as xs:string, $module, $run-teardown as xs:boolean) {
	helper:log(text { "    TEST:", $name }),
	let $start-time := xdmp:elapsed-time()
	let $setup := run-setup-or-teardown(fn:true(), $suite)
	let $result :=
		try {
			if (fn:not($setup/@type = "fail")) then
			(: Avoid returning result of helper:log :)
				let $_ := helper:log("    ...running")
				return xdmp:invoke($module)
			else
				()
		}
		catch($ex) {
			helper:fail($ex)
		}
	(: If we had a .sjs test module, we may get arrays back. Convert the array
   : of results to a sequence of results.
   :)
	let $result :=
		if ($result instance of json:array) then
			json:array-values($result)
		else
			$result
	let $teardown :=
		if ($run-teardown eq fn:true() and fn:not($setup/@type = "fail")) then
			run-setup-or-teardown(fn:false(), $suite)
		else
			helper:log("    ...not running teardown")
	let $end-time := xdmp:elapsed-time()
	return
		element t:test {
			attribute name { $name },
			attribute time { functx:total-seconds-from-duration($end-time - $start-time) },
			$setup,
			$result,
			$teardown
		}
};


declare function format($result as element(), $format as xs:string, $suite as xs:string)
{
    if ($format eq "junit") then
        format-junit($suite)
    else
        let $format-uris := helper:list-from-database($db-id, $root, (), 'formats')
        let $suite-format-uris := helper:list-from-database($db-id, $root, $suite || '/formats/', 'suites')
        let $xsl-match := 
            for $uri in ($format-uris, $suite-format-uris)
            return 
                if (fn:matches(fn:tokenize($uri, '/')[fn:last()], '^' || $format || '(\.xsl)?$')) then $uri
                else ()
        return 
            if ($xsl-match) then
                let $xsl := $xsl-match[1]
                let $params := map:map()
                let $_ := map:put($params, "hostname", fn:tokenize(xdmp:get-request-header("Host"), ":")[1])
                let $_ := map:put($params, "timestamp", fn:current-dateTime())
                return xdmp:xslt-invoke($xsl, $result, $params)/element()
            else $result
{;


declare function format-junit($suite as element())
{
	element testsuite
	{
		attribute errors {"0"},
		attribute failures {fn:data($suite/@failed)},
		attribute hostname {fn:tokenize(xdmp:get-request-header("Host"), ":")[1]},
		attribute name {fn:data($suite/@name)},
		attribute tests {fn:data($suite/@total)},
		attribute time {fn:data($suite/@time)},
		attribute timestamp {""},
		for $test in $suite/t:test
		return
			element testcase
			{
				attribute classname {fn:data($test/@name)},
				attribute name {fn:data($test/@name)},
				attribute time {fn:data($test/@time)},
				for $result in ($test/t:result)[1]
				return
					if ($result/@type = "fail") then
						element failure
						{
							attribute type {fn:data($result/error:error/error:name)},
							attribute message {fn:data($result/error:error/error:message)},
							xdmp:quote($result/error:error)
						}
					else ()
			}
	}
};

declare private function run-setup-or-teardown($setup as xs:boolean, $suite as xs:string)
{
	let $stage := if ($setup) then "setup" else "teardown"
	let $xquery-script := $stage || ".xqy"
	let $sjs-script := $stage || ".sjs"
	return
		try {
		(: We don't want the return value, so return () :)
			let $_ := helper:log("    ...invoking " || $stage)
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
						element t:result {
							attribute type {"fail"},
							$ex
						}
				}
			else
				element t:result {
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
			helper:log(" - invoking suite " || $stage),
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
						element t:test {
							attribute name { $sjs-script },
							attribute time { functx:total-seconds-from-duration(xdmp:elapsed-time() - $start-time) },
							element t:result {
								attribute type {"fail"},
								$ex
							}
						}
				}
			else
				element t:test {
					attribute name { $xquery-script },
					attribute time { functx:total-seconds-from-duration(xdmp:elapsed-time() - $start-time) },
					element t:result {
						attribute type {"fail"},
						$ex
					}
				}
		}
};
