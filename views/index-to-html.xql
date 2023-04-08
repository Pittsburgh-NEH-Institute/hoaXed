xquery version "3.1";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://www.obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
(:=====
We added the xi namespace below to enable XIncludes.
Learn more about XIncludes on pg 35 of the eXist book (Siegel and Retter).
=====:)
declare namespace xi="http://www.w3.org/2001/XInclude";
declare variable $data as document-node() := request:get-data();

<html:section>
    <xi:include href="/db/apps/hoaXed/resources/includes/index.xhtml"/>
</html:section>