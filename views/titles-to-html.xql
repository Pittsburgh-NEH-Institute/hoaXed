xquery version "3.1";
(:==========
Declare namespaces
===========:)
declare namespace hoax = "http://www.obdurodon.org/hoaxed";
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";
(:=====
the function request:get-data(); is an eXist-specific XQuery function that we use to pass data among XQuery scripts via the controller.
=====:)

declare variable $data as document-node() := request:get-data();

(:=====
HTML rendering begins here
=====:)
<html:section>
    <html:ul>{ 
        for $item in $data//m:item
        return
            <html:li>{$item/m:title || ", " || $item/m:date}</html:li>
    }</html:ul>
</html:section>