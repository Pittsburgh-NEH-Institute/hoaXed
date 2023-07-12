xquery version "3.1";
(:=====
Declare namespaces
=====:)


import module namespace hoax ="http://www.obdurodon.org/hoaxed" at "../modules/functions.xqm";

declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";
(:=====
Declare global variables to path
=====:)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/hoaXed");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';


declare variable $gazeteer as document-node() := 
    doc($exist:root || $exist:controller || '/data/aux_xml/places.xml');


for $entry in $gazeteer/descendant::tei:place

let $geo as element(tei:geo)? := $entry/tei:location/tei:geo
let $lat as xs:string := substring-before($geo, " ")
let $long as xs:string := substring-after($geo, " ")

return

<result>
{if ($lat) then hoax:round-geo($lat, 5) else ()}

</result>