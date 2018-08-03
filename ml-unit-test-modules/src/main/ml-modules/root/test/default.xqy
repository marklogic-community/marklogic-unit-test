(:
Copyright 2012-2015 MarkLogic Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
:)
xquery version "1.0-ml";

import module namespace helper="http://marklogic.com/roxy/test-helper"
at "/test/test-helper.xqy", "/test/test-controller.xqy";
import module namespace coverage="http://marklogic.com/roxy/test-coverage" at "/test/test-coverage.xqy";

declare namespace t="http://marklogic.com/roxy/test";

declare option xdmp:mapping "false";

declare function local:run() {
	let $suite := xdmp:get-request-field("suite")
	let $tests := fn:tokenize(xdmp:get-request-field("tests", ""), ",")[. ne ""]
	let $run-suite-teardown as xs:boolean := xdmp:get-request-field("runsuiteteardown", "") eq "true"
	let $run-teardown as xs:boolean := xdmp:get-request-field("runteardown", "") eq "true"
	let $format as xs:string := xdmp:get-request-field("format", "xml")
	let $calculate-coverage as xs:boolean := xdmp:get-request-field("calculatecoverage", "") eq "true"
	return
		if ($suite) then
			let $result := helper:run-suite($suite, $tests, $run-suite-teardown, $run-teardown, $calculate-coverage)
			return
				if ($format) then
					helper:format($result, $format, $suite)
				else
					$result
		else ()
};

declare function local:list()
{
	helper:list()
};

(:~
 : Generate the code coverage report
 :)
declare function local:coverage-report()
{
	let $test-results := xdmp:get-request-body("xml")
	let $format := xdmp:get-request-field("format", "html")
	let $params := map:new(( map:entry("test-dir", xdmp:get-request-field("/test/suites/")) ))
	let $coverage-summary := coverage:summary($test-results/*)
	return
		xdmp:xslt-invoke("/test/xslt/coverage/report/" || $format || ".xsl", $coverage-summary)
};

(:~
 : Generate view of module coverage
 :)
declare function local:coverage-module()
{
	let $module as xs:string := xdmp:get-request-field("module")
	let $format as xs:string := xdmp:get-request-field("format", "html")
	let $wanted as xs:integer* := for $line in xs:NMTOKENS(xdmp:get-request-field("wanted")) return xs:integer($line)
	let $covered as xs:integer* := for $line in xs:NMTOKENS(xdmp:get-request-field("covered")) return xs:integer($line)
	return
		coverage:module-view($module, $format, $wanted, $covered)
};

(:~
 : Provides the UI for the test framework to allow selection and running of tests
 :)
declare function local:main() {
	xdmp:set-response-content-type("text/html"),
	let $app-server := xdmp:server-name(xdmp:server())
	return
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>{$app-server} Unit Tests</title>
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<link rel="stylesheet" type="text/css" href="css/tests.css" />
				<link rel="stylesheet" type="text/css" href="css/jquery.gritter.css" />
				<script type="text/javascript" src="js/jquery-1.6.2.min.js"></script>
				<script type="text/javascript" src="js/jquery.gritter.min.js"></script>
				<script type="text/javascript" src="js/tests.js"></script>
			</head>
			<body>
				<div id="warning">
					<img src="img/warning.png" width="30" height="30"/>BEWARE OF DOG: Unit tests will wipe out your data!!<img src="img/warning.png" width="30" height="30"/>
					<div id="db-info">Current Database: <span>{xdmp:database-name(xdmp:database())}</span></div>
				</div>
				<div>
					<div id="overview" style="float:left;">
						<h2>{$app-server} Unit Tests:&nbsp;<span id="passed-count"/><span id="failed-count"/></h2>

					</div>
					<div style="float:right;">
						<input class="runtests button" type="submit" value="Run Tests" title="(ctrl-enter) works too!"/>
						<input class="canceltests button" type="submit" value="Cancel Tests" title="(Cancel key) works too!"/>
					</div>
				</div>
				<table cellspacing="0" cellpadding="0" id="tests">
					<thead>
						<tr>
							<th><input id="checkall" type="checkbox" checked="checked"/>Run</th>
							<th>Test Suite</th>
							<th>Total Test Count</th>
							<th>Tests Run</th>
							<th>Passed</th>
							<th>Failed</th>
						</tr>
					</thead>
					<tbody>
						{
							for $suite at $index in helper:list()/t:suite
							let $class := if ($index mod 2 = 1) then "odd" else "even"
							return
								(
									<tr class="{$class}">
										<td class="left"><input class="cb" type="checkbox" checked="checked" value="{fn:data($suite/@path)}"/></td>
										<td>
											<div class="test-name">
												<img class="tests-toggle-plus" src="img/arrow-right.gif"/>
												<img class="tests-toggle-minus" src="img/arrow-down.gif"/>
												{fn:data($suite/@path)} <span class="spinner"><img src="img/spinner.gif"/><b>Running...</b></span>
											</div>
										</td>
										<td>{fn:count($suite/t:tests/t:test)}</td>
										<td class="tests-run">-</td>
										<td class="passed">-</td>
										<td class="right failed">-</td>
									</tr>,
									<tr class="{$class} tests">
										<td colspan="6">
											<div class="tests">
												<div class="wrapper"><input class="check-all-tests" type="checkbox" checked="checked"/>Run All Tests</div>
												<ul class="tests">
													{
														for $test in (<t:test path="suite-setup.xqy"/>, $suite/t:tests/t:test, <t:test path="suite-teardown.xqy"/>)
														return
															<li class="tests {if (fn:ends-with($test/@path, 'setup.xqy')) then 'setup-module-hidden' else if (fn:ends-with($test/@path, 'teardown.xqy')) then 'teardown-module-hidden' else ()}">
																{
																	if ($test/@path = "suite-setup.xqy" or $test/@path = "suite-teardown.xqy" or $test/@path = "suiteSetup.sjs" or $test/@path = "suiteTeardown.sjs") then
																		<input type="hidden" value="{fn:data($test/@path)}"/>
																	else
																		<input class="test-cb" type="checkbox" checked="checked" value="{fn:data($test/@path)}"/>,
																	fn:string($test/@path)
																}<span class="outcome"></span>
															</li>
													}
												</ul>
											</div>
										</td>
									</tr>
								)
						}
					</tbody>
				</table>

				<div id="coverage-report"></div>

				<table cellspacing="0" cellpadding="0" >
					<thead>
						<tr>
							<th>Options</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><label for="runsuiteteardown">Run Teardown after each suite</label><input id="runsuiteteardown" type="checkbox" checked="checked"/></td>
						</tr>
						<tr>
							<td><label for="runteardown">Run Teardown after each test</label><input id="runteardown" type="checkbox" checked="checked"/></td>
						</tr>
						<tr>
							<td><label for="calculatecoverage">Calculate Coverage</label><input id="calculatecoverage" type="checkbox" /></td>
						</tr>
					</tbody>
				</table>
				<input class="runtests button" type="submit" value="Run Tests" title="(ctrl-enter) works too!"/>
				<input class="canceltests button" type="submit" value="Cancel Tests" title="(Cancel key) works too!"/>
				<p class="render-time">Page Rendered in: {xdmp:elapsed-time()}</p>
			</body>
		</html>
};

let $func := xdmp:function(xs:QName(fn:concat("local:", xdmp:get-request-field("func", "main"))))
return
	xdmp:apply($func)
