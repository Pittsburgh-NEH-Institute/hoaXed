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


