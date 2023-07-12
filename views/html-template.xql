xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0"; 
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare default element namespace "http://www.w3.org/1999/xhtml";


declare option output:method "xhtml";
declare option output:media-type "application/xhtml+xml";
declare option output:omit-xml-declaration "no";
declare option output:html-version "5.0";
declare option output:indent "no";
declare option output:include-content-type "no";

(:=====
this variable allows the pipeline to work by providing
input for the section created by titles-to-html.xql
=====:)
declare variable $text := request:get-data(); 
     
<html>
    <head>
        <title>hoaXed</title>
        <link rel="stylesheet" media="screen" type="text/css" href="resources/css/hoax.css"/>
        <link rel="icon" type="image/png" href="icon.png"/>
    </head>
    <body>
        <section class="nav-menu">
            <img src="icon.png" width="35" style="margin-right:1em;"/>                     
            <header>
                <h1><a href="index">hoaXed: ghosts in 19th-c. British press</a></h1>
            </header>
            <nav>
                <ul>
                    <li><a href="search">Articles</a></li>
                    <li><a href="maps">Maps</a></li> 
                    <li><a href="visualize">Visualization</a></li>
                    <li><a href="places">Places</a></li>
                    <li><a href="people">People</a></li>     
                </ul>
            </nav>
        </section> 
        <main>{$text}</main>
        <footer>
            <hr/>
            <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img 
                alt="Creative Commons License" 
                style="border-width:0" 
                src="resources/img/cc_license_88x31.png" height="15" width="45"
            /></a> This work is licensed under a 
                <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
                <br/>Project data and research artifacts are available under an open license on <a href="https://github.com/Pittsburgh-NEH-Institute/pr-app">GitHub</a>.</footer>
    </body>
</html>