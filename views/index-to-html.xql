xquery version "3.1";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://www.obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
declare namespace xi="http://www.w3.org/2001/XInclude";

(:=====
There is no need to retrieve the data from the model because we’re
not going to use it. In Real Life we’d omit the line entirely; here
we just comment it out to draw attention to its omission.

declare variable $data as document-node() := request:get-data();
=====:)

(:=====
We added the xi namespace below to enable XIncludes.
Learn more about XIncludes on pg 35 of the eXist book (Siegel and Retter).
=====:)
<xi:include href="{
        concat(
        request:get-attribute('$exist:prefix'),
        request:get-attribute('$exist:controller'), 
        '/resources/includes/index.xhtml'
        )
    }"/>