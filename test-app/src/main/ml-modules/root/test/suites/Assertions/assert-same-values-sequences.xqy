xquery version "1.0-ml";
import module namespace test="http://marklogic.com/test" at "/test/test-helper.xqy";

((
  test:assert-same-values(
    (),
    (),
    "Two empty sequences, should be equal."
  ),
  test:assert-same-values(
    (1),
    (1),
    "Two sequences with a single matching atomic element, should be equal."
  ),
  test:assert-same-values(
    (1, 2, 4, 3),
    (3, 4, 1, 2),
    "Two sequences with a multiple matching atomic elements, should be equal."
  ),
  test:assert-same-values(
    (1, 2, 4, 3, 4),
    (3, 4, 1, 4, 2),
    "Two sequences with a multiple matching atomic elements, should be equal."
  ),
  test:assert-same-values(
    (<A/>),
    (<A/>),
    "Two sequences with the same single XML element, should be equal."
  ),
  test:assert-same-values(
    (<A>a</A>, <B>b</B>, <D>d</D>, <C>c</C>),
    (<C>c</C>, <D>d</D>, <A>a</A>, <B>b</B>),
    "Two sequences with the same multiple XML elements, should be equal."
  )
))
