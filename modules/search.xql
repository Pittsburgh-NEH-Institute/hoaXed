(: =====
modules/search.xql

Last update 2022-06-06 djb

Constructs model, which is serialized by views/search-to-html.xql

Behaviors:

1. All facet possibilities are always shown, whether selected or not. Facets 
   are multi-select, so show zero-valued labels because they can be added to 
   the selection.
2. Update after each change.
3. Facet counts are x/y, where x is number of items selected by other facet 
   and y is total number of items (invariant). Whether the facet value is
   selected is indicated by maintaining the checkbox state.
4. Normally returns articles that match combination of search term, publisher 
   facets, date facets.
5. There are three situations that yield no hits:
    a) If search term is not found in *any* documents (not just for selected
    facets), return informative message.
    b) If search term is not found in selected documents (but appears in others),
    return informative message.
    c) If no search term and no results because selected publishers and dates do
    do not intersect, return informative message.

TODO: Perform the triage first and don't create unneeded values
==== :)

(: =====
Import and module-specific functions
Namespace hoax is functions in functions.xqm module
Namespace hoax-search is local to current module
    declared not in local namespace to make testable
===== :)
import module namespace hoax="http://www.obdurodon.org/hoaxed" at "functions.xqm";

(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/hoax/model";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

(: =====
Retrieve controller parameters

Default path to data is xmldb:exist:///db/apps/pr-app/data/hoax_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml';

(: =====
Retrieve query parameters
User can specify:
    term : most often single word,  but any valid Lucene expressions can be used
    publishers
Null term value is returned as an empty string, and not as missing, so set
    $term explicitly to an empty sequence if no meaningful value is supplied
    to avoid raising an error
===== :)
declare variable $publishers as xs:string* := request:get-parameter('publishers[]', ());

declare variable $retrieved-term as xs:string? := (request:get-parameter('term', ()));
declare variable $term as item()? := 
    (: Value will be <m:error> or something allowed: empty sequence, empty string, non-empty string:)
    hoax:sanitize-search-term($path-to-data, $retrieved-term);

(: ====
If return is <m:error>, don't bother with anything else
Otherwise complete query
==== :)

(: =====
Fields must be specified in initial ft:query() in order to be retrievable
===== :)
let $fields as xs:string+ := ("formatted-title", "formatted-date", "formatted-publisher", "incipit")
(: =====
$all-values includes facets that will eventually have zero hits
===== :)
let $all-values as element(tei:TEI)+ :=
    collection($path-to-data)/tei:TEI
    [ft:query(., ())]
(: =====
$all-hits is used for articles list, but not for facets to refine search
===== :)
let $hit-facets as map(*) := map {
    "publisher" : $publishers
}
let $hit-options as map(*) := map {
    "facets" : $hit-facets,
    "fields" : $fields
}
let $all-hits as element(tei:TEI)* := 
    if ($term instance of element(m:error))
    (: If $term is <m:error> what we do here doesn't matter
    because we won't return it:)
    then
        collection($path-to-data)/tei:TEI
        [ft:query(., (), $hit-options)]
    else
        collection($path-to-data)/tei:TEI
        [ft:query(., $term, $hit-options)]

(: =====
Return results, order is meaningful (order is used to create view): 
    1) Search term
    2) Publisher facets to refine search
    3) Articles
    4) Selected facets (checkbox state)
===== :)
return
<m:data>
    <m:search-term>{$retrieved-term}</m:search-term>
    <m:publisher-facets>
        <m:publishers>{
            let $all-publisher-facets as map(*) := ft:facets($all-values, "publisher", ())
            let $publisher-facets as map(*) := ft:facets($all-hits, "publisher", ())
            let $publisher-elements := 
                map:for-each($all-publisher-facets, function($label, $count) {
                    <m:publisher>
                        <m:label>{$label}</m:label>
                        <m:count>{max((0,$publisher-facets($label)))}/{$count}</m:count>
                </m:publisher>})
            for $publisher-element in $publisher-elements
            order by $publisher-element/m:label
            return $publisher-element
        }</m:publishers>
    </m:publisher-facets>
    <m:articles>
        { (: from $all-hits: article data for list of articles with links :)
        if ($term instance of element(m:error)) then
            $term
        else
            for $hit in $all-hits
            let $id as xs:string := 
                $hit/@xml:id ! string()
            let $title as xs:string := 
                ft:field($hit, "formatted-title")
            let $publisher as xs:string+ := 
                ft:field($hit, "formatted-publisher")
            let $date as xs:string := 
                ft:field($hit, "formatted-date")
            let $incipit as xs:string :=
                ft:field($hit, "incipit")
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
    <m:selected-facets>
        <!-- Not rendered directly, but used to restore 
            checkbox state and triage returns with no hits 
        We use $retrieved-term (what the user typed) instead
            of $term (which we construct, and which may hold
            an <m:error>)
        -->
        <m:term>{$term}</m:term>
        <!-- debug only -->
        <m:hit-facets>{serialize($hit-facets, map { "method" : "json" })}</m:hit-facets>
        <m:publishers>{
            $publishers ! <m:publisher>{.}</m:publisher>
        }</m:publishers>
    </m:selected-facets>
    <m:hit-options>
        {serialize($hit-options, map { "method" : "json" })}
    </m:hit-options>
</m:data>