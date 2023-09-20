(: =====
search-to-html.xql

Synopsis: Process faceted full-text query

Input: Model (in model namespace) supplied by search.xql

Output: HTML <section> element with search results, to be wrapped by wrapper.xql

Notes:

1. Model has three children:

a)  <m:all-content> : Filtered only by search term, but  not by any facets. Returns full counts.
b)  <m:filtered-content> : As above, but filtered by facets. Omits some items from the above, and has different counts.
c)  <m:selected-facets> :<m:selected-publishers>. Used in this script to maintain checkbox state.
===== :)
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://www.obdurodon.org/hoaxed";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/hoax/model";
declare namespace xi="http://www.w3.org/2001/XInclude";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        (: General :)
        case text() return $node
        case element(m:count) return local:count($node)
        case element(m:data) return local:data($node)
        (: Search term :)
        case element(m:search-term) return local:search-term($node)
        (: Publishers :)
        case element(m:publishers) return local:publishers($node)
        case element(m:publisher) return local:publisher($node)
        (: Articles:)
        case element(m:articles) return local:articles($node)
        case element(m:article) return local:article($node)
        (: Error :)
        case element(m:error) return local:error($node)
        (: Default :)
        default return local:passthru($node)
};
(: General functions:)
declare function local:data($node as element(m:data)) as element(html:section) {
    <html:section id="advanced-search">
        <html:aside>
            <html:div class="panel search-panel" id="search-panel">
                <html:form action="search" method="get">{
                  local:dispatch($node/m:search-term),
                  local:dispatch($node/m:publisher-facets)
                }</html:form>
                <html:script type="text/javascript" src="resources/js/search.js"></html:script>
            </html:div>
        </html:aside>
        <html:section id="search-results">
            <html:h2>Stories ({count(root($node)/descendant::m:article)})</html:h2>
            {if ($node/m:articles/m:article)
            then local:dispatch($node/m:articles)
            else 
                if ($node/m:articles/m:error) 
                then local:dispatch($node/m:articles/m:error)
                else <html:p class="left-indent">No matching articles found.</html:p>
            }
        </html:section>
    </html:section>
};
declare function local:count($node as element(m:count)) as xs:string {
    concat(' (', $node, ')')
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
(: -----
Search term functions
----- :)
declare function local:search-term($node as element(m:search-term)) as item()+ {
    <html:div id="search-term-row">
        <html:input id="term" name="term" type="search" placeholder="[Search term]" value="{string($node)}">{string($node)}</html:input>
        <html:div class="info">ⓘ
            <html:div class="tooltip">
                <html:kbd>ghost</html:kbd> matches <html:q>ghost</html:q> but not <html:q>ghosts</html:q><html:br/>
                <html:kbd>ghost*</html:kbd> matches any any word that begins with the letters <html:q>ghost</html:q><html:br/>
                <html:kbd>police constable</html:kbd> matches either <html:q>police</html:q> or <html:q>constable</html:q><html:br/>
                <html:kbd>"police constable"</html:kbd> matches the phrase <html:q>police constable</html:q><html:br/>
                All searches are case-insensitive
            </html:div>
        </html:div>
        <html:input id="submit" type="submit" value="Submit"/>
        <html:button id="clear-form" type="reset">Clear</html:button>
    </html:div>
};
(: =====
Publisher functions
===== :)
declare function local:publishers($node as element(m:publishers)) as element(html:fieldset) {
    <html:fieldset id="publishers">
        <html:legend>Publisher</html:legend>
        <html:ul>{local:passthru($node)}</html:ul>
    </html:fieldset>
};
declare function local:publisher($node as element(m:publisher)) as element(html:li) {
    <html:li>
        {if (starts-with($node/descendant::m:count, '0')) then attribute class {"no-potential"} else ()}
        <html:label>
            <html:input type="checkbox" name="publishers[]" value="{normalize-space($node/m:label)}">{
            (: Maintain checked state :)
            if ($node/m:label = root($node)/descendant::m:selected-facets/descendant::m:publisher) 
                then attribute checked {"checked"} 
                else ()
            }</html:input>{local:passthru($node)}
        </html:label>
    </html:li>
};
(: =====
Article list functions
===== :)
declare function local:articles($node as element(m:articles)) as element(html:ul) {
    <html:ul>{local:passthru($node)}</html:ul>
};
declare function local:article($node as element(m:article)) as element(html:li) {
    (: Pass along query term if it exists so that it can be highlighted in reading view :)
    let $query-string as xs:string := 
        '?id=' || $node/m:id ||
        (if (exists(root($node)/descendant::m:term/node())) then ('&amp;term=' || root($node)/descendant::m:term) else ())
    return
    <html:li>
        <html:a href="read{$query-string}" title="{$node/m:incipit}"><html:q>{$node/m:title ! string()}</html:q></html:a>
        (<html:cite> {string-join($node/m:publisher, '; ')}</html:cite>,
        {$node/m:date ! string()}) (<html:a href="tei{$query-string}"><xi:include href="/db/apps/pr-app/resources/img/xml-link.svg"/></html:a>)      
    </html:li>
};
(: =====
Error functions
===== :)
declare function local:error($node as element(m:error)) as element(html:p)+ {
    (<html:p class="left-indent">You submitted an invalid search term. The system error message reads:</html:p>,
    <html:p class="error left-indent" role="alert">{$node}</html:p>)
};
(:=====
Main
=====:)
local:dispatch($data)