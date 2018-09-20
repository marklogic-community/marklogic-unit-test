xquery version "1.0-ml";
(:
 : Copyright 2012-2018 MarkLogic Corporation
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :    http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :
 :
 : The use of the Apache License does not indicate that this project is
 : affiliated with the Apache Software Foundation.
 :
 : Code adapted from xray
 : https://github.com/robwhitby/xray/tree/v2.1
 :
 : Modifications copyright (c) 2018 MarkLogic Corporation
 :)
module namespace cover="http://marklogic.com/roxy/test-coverage";

import module namespace helper = "http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
declare namespace t = "http://marklogic.com/roxy/test";
declare default element namespace "http://marklogic.com/roxy/test";

declare option xdmp:mapping "false";

(: Half a million lines of XQuery ought to be enough for any module. :)
declare variable $LIMIT as xs:integer := 654321 ;

declare private function cover:_put(
    $map as map:map,
    $key as xs:string)
{
  map:put($map, $key, $key)
};

declare private function cover:_put-new(
    $map as map:map,
    $key as xs:string)
{
  if (fn:exists(map:get($map, $key))) then ()
  else cover:_put($map, $key)
};


declare private function cover:_map-from-sequence(
    $map as map:map,
    $seq as xs:integer*)
{
  $seq ! cover:_put($map, xs:string(.)),
  $map
};

declare private function cover:_map-from-sequence(
    $seq as xs:integer*)
{
  cover:_map-from-sequence(map:map(), $seq)
};

declare private function cover:_task-cancel-safe(
    $id as xs:unsignedLong)
{
  try {
    for $breakpoint in dbg:breakpoints($id)
    return dbg:clear($id, $breakpoint),
    dbg:detach($id),
    if (fn:empty(dbg:wait($id, 10))) then
      fn:error(xs:QName("FAILED-TO-CANCEL"), "unable to cancel a debugging request")
    else ()
  }
  catch ($ex) {
    if ($ex/error:code eq 'XDMP-NOREQUEST') then ()
    else xdmp:rethrow()
  }
};

(:
 : @param $request  the ID of a debug request
 : @param $uri  URI of a module whose coverage we are observing
 : @param $limit  maximum number of lines we'll try to observe
 : @param $results-map  map:map containing line numbers
 :)
