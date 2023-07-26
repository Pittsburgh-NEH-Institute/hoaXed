xquery version "3.1";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://www.obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
declare namespace xi="http://www.w3.org/2001/XInclude";
(:=====
The controller passes the location where the app is insstalled as the
value of the $exist:prefix parameter, which we use to construct a
path to the file to include. The second argument to request:get-parameter()
is the default location.
=====:)
declare variable $exist:prefix as xs:string := request:get-parameter("exist:prefix", "/apps");
(:=====
We added the xi namespace below to enable XIncludes.
Learn more about XIncludes on pg 35 of the eXist book (Siegel and Retter).
=====:)
declare variable $data as document-node() := request:get-data();

<html:section>
    <xi:include href="{concat($exist:prefix, '/hoaXed/resources/includes/index.xhtml')}"/>
</html:section>