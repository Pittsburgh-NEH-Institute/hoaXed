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
declare variable $pros as xs:string := $exist:root || $exist:controller || '/data/aux_xml/persons.xml';


<m:persons>
{
    for $person in doc($pros)/descendant::tei:person
    let $surname as xs:string? := $person/tei:persName/tei:surname ! string(.)
    let $forename as xs:string? := ($person/tei:persName/tei:forename 
        => string-join(' '))[boolean(.)]
    let $abt as xs:string? := $person//tei:bibl ! normalize-space(.)
    let $job as xs:string? := $person//tei:occupation ! normalize-space(.)
    let $role as xs:string? := $person/@role ! string()
    let $gm as xs:string? := $person/@sex ! string()
    return
        <m:entry>
            <m:name>{string-join(($surname, $forename), ', ')}</m:name>
            <m:about>{$abt}</m:about>
            <m:job>{$job}</m:job>
            <m:role>{$role}</m:role>
            <m:gm>{$gm}</m:gm>
        </m:entry>
}
</m:persons>