declare private function cover:_prepare-from-request(
    $request as xs:unsignedLong,
    $uri as xs:string,
    $limit as xs:integer,
    $results-map as map:map)
{
  try {
    let $wanted-lines-map := map:get($results-map, $uri)[2]
    return
      if (fn:count(map:keys($wanted-lines-map)) > 0) then
        (: We've already gathered information on these lines :)
        ()
      else (
        helper:log(text {'cover:_prepare-from-request', ('request', $request, 'module', $uri)}),
        (: Semi-infinite loop, to be broken using DBG-LINE.
         : This avoids stack overflow errors.
         :)
        for $line in 1 to $limit
        (: We only need to break once per line, but we set a breakpoint
         : on every expression to maximize the odds of seeing that line.
         : But dbg:line will return the same expression more than once,
         : at the start of a module or when it sees an expression
         : that covers multiple lines. So we call dbg:expr for the right info.
         : Faster to loop once and call dbg:expr many extra times,
         : or gather all unique expr-ids and then loop again?
         : Because of the loop-break technique, one loop is easier.
         :)
        for $expr-id in dbg:line($request, $uri, $line)
        let $set := dbg:break($request, $expr-id)
        let $expr := dbg:expr($request, $expr-id)
        let $key := $expr/dbg:line/fn:string()
        where fn:not(map:get($wanted-lines-map, $key))
        return cover:_put($wanted-lines-map, $key),

        (: We should always hit EOF and DBG-LINE before this.
         : Tell the caller that we could not do it.
         :)
        cover:_task-cancel-safe($request),
        fn:error((), 'UNIT-TEST-TOOBIG', ('Module is too large for code coverage limit:', $limit))
      )
  } catch ($ex) {
    if ($ex/error:code = "DBG-LINE") then ()
    else if ($ex/error:code = "DBG-MODULEDNE") then
      (: Modules are not visible to this request unless they are used by the initiating main module. :)
      ()
    else if ($ex/error:code = ("DBG-REQUESTRECORD", "XDMP-MODNOTFOUND")) then
      helper:log("Error executing " || $uri || " " || ($ex/*:code))
    else
      (
        (: Avoid leaving tasks in error state on the task server. :)
        cover:_task-cancel-safe($request),
        xdmp:rethrow()
      )
  }
};

(:~
 : This function prepares code coverage information for the specified modules.
 :
 : @return map:map where the keys are module URIs and the values are a pair of maps. The first map's keys are the
 :                 lines that have code coverage (empty after this function); the second's keys are the lines that
 :                 we want to have covered.
 :)
declare private function cover:_prepare(
    $coverage-modules as xs:string+,
    $results-map as map:map,
    $test-module as xs:string)
  as map:map
{
  (: When this comes back, each map key will have two entries:
   : covered-lines-map, wanted-lines-map.
   : The wanted-lines-map will be an identity map.
   :)
  for $module in $coverage-modules
  where fn:empty(map:get($results-map, $module))
  return map:put($results-map, $module, (map:map(), map:map()))
  ,
  (: we can't currently debug SJS modules, so in order to avoid exceptions, just skip :)
  if (fn:ends-with($test-module, ".sjs")) then $results-map
  else
    let $request := dbg:invoke($test-module)
    let $do := (
        helper:log("debugging test module: " || $test-module || " for request " || $request),
        $coverage-modules ! _prepare-from-request($request, ., $LIMIT, $results-map),
        _task-cancel-safe($request),
        helper:log("cancelled " || $request)
      )
    return
      $results-map
};

(:~
 : This function prepares code coverage information for the specified modules.
 :)
declare function cover:prepare(
    $coverage-modules as xs:string*,
    $test-modules as xs:string*)
  as map:map?
{
  if (fn:empty($coverage-modules)) then ()
  else
    let $results-map := map:map()
    let $_ :=
      for $test-module in $test-modules
      return cover:_prepare($coverage-modules, $results-map, $test-module)
    return
      $results-map
};

declare private function cover:_result(
    $name as xs:string,
    $map as map:map)
{
  element { $name } {
    attribute count { map:count($map) },
    for $line in map:keys($map)
    let $line-number := xs:integer($line)
    order by $line-number
    return $line-number
  }
};

declare function cover:results(
    $results-map as map:map,
    $results as item()*)
{
  $results[fn:not(. instance of element(prof:report))]
  ,
  (: report test-level coverage data :)
  let $modules := map:keys($results-map)
  let $do :=
    (: Populate the coverage maps from the profiler output. :)
    for $expr in $results[. instance of element(prof:report)]/prof:histogram/prof:expression[prof:uri = $modules]
    let $covered := map:get($results-map, $expr/prof:uri)[1]
    let $line := $expr/prof:line/fn:string()
    return cover:_put-new($covered, $line)

  for $uri in $modules
  let $seq := map:get($results-map, $uri)
  let $covered := $seq[1]
  let $wanted := $seq[2]
  let $difference := $covered - $wanted
  let $assert := (
    if (map:count($difference) eq 0) then ()
    else
      (
        helper:log(
          fn:string-join(
            ('cover:results',
            ($uri, "more coverage than expected: lines = ",
            map:keys($difference)), 'warning'), " ")),
        map:keys($difference) ! cover:_put($wanted, .)
      )
  )
  order by $uri
  return
    element t:coverage {
      attribute uri { $uri },
      cover:_result('wanted', $wanted),
      cover:_result('covered', $covered),
      cover:_result('missing', $wanted - $covered)
    }
};

(:~
 : Return a list of the XQuery modules eligible for code coverage.
:)
declare function list-coverage-modules() as xs:string*
{
  let $database-id as xs:unsignedLong := xdmp:modules-database()
  let $modules-root as xs:string := xdmp:modules-root()
  let $module-extensions as xs:string* := (".xqy", ".xqe", ".xq", ".xquery")
  return
    if ($database-id = 0) then
      list-coverage-modules-from-filesystem($modules-root, $module-extensions)
    else
      list-coverage-modules-from-database($database-id, $modules-root, $module-extensions)
};

declare function list-coverage-modules-from-database(
    $database-id as xs:unsignedLong,
    $modules-root as xs:string,
    $module-extensions as xs:string+)
{
  xdmp:invoke-function(
    function() {
      try {
        for $extension in $module-extensions
        return cts:uri-match("*" || $extension, ("document", "case-insensitive", "diacritic-sensitive"))
      }
      catch ($ex) {
        if ($ex/error:code ne "XDMP-URILXCNNOTFOUND") then xdmp:rethrow()
        else
          for $uri in xdmp:directory($modules-root, "infinity")/xdmp:node-uri(.)
          let $lower-case-uri := lower-case($uri)
          where some $extension in $module-extensions satisfies ends-with($lower-case-uri, $extension)
          return $uri
      }
    },
    <options xmlns="xdmp:eval">
      <database>{$database-id}</database>
    </options>
  )
};

(:~
 : List the modules in the specified filesystem directory, and it's subdirectories
 :)
declare function list-coverage-modules-from-filesystem(
    $modules-root as xs:string,
    $module-extensions as xs:string+)
{
  for $entry in xdmp:filesystem-directory($modules-root)/dir:entry
  where fn:not($entry/dir:filename = (".svn", "CVS", ".DS_Store"))
  return
    if ($entry[dir:type eq "file"]) then
      for $path in $entry/dir:pathname/string()
      let $lower-case-path := lower-case($path)
      where some $extension in $module-extensions satisfies ends-with($lower-case-path, $extension)
      return $path
    else
      list-coverage-modules-from-filesystem($entry/dir:pathname/string(), $module-extensions)
};

(:~
 : Generate the coverage summary for all the Suite coverage data,
 : and add it to the response.
 :)
declare function cover:summary(
    $tests as element()
  ) as element()
{
  element { fn:node-name($tests) } {
    $tests/(@*|node()),

    let $map := map:map()
    let $do :=
      for $coverage in $tests/t:suite/t:test/t:coverage
      let $uri := $coverage/@uri/fn:string()
      let $old := map:get($map, $uri)
      let $coverage-tuple := (
        (: Do we already have a 'wanted' list for this uri? :)
        if (fn:exists($old)) then $old
        else
          (: if not, lets create a new one :)
          let $new := (map:map(), map:map())
          let $put := map:put($map, $uri, $new)
          return $new
      )
      let $covered := $coverage-tuple[1]
      let $wanted := $coverage-tuple[2]
      return (
        for $line in xs:NMTOKENS($coverage/covered)
        return cover:_put-new($covered, $line),

        for $line in xs:NMTOKENS($coverage/wanted)
        return cover:_put-new($wanted, $line)
      )

    let $uris := map:keys($map)
    let $covered-count := fn:sum( for $uri in $uris return map:count(map:get($map, $uri)[1]) )
    let $wanted-count := fn:sum( for $uri in $uris return map:count(map:get($map, $uri)[2]) )
    return
      element t:coverage-summary {
        attribute wanted-count { $wanted-count },
        attribute covered-count { $covered-count },
        attribute missing-count { $wanted-count - $covered-count },
        (: by module :)
        for $uri in $uris
        let $coverage-tuple := map:get($map, $uri)
        let $covered := $coverage-tuple[1]
        let $wanted := $coverage-tuple[2]
        order by $uri
        return
          element t:module-coverage {
            attribute uri { $uri },
            cover:_result('wanted', $wanted),
            cover:_result('covered', $covered),
            cover:_result('missing', $wanted - $covered)
          }
      }
  }
};

declare function cover:module-view-text(
    $module as xs:string,
    $lines as xs:string*,
    $wanted as map:map,
    $covered as map:map,
    $missing as map:map)
{
  text { 'Module', $module },
  for $i at $x in $lines
  let $key := fn:string($x)
  return text {
    if (map:get($covered, $key)) then '+'
    else if (map:get($wanted, $key)) then '!'
    else ' ',
    $x, $i
  }
};

declare function cover:module-view-xml(
    $module as xs:string,
    $lines as xs:string*,
    $wanted as map:map,
    $covered as map:map,
    $missing as map:map)
{
  element t:module {
    attribute uri { $module },
    attribute covered { map:count($covered) },
    attribute wanted { map:count($wanted) },

    for $i at $x in $lines
    let $key := fn:string($x)
    return
      element t:line {
        attribute number { $x },
        attribute state {
          if (map:get($covered, $key)) then 'covered'
          else if (map:get($wanted, $key)) then 'wanted'
          else 'none'
        },
        $i
      }
  }
};

declare function cover:module-view(
    $module as xs:string,
    $format as xs:string,
    $lines as xs:string*,
    $wanted as map:map,
    $covered as map:map,
    $missing as map:map)
{
  if ($format eq "html") then
    xdmp:xslt-invoke(
        fn:concat("/test/xslt/coverage/module/", $format, ".xsl"),
        cover:module-view-xml($module, $lines, $wanted, $covered, $missing)
    )
  else if ($format eq "text") then cover:module-view-text($module, $lines, $wanted, $covered, $missing)
  else if ($format eq "xml") then cover:module-view-xml($module, $lines, $wanted, $covered, $missing)
  else fn:error((), "UNIT-TEST-BADFORMAT", ("Format invalid for code coverage view: ", $format))
};


declare function cover:module-view(
    $module as xs:string,
    $format as xs:string,
    $lines as xs:string*,
    $wanted as map:map,
    $covered as map:map
)
{
  cover:module-view($module, $format, $lines, $wanted, $covered, $wanted - $covered)
};


declare function cover:module-view(
    $module as xs:string,
    $format as xs:string,
    $wanted as xs:integer*,
    $covered as xs:integer*
)
{
  let $source :=
    try {
      fn:tokenize(helper:get-modules-file($module), '\n')
    } catch ($ex) {
      $ex/error:format-string
    }
  return
    cover:module-view($module, $format, $source, cover:_map-from-sequence($wanted), cover:_map-from-sequence($covered))
};
