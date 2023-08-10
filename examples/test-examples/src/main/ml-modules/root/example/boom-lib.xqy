xquery version "1.0-ml";

module namespace ex = "http://marklogic.com/example";

declare option xdmp:mapping "false";

declare variable $BOOM_QNAME := xs:QName("MATCH-BOOM");
declare variable $BOOM_ERROR := "The values matched";

declare function mightBoom($param1, $param2) {
  if ($param1 eq $param2) then
    fn:error($BOOM_QNAME, $BOOM_ERROR)
  else (
    xdmp:log("mightBoom; the parameters are different"),
    $param1
  )
};
