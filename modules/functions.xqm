xquery version "3.1";
(:~ 
 : This module provides all functions imported into modules
 : in the app, both those called directly to create models
 : and views and those used by collections.xconf to create
 : facets and fields.
 :
 : @author gab_keane
 : @version 1.0
 :)
(:==========
Import module (hoax), tei (tei), and model (m) namespaces
==========:)
module namespace hoax="http://www.obdurodon.org/hoaxed";
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";


(: Geo functions:)

(:~ 
 : hoax:round-geo() formats and rounds geographic coordinates.
 :
 : Arity-1 version supplies default precision of 5 and calls arity-2 version
 : Arity-2 version requires user-supplied precision as second argument
 :
 : Default precision of 5 is street-level accurate while also being brief enough to display
 :
 : @param $input : xs:string any lat or long value
 : @param $precision: xs:string any positive integer
 : @return xs:string
 :)
declare function hoax:round-geo($input as xs:string) as xs:string {
    hoax:round-geo($input, 5)
};

declare function hoax:round-geo($input as xs:string, $precision as xs:integer) as xs:string {
    format-number(
        number($input), 
        '0.' || string-join((1 to $precision) ! '0')
    )
};

(:~ 
 : hoax:get-place-info() constructs a model for place information for a single place.
 
 : @param $place : a TEI place element
 : @return place element in the model namespace
 :)
declare function hoax:get-place-info($place as element(tei:place)) as element(m:place) {
    let $place-id := $place/@xml:id
    let $name as xs:string := string-join($place/tei:placeName, ', ')
    let $type as xs:string? := $place/@type ! string()
    let $link as xs:string? := $place/tei:bibl ! string()
    let $geo as xs:string := $place/tei:location/tei:geo ! string()
    let $settlement as xs:string? := $place/tei:location/tei:settlement ! string ()
    let $parent-place as xs:string? := $place/parent::tei:place/tei:placeName ! string () 
    return (: NB: Some values may be empty and should be created anyway :)
        <m:place>
            {$place-id}
            <m:name>{$name}</m:name>
            <m:type>{$type}</m:type>
            <m:geo>{$geo}</m:geo>
            <m:settlement>{$settlement}</m:settlement>
            <m:parent>{$parent-place}</m:parent>
            {if (empty($link)) 
                then ()
                else <m:link>{$link}</m:link>}
        </m:place>
};


(: People functions :)
(:~ 
 : hoax:get-person-info() constructs a model for personal information for a single person.
 
 : @param $place : a TEI person element
 : @return person element in the model namespace
 :)

declare function hoax:get-person-info($person as element(tei:person)) as element(m:person) {
    let $surname as xs:string := $person/tei:persName/tei:surname ! string()
    let $forename as xs:string? := $person/tei:persName/tei:forename[1] ! string()
    let $abt as xs:string? := $person//tei:bibl ! normalize-space()
    let $job as xs:string? := $person//tei:occupation ! normalize-space()
    let $role as xs:string? := $person/@role ! normalize-space()
    let $gm as xs:string? := $person/@sex ! string()
    return
        <m:person>
            <m:name>{string-join(($surname, $forename), ', ')}</m:name>
            <m:about>{$abt}</m:about>
            <m:job>{$job}</m:job>
            <m:role>{$role}</m:role>
            <m:gm>{$gm}</m:gm>
        </m:person>
};

(: Text functions :)

(:~
 : hoax:format-title() moves definite and indefinite article to 
 : the end of the title for rendering 
 : @param $title : xs:string any article title
 : @return xs:string
 :)
declare function hoax:format-title($title as xs:string) as xs:string {
    if (matches($title, '^(The|An|A) '))
    then replace($title, '^(The|An|A)( )(.+)', '$3, $1')
        ! concat(upper-case(substring(., 1, 1)), substring(., 2)) => normalize-space()
    else normalize-space($title)
};
(:~
 : hoax:word-count() tokenizes and counts the words in the tei:body element of a single article
 : @param $body : a TEI body element
 : @return xs:integer
 :)
declare function hoax:word-count($body as element(tei:body)) as xs:integer {
   count(tokenize($body))
};
(:~
 : hoax:initial-cap() capitalizes the first letter of a string
 : @param $input : any xs:string
 : @return xs:string
 :)

declare function hoax:initial-cap($input as xs:string) as xs:string {
    concat(upper-case(substring($input, 1, 1)), substring($input, 2))
};
(:~
 : hoax:create-cuuid() creates a uuid with leading consonant (stable within run)
 : @param $input : any or no xs:string 
 : @return an xs:string or nothing
 :)
declare function hoax:create-cuuid($input as xs:string?) as xs:string? {
    if ($input) then 'h' || util:uuid($input) else ()
};

(: ====
Function to sanitize user-supplied search term
Used in search.xql
==== :)
declare function hoax:sanitize-search-term(
        $path-to-data as xs:string, 
        $received-term as xs:string?
    ) as item()? {
    (: Function input could be:
        Empty sequence: return received empty sequence
        Empty string: return empty sequence (not empty string!)
        Non-empty valid Lucene string: return received non-empty received string
        Non-empty invalid (Lucene) string: <m:error> with system error message
            But: traps initial asterisk but not sequences like "hi**"
            Although "hi**" is an invalid regex in matches(), it appears to be valid
                for Lucene (whatever it might mean!)
    :)
    let $no-empty-strings := if ($received-term eq '') then () else $received-term
    return
        try {
            let $dummy as element(tei:TEI)* := collection($path-to-data)/tei:TEI[ft:query(., $no-empty-strings)]
            return $no-empty-strings
        } catch * {
            (: Lucene patterns cannot begin with ? or *. This traps any
            Lucene-invalid input :)
            <m:error>{$err:description}</m:error>
        }
};

