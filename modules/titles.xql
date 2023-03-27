xquery version "3.1";
(:==========
Declare namespaces
===========:)
declare namespace hoax = "http://www.obdurodon.org/hoaxed";
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";
(:==========
Declare global variables to path
==========:)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/hoaXed");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';

(:==========
Declare variables
==========:)
declare variable $articles-coll as document-node()+ 
    := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ 
    := $articles-coll/tei:TEI;
(:==========
Address each article, output one list element containing item elements, which hold title and date elements
==========:)
<m:list>
{for $article in $articles
    let $title as xs:string := $article//tei:titleStmt/tei:title ! fn:string(.)
    let $year as xs:string := $article//tei:sourceDesc//tei:bibl//tei:date/@when ! fn:string()
    return 
        <m:item>
            <m:title>{$title}</m:title>
            <m:date>{$year}</m:date>
        </m:item>
}
</m:list>