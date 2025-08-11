(: 
This module returns two assertions and then a text node; the intent is to verify that the text node
is ignored by the Java code that parses the response into JUnit assertion results.
:)
import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";

let $doc1 := 
<ul>
  <li>Supp1: Item1, Item2</li>
  <li>Supp2: Item1</li>
  <li>Supp3: Item2</li>
</ul>
let $doc2 := 
<ul>
  <li>Supp1: Item1, Item2</li>
  <li>Supp2: Item1</li>
  <li>Supp3: Item2</li>
</ul>
let $doc3 := 
<ul>
  <li>Supp1: Item1, Item3</li>
  <li>Supp2: Item1</li>
  <li>Supp3: Item2</li>
</ul>
return
(test:assert-equal($doc1, $doc2), test:assert-not-equal($doc1, $doc3), "failMe")