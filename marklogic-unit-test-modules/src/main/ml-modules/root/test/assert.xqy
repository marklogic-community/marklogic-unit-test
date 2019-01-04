xquery version "1.0-ml";

module namespace test = "http://marklogic.com/test/unit";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

declare variable $test:PREVIOUS_LINE_FILE as xs:string :=
  try {
    fn:error(xs:QName("boom"), "")
  }
  catch($ex) {
    fn:concat($ex/error:stack/error:frame[3]/error:uri, " : Line ", $ex/error:stack/error:frame[3]/error:line)
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
    attribute type { "fail" },
    typeswitch($message)
      case element(error:error) return $message
      default return
        fn:error(xs:QName("USER-FAIL"), $message)
  }
};

declare function test:assert-all-exist($count as xs:unsignedInt, $item as item()*) {
  if ($count eq fn:count($item)) then
    test:success()
  else
    fn:error(xs:QName("ASSERT-ALL-EXIST-FAILED"), "Assert All Exist failed", $item)
};

declare function test:assert-exists($item as item()*) {
  if (fn:exists($item)) then
    test:success()
  else
    fn:error(xs:QName("ASSERT-EXISTS-FAILED"), "Assert Exists failed", $item)
};

declare function test:assert-not-exists($item as item()*) {
  if (fn:not(fn:exists($item))) then
    test:success()
  else
    fn:error(xs:QName("ASSERT-NOT-EXISTS-FAILED"), "Assert Not Exists failed", $item)
};

