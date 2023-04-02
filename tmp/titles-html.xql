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
Instead of using a controller to connect the pieces of the pipeline,
we'll declare a variable to hold that data, and then we'll pipe that into
our view code. The view code is an HTML section (see above, we use the HTML
namespace in line 8.)

We can view the HTML section in a web browser by going to http://localhost:8080/exist/apps/hoaXed/tmp/titles-html.xql
==========:)
declare variable $data as element(m:list) :=
    <m:list>
        {for $article in $articles
            let $title as xs:string := $article//tei:titleStmt/tei:title ! fn:string()
            let $year as xs:string := $article//tei:sourceDesc//tei:bibl//tei:date/@when ! fn:string()
                return 
                <m:item>
                    <m:title>{$title}</m:title>
                    <m:date>{$year}</m:date>
                </m:item>
        }
    </m:list>;

(:==========
HTML rendering begins here
===========:)    
<html:section>
    <html:ul>{ 
        for $item in $data/m:item
        return
            <html:li>{$item/m:title || ", " || $item/m:date}</html:li>
    }</html:ul>
</html:section>