import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

declare option xdmp:mapping "false";

let $j0 := xdmp:to-json(xdmp:from-json-string(
  '{"PersonNameType":{"PersonSurName":"SMITH","PersonGivenName":"LINDSEY"}}'
))

let $j1 := xdmp:to-json(xdmp:from-json-string(
  '{"PersonNameType":{"PersonSurName":"JONES","PersonGivenName":"LINDSEY"}}'
))

let $j2 := xdmp:to-json(xdmp:from-json-string(
  '{"PersonNameType":{"PersonSurName":"JONES","PersonGivenName":"LINDSEY"}}'
))

let $j3 := xdmp:to-json(xdmp:from-json-string(
  '{"PersonNameType":{"PersonGivenName":"LINDSEY", "PersonSurName":"JONES"}}'
))

let $j4 :=
  let $o := json:object()
  let $pnt := json:object()
  let $_ := map:put($pnt, "PersonGivenName", "LINDSEY")
  let $_ := map:put($pnt, "PersonSurName","JONES")
  let $_ := map:put($o, "PersonNameType", $pnt)
  return $o

let $j5 :=
  let $o := json:object()
  let $pnt := json:object()
  let $_ := map:put($pnt, "PersonGivenName", "LINDSEY")
  let $_ := map:put($pnt, "PersonSurName","JONES")
  let $_ := map:put($o, "PersonNameType", $pnt)
  return $o

return xdmp:eager((
  test:assert-equal-json($j1, $j2),
  test:assert-equal-json($j1, $j3),
  test:assert-equal-json($j2, $j3),
  test:assert-equal-json($j4, $j5),
  test:assert-equal-json($j2, $j4),
  test:assert-equal-json($j2, $j5),
  test:assert-throws-error(function() {
    test:assert-equal-json($j0, $j5)
  }, "ASSERT-EQUAL-JSON-FAILED")

))