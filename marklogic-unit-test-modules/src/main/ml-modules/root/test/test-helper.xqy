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

module namespace test = "http://marklogic.com/test/unit";

import module namespace cvt = "http://marklogic.com/cpf/convert" at "/MarkLogic/conversion/convert.xqy";
import module namespace test = "http://marklogic.com/test/unit" at "/test/assert.xqy";

declare namespace ss="http://marklogic.com/xdmp/status/server";
declare namespace xdmp-http="xdmp:http";

declare option xdmp:mapping "false";



declare variable $test:__LINE__ as xs:int :=
  try {
    fn:error(xs:QName("boom"), "")
  }
  catch($ex) {
    $ex/error:stack/error:frame[2]/error:line
  };

declare variable $test:__CALLER_FILE__  := test:get-caller() ;

declare function test:get-caller()
as xs:string
{
  try { fn:error((), "ROXY-BOOM") }
  catch ($ex) {
    if ($ex/error:code ne 'ROXY-BOOM') then xdmp:rethrow()
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
  if ($database-id eq 0) then
    let $uri := fn:replace($uri, "//", "/")
    let $_ :=
      try {
        xdmp:filesystem-directory(cvt:basepath($uri))
      }
      catch($ex) {
        xdmp:filesystem-directory-create(cvt:basepath($uri),
          <options xmlns="xdmp:filesystem-directory-create">
            <create-parents>true</create-parents>
          </options>)
      }
    return
      xdmp:save($uri, test:get-test-file($filename))
  else
    xdmp:eval('
      xquery version "1.0-ml";

      declare variable $uri as xs:string external;
      declare variable $file as node() external;
      xdmp:document-insert($uri, $file)
    ',
      (xs:QName("uri"), $uri,
      xs:QName("file"), test:get-test-file($filename)),
      <options xmlns="xdmp:eval">
        <database>{$database-id}</database>
      </options>)
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
      xdmp:eval(
        'declare variable $file as xs:string external; fn:doc($file)',
        (xs:QName('file'), $file),
        <options xmlns="xdmp:eval">
          <database>{xdmp:modules-database()}</database>
        </options>)
  return
    if (fn:empty($unquote) or $doc/*) then
      $doc
    else
      if ($unquote eq "force-unquote") then
        try {
          xdmp:unquote($doc)
        }
        catch($ex) {
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

declare function test:http-get($url as xs:string, $options as item()? (:as (element(xdmp-http:options)|map:map)?:))
{
  let $uri := test:easy-url($url)
  return
    xdmp:http-get($uri, $options)
};

declare function test:assert-http-get-status($url as xs:string, $options as item()? (:as (element(xdmp-http:options)|map:map)?:), $status-code)
{
  let $response := test:http-get($url, $options)
  return
    test:assert-equal($status-code, fn:data($response[1]/*:code))
};

declare function test:http-post($url as xs:string, $options as item()? (:as (element(xdmp-http:options)|map:map)?:), $data as node()?)
{
  let $uri := test:easy-url($url)
  return
    xdmp:http-post($uri, $options, $data)
};

declare function test:assert-http-post-status($url as xs:string, $options as item()? (:as (element(xdmp-http:options)|map:map)?:), $data as node()?, $status-code)
{
  let $response := test:http-post($url, $options, $data)
  return
    test:assert-equal($status-code, fn:data($response[1]/*:code))
};

declare function test:http-put($url as xs:string, $options as item()? (:as (element(xdmp-http:options)|map:map)?:), $data as node()?)
{
  let $uri := test:easy-url($url)
  return
    xdmp:http-put($uri, $options, $data)
};

declare function test:assert-http-put-status($url as xs:string, $options as item()? (:as (element(xdmp-http:options)|map:map)?:), $data as node()?, $status-code)
{
  let $response := test:http-put($url, $options, $data)
  return
    test:assert-equal($status-code, fn:data($response[1]/*:code))
};

(:~
 : Convenience function to remove all xml docs from the data db
 :)
declare function test:delete-all-xml() {
  xdmp:eval('for $x in (cts:uri-match("*.xml"), cts:uri-match("*.xlsx"))
             where fn:not(fn:contains($x, "config/config.xml"))
             return
              try {xdmp:document-delete($x)}
              catch($ex) {()}')
};

declare function test:wait-for-doc($pattern, $sleep) {
  if (xdmp:eval(fn:concat("cts:uri-match('", $pattern, "')"))) then ()
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
  xdmp:eval('declare variable $msec as xs:unsignedInt external;
             xdmp:sleep($msec)',
    (xs:QName("msec"), $msec))
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
      xdmp:eval(
        'xquery version "1.0-ml";
        declare variable $PATH as xs:string external;
        try { cts:uris((), (), cts:directory-query($PATH, "infinity")) }
        catch ($ex) {
          if ($ex/error:code ne "XDMP-URILXCNNOTFOUND") then xdmp:rethrow()
          else xdmp:directory($PATH, "infinity")/xdmp:node-uri(.) }',
        (xs:QName('PATH'), $path),
        <options xmlns="xdmp:eval"><database>{$database}</database></options>)
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
    xdmp:eval('
      xquery version "1.0-ml";
      declare variable $uris external;

      $uris ! xdmp:document-delete(.)',
      map:new((map:entry("uris", $uris))),
      <options xmlns="xdmp:eval">
        <database>{xdmp:modules-database()}</database>
      </options>)
  else ()
};

(:
 : Use this function to clean up after tests that put stuff in the modules database.
 :)
declare function test:remove-modules-directories($dirs as xs:string*)
{
  if (xdmp:modules-database() ne 0) then
    xdmp:eval('
      xquery version "1.0-ml";
      declare variable $dirs external;

      $dirs ! xdmp:directory-delete(.)',
      map:new((map:entry("dirs", $dirs))),
      <options xmlns="xdmp:eval">
        <database>{xdmp:modules-database()}</database>
      </options>)
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
  typeswitch($n)
  case document-node() return document{$n/node() ! test:strip-blanks(.)}
  case element() return element{node-name($n)} {$n/@*, $n/node() ! test:strip-blanks(.)}
  case text() return if (fn:normalize-space($n) eq '') then () else $n
 default return $n
};
