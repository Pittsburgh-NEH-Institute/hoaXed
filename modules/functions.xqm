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

declare function hoax:round-geo($input as xs:string, $precision as xs:integer) as xs:string {
    format-number(
        number($input), 
        '0.' || string-join((1 to $precision) ! '0')
    )
};
