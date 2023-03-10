xquery version "3.0";

(: https://github.com/joewiz/exist/wiki/xqsuite :)

module namespace tests="http://hoax.obdurodon.org/tests";
import module namespace f="http://hoax.obdurodon.org" at "../modules/lib.xql";
declare namespace test="http://exist-db.org/xquery/xqsuite";

declare
    %test:arg("n", 1) %test:assertEquals(1)
    %test:arg("n", 5) %test:assertEquals(120)
    %test:arg("n", 1) %test:assertEquals(10000) (: should fail :)
function tests:factorial($n as xs:int) as xs:int {
    f:factorial($n)
};