declare function test:assert-at-least-one-equal($expected as item()*, $actual as item()*) {
  if ($expected = $actual) then
    test:success()
  else
    fn:error(xs:QName("ASSERT-AT-LEAST-ONE-EQUAL-FAILED"), "Assert At Least one Equal failed", ())
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

(: Return true if and only if the two sequences have the same values, regardless
 : of order. fn:deep-equal() returns false if items are not in the same order. :)
declare function test:assert-same-values($expected as item()*, $actual as item()*)
{
  let $expected-ordered :=
    for $e in $expected
    order by $e
    return $e
  let $actual-ordered :=
    for $a in $actual
    order by $a
    return $a
  return test:assert-equal($expected-ordered, $actual-ordered)
};

declare function test:assert-equal($expected as item()*, $actual as item()*) {
  if (test:are-these-equal($expected, $actual)) then
    test:success()
  else
    fn:error(xs:QName("ASSERT-EQUAL-FAILED"), "Assert Equal failed", ($expected, $actual))
};

declare function test:assert-equal($expected as item()*, $actual as item()*, $error-object as item()*) {
  if (test:are-these-equal($expected, $actual)) then
    test:success()
  else
    fn:error(xs:QName("ASSERT-EQUAL-FAILED"), "Assert Equal failed", ($expected, $actual, " : ", $error-object))
};

declare function test:assert-not-equal($expected as item()*, $actual as item()*) {
  if (fn:not(test:are-these-equal($expected, $actual))) then
    test:success()
  else
    fn:error(
      xs:QName("ASSERT-NOT-EQUAL-FAILED"),
      fn:concat("test name", ": Assert Not Equal failed"),
      ($expected, $actual))
};

declare function test:assert-equal-xml($expected, $actual) {
  typeswitch ($actual)
    case document-node() return
      typeswitch ($expected)
        case document-node() return
          test:assert-equal-xml($expected/node(), $actual/node())
        default return
          test:assert-equal-xml($expected, $actual/node())
    case element() return
      if (fn:empty($expected)) then
        test:assert-true(fn:false(), ("element not found in $expected : ", xdmp:path($actual)))
      else typeswitch ($expected)
        case element() return (
          test:assert-equal(fn:name($expected), fn:name($actual), ("mismatched node name ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          test:assert-equal(fn:count($expected/@*), fn:count($actual/@*), ("mismatched attribute count ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          for $attribute in $actual/@* return
            test:assert-equal-xml($expected/@*[fn:name(.) = fn:name($attribute)], $attribute),
          for $text at $i in $actual/text() return
            test:assert-equal(fn:normalize-space($expected/text()[$i]), fn:normalize-space($text), ("mismatched element text ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          test:assert-equal(fn:count($expected/*), fn:count($actual/*), ("mismatched element count ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          for $element at $i in $actual/* return
            test:assert-equal-xml($expected/*[$i], $element)
        )
        default return
          test:assert-true(fn:false(), ("type mismatch ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")"))
    case attribute() return
      if (fn:empty($expected)) then
        test:assert-true(fn:false(), ("attribute not found in $expected : ", xdmp:path($actual)))
      else typeswitch ($expected)
        case attribute() return (
          test:assert-equal(fn:name($expected), fn:name($actual), ("mismatched attribute name ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")")),
          test:assert-equal($expected/fn:data(), $actual/fn:data(), ("mismatched attribute text ($expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual), ")"))
        )
        default return
          test:assert-true(fn:false(), ("type mismatch : $expected=", xdmp:path($expected), ", $actual=", xdmp:path($actual)))
    default return
      test:assert-true(fn:false(), ("unsupported type in $actual : ", xdmp:path($actual)))
};

declare function test:assert-equal-json($expected, $actual) {
  if ($expected instance of object-node()*) then
    if ($actual instance of object-node()*) then
      if (fn:count($expected) = fn:count($actual)) then
        if (test:assert-equal-json-recursive($expected, $actual)) then
          test:success()
        else
          fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed", ($expected, $actual))
      else
        fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed (different counts of objects)", ($expected, $actual))
    else
    (: $actual is not object-node()* :)
      fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed ($actual does not consist of objects)", ($expected, $actual))
  else if ($expected instance of map:map*) then
    if ($actual instance of map:map*) then
      if (fn:count($expected) = fn:count($actual)) then
        if (test:assert-equal-json-recursive($expected, $actual)) then
          test:success()
        else
          fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed", ($expected, $actual))
      else
        fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed (different counts of objects)", ($expected, $actual))
    else
      fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed ($actual does not consist of objects)", ($expected, $actual))
  else if ($expected instance of array-node()*) then
      if ($actual instance of array-node()*) then
        if (fn:count($expected) = fn:count($actual)) then
          if (test:assert-equal-json-recursive($expected, $actual)) then
            test:success()
          else
            fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed", ($expected, $actual))
        else
          fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed (different counts of arrays)", ($expected, $actual))
      else
        fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed ($actual does not consist of arrays)", ($expected, $actual))
    else if ($expected instance of document-node()) then
        if ($actual instance of document-node()) then
          if (fn:count($expected) = fn:count($actual)) then
            if (test:assert-equal-json-recursive($expected/node(), $actual/node())) then
              test:success()
            else
              fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed (documents not equal)", ($expected, $actual))
          else
            fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed (different counts of documents)", ($expected, $actual))
        else
          fn:error(xs:QName("ASSERT-EQUAL-JSON-FAILED"), "Assert Equal Json failed ($actual is not a document)", ($expected, $actual))
      else
      (: scalar values :)
        test:assert-equal($expected, $actual)
};

declare function test:assert-equal-json-recursive($object1, $object2) as xs:boolean
{
  typeswitch($object1)
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
      $object1 = $object2
};

declare function test:assert-true($supposed-truths as xs:boolean*) {
  test:assert-true($supposed-truths, $supposed-truths)
};

declare function test:assert-true($supposed-truths as xs:boolean*, $msg as item()*) {
  if (fn:false() = $supposed-truths) then
    fn:error(xs:QName("ASSERT-TRUE-FAILED"), "Assert True failed", $msg)
  else
    test:success()
};

declare function test:assert-false($supposed-falsehoods as xs:boolean*) {
  if (fn:true() = $supposed-falsehoods) then
    fn:error(xs:QName("ASSERT-FALSE-FAILED"), "Assert False failed", $supposed-falsehoods)
  else
    test:success()
};


declare function test:assert-meets-minimum-threshold($expected as xs:decimal, $actual as xs:decimal+) {
  if (every $i in 1 to fn:count($actual) satisfies $actual[$i] ge $expected) then
    test:success()
  else
    fn:error(
      xs:QName("ASSERT-MEETS-MINIMUM-THRESHOLD-FAILED"),
      fn:concat("test name", ": Assert Meets Minimum Threshold failed"),
      ($expected, $actual))
};

declare function test:assert-meets-maximum-threshold($expected as xs:decimal, $actual as xs:decimal+) {
  if (every $i in 1 to fn:count($actual) satisfies $actual[$i] le $expected) then
    test:success()
  else
    fn:error(
      xs:QName("ASSERT-MEETS-MAXIMUM-THRESHOLD-FAILED"),
      fn:concat("test name", ": Assert Meets Maximum Threshold failed"),
      ($expected, $actual))
};

declare function test:assert-throws-error($function as xdmp:function)
{
  test:assert-throws-error_($function, json:to-array(), ())
};

declare function test:assert-throws-error($function as xdmp:function, $error-code as xs:string?)
{
  test:assert-throws-error_($function, json:to-array(), $error-code)
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $error-code as xs:string?)
{
  test:assert-throws-error_($function, json:to-array( (json:to-array($param1), json:to-array('make me a sequence')), 1 ), $error-code)
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $error-code as xs:string?)
{
  test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2))), $error-code)
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $error-code as xs:string?)
{
  test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2), json:to-array($param3))), $error-code)
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $error-code as xs:string?)
{
  test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2), json:to-array($param3), json:to-array($param4))), $error-code)
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $param5 as item()*, $error-code as xs:string?)
{
  test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2), json:to-array($param3), json:to-array($param4), json:to-array($param5))), $error-code)
};

declare function test:assert-throws-error($function as xdmp:function, $param1 as item()*, $param2 as item()*, $param3 as item()*, $param4 as item()*, $param5 as item()*, $param6 as item()*, $error-code as xs:string?)
{
  test:assert-throws-error_($function, json:to-array((json:to-array($param1), json:to-array($param2), json:to-array($param3), json:to-array($param4), json:to-array($param5), json:to-array($param6))), $error-code)
};

declare private function test:assert-throws-error_($function as xdmp:function, $params as json:array, $error-code as xs:string?)
{
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
      fn:error(xs:QName("ASSERT-THROWS-ERROR-FAILED"), "It did not throw an error")
    }
    catch($ex) {
      if ($ex/error:name eq "ASSERT-THROWS-ERROR-FAILED") then
        xdmp:rethrow()
      else if ($error-code) then
        if ($ex/error:code eq $error-code or $ex/error:name eq $error-code) then
          test:success()
        else
          (
            fn:error(xs:QName("ASSERT-THROWS-ERROR-FAILED"), fn:concat("Error code was: ", $ex/error:code, " not: ", $error-code))
          )
      else
        test:success()
    }
};
