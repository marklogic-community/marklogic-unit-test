import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

declare option xdmp:mapping "false";

let $j0 := xdmp:to-json(xdmp:from-json-string(
  '{"PersonNameType":{"PersonSurName":"SMITH","PersonGivenName":"LINDSEY"}}'
))/node()

let $j1 := xdmp:to-json(xdmp:from-json-string(
  '{"PersonNameType":{"PersonSurName":"JONES","PersonGivenName":"LINDSEY"},"charges":[1,true,"a",null]}'
))/node()

let $j2 := xdmp:to-json(xdmp:from-json-string(
  '{"PersonNameType":{"PersonSurName":"JONES","PersonGivenName":"LINDSEY"},"charges":[1,true,"a",null]}'
))/node()

let $j3 := xdmp:to-json(xdmp:from-json-string(
  '{"PersonNameType":{"PersonGivenName":"LINDSEY", "PersonSurName":"JONES"},"charges":[1,true,"a",null]}'
))/node()


let $j4 :=
  let $o := json:object()
  let $pnt := json:object()
  let $_ := map:put($pnt, "PersonGivenName", "LINDSEY")
  let $_ := map:put($pnt, "PersonSurName","JONES")
  let $_ := map:put($o, "PersonNameType", $pnt)
  let $a := json:array()
  let $_ := json:array-push($a, 1)
  let $_ := json:array-push($a, fn:true())
  let $_ := json:array-push($a, "a")
  let $_ := json:array-push($a, ())
  let $_ := map:put($o, "charges", $a)
  return $o

let $j5 :=
  let $o := json:object()
  let $pnt := json:object()
  let $_ := map:put($pnt, "PersonGivenName", "LINDSEY")
  let $_ := map:put($pnt, "PersonSurName","JONES")
  let $_ := map:put($o, "PersonNameType", $pnt)
  let $a := json:array()
  let $_ := json:array-push($a, 1)
  let $_ := json:array-push($a, fn:true())
  let $_ := json:array-push($a, "a")
  let $_ := json:array-push($a, ())
  let $_ := map:put($o, "charges", $a)
  return $o

let $j6 := xdmp:to-json(xdmp:from-json-string('{ "objKeyWithNullValue": null}'))/node()

return xdmp:eager((
  test:assert-equal-json($j1, $j2),
  test:assert-equal-json($j1, $j3),
  test:assert-equal-json($j2, $j3),
  test:assert-equal-json($j4, $j5),
  test:assert-throws-error(function() {
    test:assert-equal-json($j2, $j4)
  }, "ASSERT-EQUAL-JSON-FAILED"),
  test:assert-throws-error(function() {
    test:assert-equal-json($j2, $j5)
  }, "ASSERT-EQUAL-JSON-FAILED"),
  test:assert-throws-error(function() {
    test:assert-equal-json($j0, $j5)
  }, "ASSERT-EQUAL-JSON-FAILED"),
  test:assert-equal-json($j6, $j6)
))
