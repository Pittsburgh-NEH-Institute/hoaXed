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

(:=====
Declare variables to set path to articles
=====:)
declare variable $articles-coll as document-node()+ 
    := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ 
    := $articles-coll/tei:TEI;

(:=====
Address each article, output one list element containing item elements, which hold title, date, publisher, and incipit elements
=====:)
<m:articles>
{for $article in $articles[ft:query(., (), map{'fields':('formatted-title','formatted-publisher', 'formatted-date', 'incipit')})]
            let $id as xs:string := 
                $article/@xml:id ! string()
            let $title as xs:string := 
                ft:field($article, "formatted-title")
            let $publisher as xs:string+ := 
                ft:field($article, "formatted-publisher")
            let $date as xs:string := 
                ft:field($article, "formatted-date")
            let $incipit as xs:string :=
                ft:field($article, "incipit")
            order by $title
            return
            <m:article>
                <m:id>{$id}</m:id>
                <m:title>{$title}</m:title>
                <m:publisher>{$publisher}</m:publisher>
                <m:date>{$date}</m:date>
                <m:incipit>{$incipit}</m:incipit>
            </m:article>
    }</m:articles>