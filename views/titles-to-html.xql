xquery version "3.1";
(:=====
Declare namespaces
=====:)
declare namespace hoax = "http://www.obdurodon.org/hoaxed";
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";

(:=====
the function request:get-data(); is an eXist-specific XQuery
function that we use to pass data among XQuery scripts via 
the controller.
=====:)
declare variable $data as document-node() := request:get-data();

(:=====
HTML rendering begins here
=====:)
<html:section>
{for $item in $data//m:article
    let $id as xs:string := $item/m:id ! string()
    let $link as xs:string := '?id=' || $id
    let $title as xs:string := $item/m:title ! string()
    let $publisher as xs:string :=$item/m:publisher ! string()
    let $date as xs:string :=$item/m:date ! string()
    let $incipit as xs:string :=$item/m:incipit ! string()
    
return
    <html:ul>
        <html:li>
            <html:a href="read{$link}">{$title}</html:a> 
        </html:li> 
        <html:li>{$publisher}</html:li>
        <html:li>{$date}</html:li>
        <html:li>{$incipit}</html:li>
    </html:ul>
}
</html:section>