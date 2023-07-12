xquery version "3.1";
(:=====
Declare namespaces
=====:)
declare namespace hoax = "http://www.obdurodon.org/hoaxed";
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

<m:places>{
for $entry in $gazeteer/descendant::tei:place
let $place-name as xs:string+ := $entry/tei:placeName ! string()
let $geo as element(tei:geo)? := $entry/tei:location/tei:geo
let $lat as xs:string := substring-before($geo, " ")
let $long as xs:string := substring-after($geo, " ")
let $parent as xs:string? := $entry/parent::tei:place/tei:placeName[1] ! string()
return
    <m:placeEntry>
        {$place-name !  <m:placeName>{.}</m:placeName>}
        <m:geo>
            <m:lat>{$lat}</m:lat>
            <m:long>{$long}</m:long>
        </m:geo>
        {$parent ! <m:parentPlace>{.}</m:parentPlace>}
    </m:placeEntry>
}</m:places>