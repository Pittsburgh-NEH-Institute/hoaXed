xquery version "3.0";

(: https://github.com/joewiz/exist/wiki/xqsuite :)

module namespace tests="http://hoax.obdurodon.org/tests";
declare namespace test="http://exist-db.org/xquery/xqsuite";

import module namespace hoax="http://www.obdurodon.org/hoaxed" at "../modules/functions.xqm";

declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(: geo functions :)
declare
    %test:arg('input', '51.513974')
    %test:assertEquals('51.51397')
    %test:arg('input', '51.3')
    %test:assertEquals('51.30000')
    %test:arg('input', '-.3')
    %test:assertEquals('-0.30000')
    function tests:test-round-geo($input as xs:string) as xs:string {
        hoax:round-geo($input)
    };

declare
    %test:arg('input', '51.513979')
    %test:arg('precision', 4)
    %test:assertEquals('51.5140')
    %test:arg('input', '51.3')
    %test:arg('precision', 4)
    %test:assertEquals('51.3000')
    %test:arg('input', '-.3')
    %test:arg('precision', 3)
    %test:assertEquals('-0.300')
    function tests:test-round-geo($input as xs:string, $precision as xs:integer) as xs:string {
        hoax:round-geo($input, $precision)
    };
