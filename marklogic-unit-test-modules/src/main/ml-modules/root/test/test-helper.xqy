(:
Copyright 2012-2019 MarkLogic Corporation

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

module namespace test = "http://marklogic.com/test";

import module namespace cvt = "http://marklogic.com/cpf/convert" at "/MarkLogic/conversion/convert.xqy";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

declare namespace ss = "http://marklogic.com/xdmp/status/server";
declare namespace xdmp-http = "xdmp:http";

declare option xdmp:mapping "false";

declare variable $test:PREVIOUS_LINE_FILE as xs:string :=
  try {
    fn:error(xs:QName("boom"), "")
  }
  catch ($ex) {
    fn:concat($ex/error:stack/error:frame[3]/error:uri, " : Line ", $ex/error:stack/error:frame[3]/error:line)
  };

declare variable $test:__LINE__ as xs:int :=
  try {
    fn:error(xs:QName("boom"), "")
  }
  catch ($ex) {
    $ex/error:stack/error:frame[2]/error:line
  };

declare variable $test:__CALLER_FILE__ := test:get-caller();

(:
 : Returns a URI identifying the directory that contains any test data files associated with the test module that invokes this.
 :)
declare function test:get-test-data-directory-uri($caller-path as xs:string) as xs:string
{
  fn:replace(
    fn:concat(
      cvt:basepath($caller-path), "/test-data/"),
    "//", "/")
};

declare function test:get-caller()
as xs:string
{
  try {fn:error((), "GETTING-CALL-STACK-FROM-ERROR")}
  catch ($ex) {
    if ($ex/error:code ne "GETTING-CALL-STACK-FROM-ERROR") then xdmp:rethrow()
    else (
      let $uri-list := $ex/error:stack/error:frame/error:uri/fn:string()
      let $this := $uri-list[1]
      return (($uri-list[. ne $this])[1], 'no file')[1])
  }
};

declare function test:get-test-file($filename as xs:string)
as document-node()
{
  test:get-test-file($filename, "text", "force-unquote")
};

declare function test:get-test-file($filename as xs:string, $format as xs:string?)
as document-node()
{
  test:get-test-file($filename, $format, ())
};

declare function test:get-test-file($filename as xs:string, $format as xs:string?, $unquote as xs:string?)
as document-node()
{
  test:get-modules-file(
    fn:replace(
      fn:concat(
        cvt:basepath($test:__CALLER_FILE__), "/test-data/", $filename),
      "//", "/"), $format, $unquote)
};

declare function test:load-test-file($filename as xs:string, $database-id as xs:unsignedLong, $uri as xs:string)
{
  test:load-test-file($filename, $database-id, $uri, xdmp:default-permissions())
};

declare function test:load-test-file($filename as xs:string, $database-id as xs:unsignedLong, $uri as xs:string, $permissions as element(sec:permission)*)
{
  test:load-test-file($filename, $database-id, $uri, $permissions, xdmp:default-collections())
};

declare function test:load-test-file($filename as xs:string, $database-id as xs:unsignedLong, $uri as xs:string, $permissions as element(sec:permission)*, $collections as xs:string*)
{
  if ($database-id eq 0) then
    let $uri := fn:replace($uri, "//", "/")
    let $_ :=
      try {
        xdmp:filesystem-directory(cvt:basepath($uri))
      }
      catch ($ex) {
        xdmp:filesystem-directory-create(cvt:basepath($uri),
          <options xmlns="xdmp:filesystem-directory-create">
            <create-parents>true</create-parents>
          </options>)
      }
    return
      xdmp:save($uri, test:get-test-file($filename))
  else
    let $doc := test:get-test-file($filename)
    return
      xdmp:invoke-function(
        function() {
          xdmp:document-insert($uri, $doc, $permissions, $collections)
        },
        <options xmlns="xdmp:eval">
          <transaction-mode>update-auto-commit</transaction-mode>
          <database>{$database-id}</database>
        </options>
      )
};

declare function test:build-uri(
  $base as xs:string,
  $suffix as xs:string) as xs:string
{
  fn:string-join(
    (fn:replace($base, "(.*)/$", "$1"),
    fn:replace($suffix, "^/(.*)", "$1")),
    "/")
};

declare function test:get-modules-file($file as xs:string) {
  test:get-modules-file($file, "text", "force-unquote")
};

declare function test:get-modules-file($file as xs:string, $format as xs:string?) {
  test:get-modules-file($file, $format, ())
};

declare function test:get-modules-file($file as xs:string, $format as xs:string?, $unquote as xs:string?) {
  let $doc :=
    if (xdmp:modules-database() eq 0) then
      xdmp:document-get(
        test:build-uri(xdmp:modules-root(), $file),
        if (fn:exists($format)) then
          <options xmlns="xdmp:document-get">
            <format>{$format}</format>
          </options>
        else
          ())
    else
      xdmp:invoke-function(
        function() {
          fn:doc($file)
        },
        <options xmlns="xdmp:eval">
          <database>{xdmp:modules-database()}</database>
        </options>
      )

  return
    if (fn:empty($unquote) or $doc/*) then
      $doc
    else
      if ($unquote eq "force-unquote") then
        try {
          xdmp:unquote($doc)
        }
        catch ($ex) {
          $doc
        }
      else
        xdmp:unquote($doc)
};

declare variable $local-url as xs:string := xdmp:get-request-protocol() || "://localhost:" || xdmp:get-request-port();
declare variable $test:DEFAULT_HTTP_OPTIONS := element xdmp-http:options {
  let $credential-id := xdmp:invoke-function(function() {
    xdmp:apply(xdmp:function(xs:QName('sec:credential-get-id'), "/MarkLogic/security.xqy"), "marklogic-unit-test-credentials")
  }, map:entry("database", xdmp:security-database()))
  return
    element xdmp-http:credential-id {$credential-id}
};

declare function test:easy-url($url) as xs:string
{
  if (fn:starts-with($url, "http")) then $url
  else
    fn:concat($local-url, if (fn:starts-with($url, "/")) then "" else "/", $url)
};

declare function test:http-get($url as xs:string, $options as item()?)
{
  let $uri := test:easy-url($url)
  return
    xdmp:http-get($uri, $options)
};

declare function test:assert-http-get-status($url as xs:string, $options as item()?, $status-code) {
  test:assert-http-get-status( $url, $options, $status-code, ())
};

declare function test:assert-http-get-status($url as xs:string, $options as item()?, $status-code, $message as xs:string*)
{
  let $response := test:http-get($url, $options)
  return
    test:assert-equal($status-code, fn:data($response[1]/*:code), $message)
};

declare function test:http-post($url as xs:string, $options as item()?, $data as node()?)
{
  let $uri := test:easy-url($url)
  return
    xdmp:http-post($uri, $options, $data)
};

declare function test:assert-http-post-status($url as xs:string, $options as item()?, $data as node()?, $status-code)
{
  assert-http-post-status($url, $options, $data, $status-code, ())
};

declare function test:assert-http-post-status($url as xs:string, $options as item()?, $data as node()?, $status-code, $message as xs:string*)
{
  let $response := test:http-post($url, $options, $data)
  return
    test:assert-equal($status-code, fn:data($response[1]/*:code), $message)
};

declare function test:http-put($url as xs:string, $options as item()?, $data as node()?)
{
  let $uri := test:easy-url($url)
  return
    xdmp:http-put($uri, $options, $data)
};

declare function test:assert-http-put-status($url as xs:string, $options as item()?, $data as node()?, $status-code)
{
  test:assert-http-put-status($url, $options, $data, $status-code, ())
};

declare function test:assert-http-put-status($url as xs:string, $options as item()?, $data as node()?, $status-code, $message as xs:string*)
{
  let $response := test:http-put($url, $options, $data)
  return
    test:assert-equal($status-code, fn:data($response[1]/*:code), $message)
};

(:~
 : Convenience function to remove all xml docs from the data db
 :)
declare function test:delete-all-xml() {
  xdmp:invoke-function(
    function() {
      for $x in (cts:uri-match("*.xml"), cts:uri-match("*.xlsx"))
      where fn:not(fn:contains($x, "config/config.xml"))
      return
        try {xdmp:document-delete($x)}
        catch($ex) {()}
    }
  )
};

declare function test:wait-for-doc($pattern, $sleep) {
  let $uris :=
    xdmp:invoke-function(
      function() {
        cts:uri-match($pattern)
      }
    )
  return
    if (fn:exists($uris)) then ()
    else
      (
        xdmp:sleep($sleep),
        test:wait-for-doc($pattern, $sleep)
      )
};

declare function test:wait-for-truth($truth as xs:string, $sleep) {
  if (xdmp:eval($truth)) then ()
  else
    (
      xdmp:sleep($sleep),
      test:wait-for-truth($truth, $sleep)
    )
};

declare function test:wait-for-taskserver($sleep) {
(: do the sleep first. on some super awesome computers the check for active
     tasks can return 0 before they have a change to queue up :)
  test:log(fn:concat("Waiting ", $sleep, " msec for taskserver..")),
  xdmp:sleep($sleep),

  let $group-servers := xdmp:group-servers(xdmp:group())
  let $task-server := xdmp:server("TaskServer")[. = $group-servers]
  let $status := xdmp:server-status(xdmp:host(), $task-server)
  let $queue-size as xs:unsignedInt := $status/ss:queue-size
  let $active-requests as xs:unsignedInt := fn:count($status/ss:request-statuses/ss:request-status)
  return
    if ($queue-size = 0 and $active-requests = 0) then
      test:log("Done waiting for taskserver!")
    else
      test:wait-for-taskserver($sleep)
};

(:~
 : Convenience function to invoke a sleep
 :)
declare function test:sleep($msec as xs:unsignedInt) as empty-sequence() {
  xdmp:invoke-function(
    function() {
      xdmp:sleep($msec)
    }
  )
};

declare function test:log($items as item()*)
{
  let $_ := fn:trace($items, "UNIT-TEST")
  return ()
};

declare function test:list-from-database(
  $database as xs:unsignedLong,
  $path as xs:string)
as xs:string*
{
(: Add trailing '/' if missing :)
  let $path := fn:replace($path, "([^/])$", "$1/")
  return
    if ($database = 0) then
      let $directory-separator := if (xdmp:platform() eq "winnt") then "\\" else "/"
      return test:list-from-filesystem(fn:replace($path, "(/|\\)", $directory-separator))
    else
      xdmp:invoke-function(
        function() {
          try {
            cts:uris((), (), cts:directory-query($path, "infinity"))
          } catch ($ex) {
            if ($ex/error:code ne "XDMP-URILXCNNOTFOUND") then xdmp:rethrow()
            else xdmp:directory($path, "infinity")/xdmp:node-uri(.)
          }
        },
        <options xmlns="xdmp:eval">
          <database>{$database}</database>
        </options>
      )
};

declare function test:list-from-filesystem($path as xs:string)
as xs:string*
{
  for $entry in xdmp:filesystem-directory($path)/dir:entry
  return
    if ($entry/dir:type = "directory") then
      test:list-from-filesystem($entry/dir:pathname)
    else if ($entry/dir:type = "file") then
      $entry/dir:pathname
    else
      ()
};

(:
 : Use this function to clean up after tests that put stuff in the modules database.
 :)
declare function test:remove-modules($uris as xs:string*)
{
  if (xdmp:modules-database() ne 0) then
    xdmp:invoke-function(
      function() {
        $uris ! xdmp:document-delete(.)
      },
      <options xmlns="xdmp:eval">
        <database>{xdmp:modules-database()}</database>
      </options>
    )
  else ()
};

(:
 : Use this function to clean up after tests that put stuff in the modules database.
 :)
declare function test:remove-modules-directories($dirs as xs:string*)
{
  if (xdmp:modules-database() ne 0) then
    xdmp:invoke-function(
      function() {
        $dirs ! xdmp:directory-delete(.)
      },
      <options xmlns="xdmp:eval">
        <database>{xdmp:modules-database()}</database>
      </options>
    )
  else ()
};

(: unquote text and get the actual doc content, but without tabs and newlines. convenience function. :)
declare function test:unquote($doc-text as xs:string)
as document-node()
{
  let $doc := fn:head(xdmp:unquote($doc-text))
  return test:strip-blanks($doc)
};

declare function test:strip-blanks($n as node()) {
  typeswitch ($n)
    case document-node() return document {$n/node() ! test:strip-blanks(.)}
    case element() return element {fn:node-name($n)} {$n/@*, $n/node() ! test:strip-blanks(.)}
    case text() return if (fn:normalize-space($n) eq '') then () else $n
    default return $n
};

(:~
 : constructs a success xml element
 :)
declare function test:success() {
  <test:result type="success"/>
};

(:~
 : constructs a failure xml element
 :)
declare function test:fail($expected as item(), $actual as item()) {
  test:fail(<oh-nos>Expected {$expected} but got {$actual} at {$test:PREVIOUS_LINE_FILE}</oh-nos>)
};

(:~
 : constructs a failure xml element
 :)
declare function test:fail($message as item()*) {
  element test:result {
    attribute type {"fail"},
    typeswitch ($message)
      case element(error:error) return $message
      default return
        fn:error(xs:QName("USER-FAIL"), $message)
  }
};

declare function test:assert-all-exist($expected-count as xs:unsignedInt, $actuals as item()*) {
  test:assert-all-exist($expected-count, $actuals, ())
};

declare function test:assert-all-exist($expected-count as xs:unsignedInt, $actuals as item()*, $message as xs:string*) {
  let $actual-count := fn:count($actuals)
  return
    if ($expected-count eq $actual-count) then
      test:success()
    else
      let $message :=
        fn:string-join((
          $message,
          "expected " || $expected-count || " items but found " || $actual-count || " items"
        ), "; ")
      return fn:error(xs:QName("ASSERT-ALL-EXIST-FAILED"), $message, $actuals)
};

declare function test:assert-exists($item as item()*) {
  test:assert-exists($item, ())
};

declare function test:assert-exists($item as item()*, $message as xs:string*) {
  if (fn:exists($item)) then
    test:success()
  else
    let $message := fn:string-join(($message, xdmp:describe($item) || " does not exist"), "; ")
    return fn:error(xs:QName("ASSERT-EXISTS-FAILED"), $message, $item)
};

declare function test:assert-not-exists($item as item()*) {
  test:assert-not-exists($item, ())
};

declare function test:assert-not-exists($item as item()*, $message as xs:string*) {
  if (fn:not(fn:exists($item))) then
    test:success()
  else
    fn:error(
      xs:QName("ASSERT-NOT-EXISTS-FAILED"),
      fn:string-join(($message, "Found unexpected items: " || xdmp:describe($item)), "; "),
      $item)
};

declare function test:assert-at-least-one-equal($expected as item()*, $actual as item()*) {
  test:assert-at-least-one-equal($expected, $actual, ())
};

declare function test:assert-at-least-one-equal($expected as item()*, $actual as item()*, $message as xs:string*) {
  if ($expected = $actual) then
    test:success()
  else
    let $message :=
      fn:string-join((
        $message,
        "nothing was equal between " || xdmp:describe($expected) || " and " || xdmp:describe($actual)
      ), "; ")
    return fn:error(xs:QName("ASSERT-AT-LEAST-ONE-EQUAL-FAILED"), $message, ())
};

declare private function test:are-these-equal($expected as item()*, $actual as item()*) {
  if (fn:count($expected) eq fn:count($actual)) then
    if ($expected instance of json:array and $actual instance of json:array) then
      test:assert-equal-json-recursive($expected, $actual)
    else
      fn:count((
        for $item at $i in $expected
        return
          fn:deep-equal($item, $actual[$i]))[. = fn:true()]) eq fn:count($expected)
  else
    fn:false()
};


declare private function test:build-results($success as xs:boolean, $differences as element(differences)?)
{
  <results>
    <success>{if ($success) then "true" else "false"}</success>
    {$differences}
  </results>
};

declare private function test:deep-equal-items-in-sequence($expected as item()*, $actual as item()*)
{
        for $item at $i in $expected
        let $deep-equal := fn:deep-equal($item, $actual[$i])[. = fn:true()]
        return
          if ($deep-equal) then
            <equal>true</equal>
          else
            <equal expected="{$item}" actual="{$actual[$i]}">false</equal>
};

declare private function test:are-these-equal-with-differences($expected as item()*, $actual as item()*) {
  if (fn:count($expected) eq fn:count($actual)) then
    if ($expected instance of json:array and $actual instance of json:array) then
      let $recursive-equal := test:assert-equal-json-recursive($expected, $actual)
      let $differences :=
        if ($recursive-equal) then
          ()
        else
          <differences><message>{fn:string-join(('expected: "' || $expected || '" actual: "' || $actual || '"'))}</message></differences>
      return test:build-results($recursive-equal, $differences)
    else
      let $comparisons := test:deep-equal-items-in-sequence($expected, $actual)
      let $equal-count := fn:count($comparisons[text() eq "true"])
      let $differences :=
        <differences>
          {
            for $difference in $comparisons[text() eq "false"]
            let $message := fn:string-join(('expected: "' || $difference/@expected || '" actual: "' || $difference/@actual || '"'))
            return <message>{$message}</message>
          }
        </differences>
      return test:build-results(($equal-count eq fn:count($expected)), $differences)
  else
    let $differences := <differences><message>Item counts do not match: expected={fn:count($expected)} actual={fn:count($actual)}</message></differences>
    return test:build-results(fn:false(), $differences)
};

(: Return true if and only if the two sequences have the same values, regardless
 : of order. fn:deep-equal() returns false if items are not in the same order. :)

declare function test:assert-same-values($expected as item()*, $actual as item()*)
{
  test:assert-same-values($expected, $actual, ())
};

declare function test:assert-same-values($expected as item()*, $actual as item()*, $message as xs:string*)
{
  let $expected-ordered := test:sort-array-or-sequence($expected)
  let $actual-ordered := test:sort-array-or-sequence($actual)
  return test:assert-equal($expected-ordered, $actual-ordered, $message)
};

declare function test:assert-equal($expected as item()*, $actual as item()*) {
  test:assert-equal($expected, $actual, ())
};

declare function test:assert-equal($expected as item()*, $actual as item()*, $message as xs:string*)
{
  let $comparison := test:are-these-equal-with-differences($expected, $actual)
  return
    if ($comparison/success/text() eq "true") then
      test:success()
    else
      let $difference-message := $comparison/differences/message[1]/text()
      let $error-message :=
        if ($message) then
          fn:string-join(($message, "; ", $difference-message))
        else
          $difference-message
      return fn:error(xs:QName("ASSERT-EQUAL-FAILED"), $error-message)
};

declare function test:assert-not-equal($not-expected as item()*, $actual as item()*) {
  test:assert-not-equal($not-expected, $actual, ())
};

declare function test:assert-not-equal($not-expected as item()*, $actual as item()*, $message as xs:string*) {
  if (fn:not(test:are-these-equal-with-differences($not-expected, $actual)/success/text() eq "true")) then
    test:success()
  else
    let $message :=
      fn:string-join((
        $message,
        "items were equal; not expected: " || xdmp:describe($not-expected) || " actual: " || xdmp:describe($actual)
      ), "; ")
    return fn:error(xs:QName("ASSERT-NOT-EQUAL-FAILED"), $message, ($not-expected, $actual))
};

declare function test:assert-equal-xml($expected, $actual) {
  test:assert-equal-xml($expected, $actual, ())
};

declare function test:assert-equal-xml($expected, $actual, $message as xs:string*) {
  typeswitch ($actual)
    case document-node() return
      typeswitch ($expected)
        case document-node() return
          test:assert-equal-xml($expected/node(), $actual/node())
        default return
          test:assert-equal-xml($expected, $actual/node())
    case element() return
      if (fn:empty($expected)) then
        test:fail(("element not found in $expected : ", xdmp:path($actual)))
      else typeswitch ($expected)
        case element() return (
          test:assert-equal(fn:name($expected), fn:name($actual), fn:concat("mismatched node name ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          test:assert-equal(fn:count($expected/@*), fn:count($actual/@*), fn:concat("mismatched attribute count ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          for $attribute in $actual/@* return
            test:assert-equal-xml($expected/@*[fn:name(.) = fn:name($attribute)], $attribute),
          for $text at $i in $actual/text() return
            test:assert-equal(fn:normalize-space($expected/text()[$i]), fn:normalize-space($text), fn:concat("mismatched element text ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          test:assert-equal(fn:count($expected/*), fn:count($actual/*), fn:concat("mismatched element count ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          for $element at $i in $actual/* return
            test:assert-equal-xml($expected/*[$i], $element)
        )
        default return
          test:fail(("type mismatch ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")"))
    case attribute() return
      if (fn:empty($expected)) then
        test:fail(("attribute not found in $expected : ", xdmp:path($actual)))
      else typeswitch ($expected)
        case attribute() return (
          test:assert-equal(fn:name($expected), fn:name($actual), fn:concat("mismatched attribute name ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          test:assert-equal($expected/fn:data(), $actual/fn:data(), fn:concat("mismatched attribute text ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")"))
        )
        default return
          test:fail(("type mismatch : $expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual)))
    default return
      test:fail(("unsupported type in $actual : ", xdmp:path($actual)))
};

declare function test:assert-equal-json($expected, $actual) {
  test:assert-equal-json($expected, $actual, ())
};

declare function test:assert-equal-json($expected, $actual, $message as xs:string*) {
  let $message := fn:string-join(($message, "expected " || xdmp:describe($expected) || " actual " || $actual), "; ")
  return
  if ($expected instance of object-node()*) then
    if ($actual instance of object-node()*) then
      if (fn:count($expected) = fn:count($actual)) then
        if (test:assert-equal-json-recursive($expected, $actual)) then
          test:success()
        else
          fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message, ($expected, $actual))
      else
        fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; different counts of objects", ($expected, $actual))
    else
    (: $actual is not object-node()* :)
      fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; actual is not an object", ($expected, $actual))
  else if ($expected instance of map:map*) then
    if ($actual instance of map:map*) then
      if (fn:count($expected) = fn:count($actual)) then
        if (test:assert-equal-json-recursive($expected, $actual)) then
          test:success()
        else
          fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message, ($expected, $actual))
      else
        fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; different counts of objects", ($expected, $actual))
    else
      fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; actual is not an object", ($expected, $actual))
  else if ($expected instance of array-node()*) then
      if ($actual instance of array-node()*) then
        if (fn:count($expected) = fn:count($actual)) then
          if (test:assert-equal-json-recursive($expected, $actual)) then
            test:success()
          else
            fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message, ($expected, $actual))
        else
          fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; different counts of arrays", ($expected, $actual))
      else
        fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; actual is not an array", ($expected, $actual))
    else if ($expected instance of document-node()) then
        if ($actual instance of document-node()) then
          if (fn:count($expected) = fn:count($actual)) then
            if (test:assert-equal-json-recursive($expected/node(), $actual/node())) then
              test:success()
            else
              fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; documents not equal", ($expected, $actual))
          else
            fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; different counts of documents", ($expected, $actual))
        else
          fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), $message || "; actual is not a document", ($expected, $actual))
      else
      (: scalar values :)
        test:assert-equal($expected, $actual, $message)
};

declare function test:assert-equal-json-recursive($object1, $object2) as xs:boolean
{
  typeswitch ($object1)
    case map:map return
      let $k1 := map:keys($object1)
      let $k2 :=
        if ($object2 instance of map:map) then
          map:keys($object2)
        else
          fn:error(
            xs:QName("ASSERT-EQUAL-JSON-FAILED"),
            "Assert Equal Json failed: comparing map to non-map",
            ($object1, $object2)
          )
      let $counts-equal := fn:count($k1) eq fn:count($k2)
      let $maps-equal :=
        for $key in map:keys($object1)
        let $v1 := map:get($object1, $key)
        let $v2 := map:get($object2, $key)
        return
          test:assert-equal-json-recursive($v1, $v2)
      return $counts-equal and fn:not($maps-equal = fn:false())
    case json:array return
      let $counts-equal := fn:count($object1) = fn:count($object2)
      let $items-equal :=
        let $o1 := json:array-values($object1)
        let $o2 :=
          if ($object2 instance of json:array) then
            json:array-values($object2)
          else
            fn:error(
              xs:QName("ASSERT-EQUAL-JSON-FAILED"),
              "Assert Equal JSON failed: comparing json:array to non-array",
              ($object1, $object2)
            )
        for $item at $i in $o1
        return
          test:assert-equal-json-recursive($item, $o2[$i])
      return
        $counts-equal and fn:not($items-equal = fn:false())
    case object-node() return
      let $m1 := fn:data($object1)
      let $m2 :=
        if ($object2 instance of object-node()) then
          fn:data($object2)
        else
          fn:error(
            xs:QName("ASSERT-EQUAL-JSON-FAILED"),
            "Assert Equal JSON failed: comparing object-node to non-object-node",
            ($object1, $object2)
          )
      let $k1 := map:keys($m1)
      let $k2 := map:keys($m2)
      let $counts-equal := fn:count($k1) eq fn:count($k2)
      let $maps-equal :=
        for $key in map:keys($m1)
        let $v1 := map:get($m1, $key)
        let $v2 := map:get($m2, $key)
        return
          test:assert-equal-json-recursive($v1, $v2)
      return $counts-equal and fn:not($maps-equal = fn:false())
    default return
      if(fn:empty($object1) and fn:empty($object2)) then
        fn:true()
      else
        $object1 = $object2
};

declare function test:assert-true($conditions as xs:boolean*) {
  test:assert-true($conditions, ())
};

declare function test:assert-true($conditions as xs:boolean*, $message as xs:string?) {
  if (fn:empty($conditions)) then
      fn:error(xs:QName("ASSERT-TRUE-FAILED"), fn:string-join(($message, "Condition was not true."), "; ") , $conditions)
  else if (fn:false() = $conditions) then
    fn:error(xs:QName("ASSERT-TRUE-FAILED"), fn:string-join(($message, "Condition was not true."), "; ") , $conditions)
  else
    test:success()
};

declare function test:assert-false($conditions as xs:boolean*) {
  test:assert-false($conditions, ())
};

declare function test:assert-false($conditions as xs:boolean*, $message as xs:string*) {
  if (fn:true() = $conditions) then
    fn:error(xs:QName("ASSERT-FALSE-FAILED"), fn:string-join(($message, "condition was not false."), "; "), $conditions)
  else
    test:success()
};

(: Deprecated.  Replaced by test:assert-greater-than-or-equal(). :)
declare function test:assert-meets-minimum-threshold($minimum as xs:decimal, $actual as xs:decimal+) {
  (
    test:assert-meets-minimum-threshold($minimum, $actual, ()),
    xdmp:log("Assertion 'assert-meets-minimum-threshold()' has been deprecated.   Use 'assert-greater-than-or-equal()' instead.", "info")
  )
};

(: Deprecated.  Replaced by test:assert-greater-than-or-equal(). :)
declare function test:assert-meets-minimum-threshold($minimum as xs:decimal, $actual as xs:decimal+, $message as xs:string*) {
  (
    if (every $i in 1 to fn:count($actual) satisfies $actual[$i] ge $minimum) then
      test:success()
    else
      let $message :=
        fn:string-join((
          $message,
          "actual: " || xdmp:describe($actual) || " is less than minimum: " || xdmp:describe($minimum)
        ), "; ")
      return fn:error(xs:QName("ASSERT-MEETS-MINIMUM-THRESHOLD-FAILED"), $message, ($minimum, $actual))
    ,
    xdmp:log("Assertion 'assert-meets-minimum-threshold()' has been deprecated.   Use 'assert-greater-than-or-equal()' instead.", "info")
  )
};

(: Deprecated.  Replaced by test:assert-less-than-or-equal(). :)
declare function test:assert-meets-maximum-threshold($maximum as xs:decimal, $actual as xs:decimal+) {
  (
    test:assert-meets-maximum-threshold($maximum, $actual, ()),
    xdmp:log("Assertion 'assert-meets-maximum-threshold()' has been deprecated.   Use 'assert-less-than-or-equal()' instead.", "info")
  )
};

(: Deprecated.  Replaced by test:assert-less-than-or-equal(). :)
declare function test:assert-meets-maximum-threshold($maximum as xs:decimal, $actual as xs:decimal+, $message as xs:string?) {
  (
    if (every $i in 1 to fn:count($actual) satisfies $actual[$i] le $maximum) then
      test:success()
    else
      fn:error(
        xs:QName("ASSERT-MEETS-MAXIMUM-THRESHOLD-FAILED"),
        fn:string-join((
          $message,
          "actual: " || xdmp:describe($actual) || " is greater than maximum: " || xdmp:describe($maximum)
        ), "; "),
        ($maximum, $actual))
    ,
    xdmp:log("Assertion 'assert-meets-maximum-threshold()' has been deprecated.   Use 'assert-less-than-or-equal()' instead.", "info")
  )
};

declare function test:assert-greater-than($value as xs:decimal, $actual as xs:decimal+) {
  test:assert-greater-than($value, $actual, ())
};

declare function test:assert-greater-than($value as xs:decimal, $actual as xs:decimal+, $message as xs:string*) {
  if (every $i in 1 to fn:count($actual) satisfies $actual[$i] gt $value) then
    test:success()
  else
    let $message :=
      fn:string-join((
        $message,
        "actual: " || xdmp:describe($actual) || " is not greater than value: " || xdmp:describe($value)
      ), "; ")
    return fn:error(xs:QName("ASSERT-GREATER-THAN-FAILED"), $message, ($value, $actual))
};

declare function test:assert-greater-than-or-equal($minimum as xs:decimal, $actual as xs:decimal+) {
  test:assert-greater-than-or-equal($minimum, $actual, ())
};

declare function test:assert-greater-than-or-equal($value as xs:decimal, $actual as xs:decimal+, $message as xs:string*) {
  if (every $i in 1 to fn:count($actual) satisfies $actual[$i] ge $value) then
    test:success()
  else
    let $message :=
      fn:string-join((
        $message,
        "actual: " || xdmp:describe($actual) || " is not greater than or equal to value: " || xdmp:describe($value)
      ), "; ")
    return fn:error(xs:QName("ASSERT-GREATER-THAN-OR-EQUAL-FAILED"), $message, ($value, $actual))
};

declare function test:assert-less-than($value as xs:decimal, $actual as xs:decimal+) {
  test:assert-less-than($value, $actual, ())
};

declare function test:assert-less-than($value as xs:decimal, $actual as xs:decimal+, $message as xs:string?) {
  if (every $i in 1 to fn:count($actual) satisfies $actual[$i] lt $value) then
    test:success()
  else
    fn:error(
      xs:QName("ASSERT-LESS-THAN-FAILED"),
      fn:string-join((
        $message,
        "actual: " || xdmp:describe($actual) || " is not less than value: " || xdmp:describe($value)
      ), "; "),
      ($value, $actual))
};

declare function test:assert-less-than-or-equal($maximum as xs:decimal, $actual as xs:decimal+) {
  test:assert-less-than-or-equal($maximum, $actual, ())
};

declare function test:assert-less-than-or-equal($value as xs:decimal, $actual as xs:decimal+, $message as xs:string?) {
  if (every $i in 1 to fn:count($actual) satisfies $actual[$i] le $value) then
    test:success()
  else
    fn:error(
      xs:QName("ASSERT-LESS-THAN-OR-EQUAL-FAILED"),
      fn:string-join((
        $message,
        "actual: " || xdmp:describe($actual) || " is not less than or equal to value: " || xdmp:describe($value)
      ), "; "),
      ($value, $actual))
};

declare function test:assert-throws-error-with-message($function as xdmp:function, $expected-error-code as xs:string, $expected-message as xs:string) {
  test:assert-throws-error-with-message($function, $expected-error-code, $expected-message, ())
};

declare function test:assert-throws-error-with-message($function as xdmp:function, $expected-error-code as xs:string, $expected-message as xs:string, $message as xs:string*) {
  test:assert-throws-error_($function, json:to-array(), $expected-error-code, $expected-message, $message)
};

declare function test:assert-throws-error($function as xdmp:function)
{
  test:assert-throws-error_($function, json:to-array(), (), ())
};

declare function test:assert-throws-error($function as xdmp:function, $error-code as xs:string?)
{
  test:assert-throws-error_($function, json:to-array(), $error-code, ())
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $error-code as xs:string?)
{
  let $_ := xdmp:log("The 'test:assert-throws-error' function with parameters is deprecated and will be removed in the 2.0 release of marklogic-unit-test. Please use the assert-throws-error function that requires a function to be passed to it.")
  return test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array('make me a sequence')), 1), $error-code, ())
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $error-code as xs:string?)
{
  let $_ := xdmp:log("The 'test:assert-throws-error' function with parameters is deprecated and will be removed in the 2.0 release of marklogic-unit-test. Please use the assert-throws-error function that requires a function to be passed to it.")
  return test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2))), $error-code, ())
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $error-code as xs:string?)
{
  let $_ := xdmp:log("The 'test:assert-throws-error' function with parameters is deprecated and will be removed in the 2.0 release of marklogic-unit-test. Please use the assert-throws-error function that requires a function to be passed to it.")
  return test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2), json:to-array($param3))), $error-code, ())
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $error-code as xs:string?)
{
  let $_ := xdmp:log("The 'test:assert-throws-error' function with parameters is deprecated and will be removed in the 2.0 release of marklogic-unit-test. Please use the assert-throws-error function that requires a function to be passed to it.")
  return test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2), json:to-array($param3), json:to-array($param4))), $error-code, ())
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $param5 as item()*, $error-code as xs:string?)
{
  let $_ := xdmp:log("The 'test:assert-throws-error' function with parameters is deprecated and will be removed in the 2.0 release of marklogic-unit-test. Please use the assert-throws-error function that requires a function to be passed to it.")
  return test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2), json:to-array($param3), json:to-array($param4), json:to-array($param5))), $error-code, ())
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $param5 as item()*, $param6 as item()*, $error-code as xs:string?)
{
  let $_ := xdmp:log("The 'test:assert-throws-error' function with parameters is deprecated and will be removed in the 2.0 release of marklogic-unit-test. Please use the assert-throws-error function that requires a function to be passed to it.")
  return test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2), json:to-array($param3), json:to-array($param4), json:to-array($param5), json:to-array($param6))), $error-code, ())
};

declare private function test:assert-throws-error_($function as xdmp:function, $params as json:array, $error-code as xs:string?, $expected-error-message as xs:string?) {
  test:assert-throws-error_($function, $params, $error-code, $expected-error-message, ())
};

declare private function test:assert-throws-error_($function as xdmp:function, $params as json:array, $error-code as xs:string?, $expected-error-message as xs:string?, $message as xs:string*)
{
  let $message-prefix := fn:string-join($message, "; ") || "; "
  let $size := json:array-size($params)
  return
    try {
      if ($size eq 0) then
        xdmp:apply($function)
      else if ($size eq 1) then
        xdmp:apply($function, json:array-values($params[1]))
      else if ($size eq 2) then
        xdmp:apply($function, json:array-values($params[1]), json:array-values($params[2]))
      else if ($size eq 3) then
        xdmp:apply($function, json:array-values($params[1]), json:array-values($params[2]), json:array-values($params[3]))
      else if ($size eq 4) then
        xdmp:apply($function, json:array-values($params[1]), json:array-values($params[2]), json:array-values($params[3]), json:array-values($params[4]))
      else if ($size eq 5) then
        xdmp:apply($function, json:array-values($params[1]), json:array-values($params[2]), json:array-values($params[3]), json:array-values($params[4]), json:array-values($params[5]))
      else if ($size eq 6) then
        xdmp:apply($function, json:array-values($params[1]), json:array-values($params[2]), json:array-values($params[3]), json:array-values($params[4]), json:array-values($params[5]), json:array-values($params[6]))
      else (: arbitrary fall-back :)
        xdmp:apply($function, json:array-values($params))
      ,
      fn:error(xs:QName("ASSERT-THROWS-ERROR-FAILED"), $message-prefix || "Did not throw an error")
    }
    catch ($ex) {
      if ($ex/error:name eq "ASSERT-THROWS-ERROR-FAILED") then
        xdmp:rethrow()
      else if ($error-code) then
        if ($ex/error:code eq $error-code or $ex/error:name eq $error-code) then
          if ($expected-error-message and fn:not($ex/error:message/text() eq $expected-error-message)) then
            (xdmp:log($ex, "info"),
            fn:error(xs:QName("ASSERT-THROWS-ERROR-FAILED"), $message-prefix
              || "Found expected error code, but not expected message:" || " expected: [" || $expected-error-message
              || "] actual: [" || $ex/error:message/fn:string() || "]"))
          else
            test:success()
        else
          (
            xdmp:log($ex, "info"),
            fn:error(xs:QName("ASSERT-THROWS-ERROR-FAILED"), $message-prefix
              || "Did not find expected error code: expected: [" || $error-code || "] actual: ["
              || $ex/error:name/fn:string() || "]")
          )
      else
        test:success()
    }
};

(:
 : If the description of incoming is 'array-node',
 :   then the developer is invoking this in XQuery and is passing in an XQuery array-node.
 : If the description is 'json:array',
 :   then the developer is invoking this in JavaScript and is passing in a regular array,
 :   or the developer is invoking this in XQuery and is using json:array() to build the object
 : Otherwise, the developer is invoking this in XQuery and is passing in a regular sequence.
 :)
declare private function test:sort-array-or-sequence($incoming as item()*)
{
    if (fn:contains(xdmp:describe($incoming), "array-node")) then
      test:sort-array-nodes($incoming)
    else if (fn:contains(xdmp:describe($incoming), "json:array")) then
      test:sort-json-array($incoming)
    else
      test:sort-sequence($incoming)
};

declare private function test:sort-sequence($incoming as item()*)
{
  for $element in $incoming
  order by $element
  return $element
};

declare private function test:sort-array-nodes($incoming as item()*)
{
    for $element in $incoming/*
    order by $element/data()
    return $element/data()
};

declare private function test:sort-json-array($incoming as item()*)
{
    for $i in 1 to fn:count(json:array-values($incoming))
    order by $incoming[$i]
    return $incoming[$i]
};
