xquery version "1.0-ml";

module namespace ex = "http://example.org";

import module namespace thsr="http://marklogic.com/xdmp/thesaurus" at "/MarkLogic/thesaurus.xqy";

declare function lookup-term($term as xs:string, $output-kind as xs:string)
{
  thsr:lookup("/thesaurus/example.xml", $term, $output-kind)
};
