<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" />

<xsl:template match="/">
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

  <html>
    <head>
      <title>Browse | Search</title>
      <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    
    <!-- meilisearch searhbox css -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/docs-searchbar.js@2.1.0/dist/cdn/docs-searchbar.min.css"/>

    <script src="https://kit.fontawesome.com/55eb9c16a8.js"></script>
    <script type="text/javascript"><![CDATA[
        document.addEventListener('DOMContentLoaded', function(){ 
            function calculateSize(size)
            {
            var sufixes = ['B', 'KB', 'MB', 'GB', 'TB'];
            var output = size;
            var q = 0;
            while (size / 1024 > 1)
            {
                size = size / 1024;
                q++;
            }
            return (Math.round(size * 100) / 100) + ' ' + sufixes[q];
            }
    
            if (window.location.pathname == '/')
            {
                document.querySelector('.directory.go-up').style.visibility = 'hidden';
            }
                    var path = decodeURI(window.location.pathname).split('/');
                    var nav = document.querySelector("nav#breadcrumbs ul");
                    var pathSoFar = '';
        
                    for (var i=1; i<path.length-1; i++)
                    {
                        pathSoFar += '/' + path[i];
                        if (i < path.length-2) {
                            nav.innerHTML += '<li><a href="' + encodeURI(pathSoFar)  + '">' + path[i] + '</a></li>';
                        } else {
                            nav.innerHTML += '<li><a>' + path[i] + '</a></li>';
                        }
                    }

            var mtimes = document.querySelectorAll("table#contents td.mtime a");
            for (var i=0; i<mtimes.length; i++)
            {
                var mtime = mtimes[i].textContent;
                if (mtime)
                {
                    var d = new Date(mtime);
                    mtimes[i].textContent = d.toLocaleString();
                }
            }
            var sizes = document.querySelectorAll("table#contents td.size a");
            for (var i=0; i<sizes.length; i++)
            {
                var size = sizes[i].textContent;
                if (size)
                {
                    sizes[i].textContent = calculateSize(parseInt(size));
                }
            }

        }, false);
    ]]></script>

    <script type="text/javascript"><![CDATA[
        document.addEventListener("DOMContentLoaded", function() {

            var xhr = new XMLHttpRequest();
            xhr.open('GET', document.location, true);
            xhr.send(null);
                    xhr.addEventListener('readystatechange', function(e) {
            if (xhr.readyState == 4) {
                var headers = parseHttpHeaders(xhr.getAllResponseHeaders().toLowerCase());
                if (!headers.hasOwnProperty('x-options')){
                document.body.classList.add('nowebdav');
                }
            }
                    });
    
            var progressWin = document.getElementById('progresswin');
            var progressBar = document.getElementById('progressbar');
            var progressTrack = [];
            var totalFiles = 0;
    
            document.querySelectorAll('table#contents tr td.actions ul li a[data-action]').forEach(el => {
            el.addEventListener('click', function(e) {
                            e.preventDefault();
                            e.stopPropagation();
                var source = event.target || event.srcElement;
                var action = source.getAttribute('data-action');
                var href = source.getAttribute('href');
                if (action == 'delete') {
                deleteFile(href);
                }
            }, false);
            });
            function updateProgress(value, idx) {
                progressTrack[idx].value = value;
                var current = 0;
                for (var i=0; i<progressTrack.length; i++) {
                    current += progressTrack[i].value;
                }
                progressBar.value = current || progressBar.value;
            }
            function uploadFile(file, idx) {
                var xhr = new XMLHttpRequest();
                var formData = new FormData();
                xhr.open('PUT', document.location.href + '/' + file.name, true);
                xhr.upload.addEventListener("progress", function(e) {
                    updateProgress(e.loaded, idx);
                });
                xhr.addEventListener('readystatechange', function(e) {
                    if (xhr.readyState == 4 && (xhr.status == 200 || xhr.status == 201 || xhr.status == 204)) {
                        totalFiles--;
                    } else if (xhr.readyState == 4) {
                        alert (xhr.statusText);
                        console.log(xhr);
                        totalFiles--;
                    }
                    if (totalFiles == 0) {
                        document.location.reload();
                    }
                });
                xhr.setRequestHeader('Content-Type', 'application/octet-stream');
                xhr.send(file);
            }
            function deleteFile(path) {
            if (confirm('Are you sure you want to delete [' + path + ']?')) {
                var xhr = new XMLHttpRequest();
                xhr.open('DELETE', document.location.href + '/' + path, true);
                xhr.send();
                            xhr.addEventListener('readystatechange', function(e) {
                                    if (xhr.readyState == 4 && (xhr.status == 200 || xhr.status == 201 || xhr.status == 204)) {
                                        document.location.reload();
                                }
                            });
            }
            }
            function parseHttpHeaders(httpHeaders) {
            return httpHeaders.split("\n").map(x=>x.split(/: */,2)).filter(x=>x[0]).reduce((ac, x)=>{ac[x[0]] = x[1];return ac;}, {});
            }
        });
    ]]></script>

<!-- 
    background            #11043A
    background-gray       #362F4E
    button-inactive       #402C81
    button-active         #f0860b
    suggestion-highlight  #9481d4

 -->
    <style type="text/css"><![CDATA[
        * { box-sizing: border-box; }
        html { margin: 0px; padding: 0px; height: 100%; width: 100%; overflow-x: hidden; }
        body { background-color: #11043A; font-family: Verdana, Geneva, sans-serif; font-size: 16px; padding: 20px; margin: 0px; height: 100%; width: 100%; overflow-x: hidden; }
        table#contents td a { text-decoration: none; display: block; padding: 10px 30px 10px 30px; pointer: default; }
        table#contents { width: 80%; margin-left: 0; margin-bottom: 50px; margin-right: auto; border-collapse: collapse; border-width: 0px; }
        table#contents td { padding: 0px; word-wrap: none; white-space: nowrap; }
        table#contents td.icon, table td.size, table td.mtime, table td.actions { width: 1px; white-space: nowrap; }
        table#contents td.icon a { padding-left: 0px; padding-right: 5px; }
        table#contents td.name a { color: inherit; padding-left: 5px; }
        table#contents td.size a { color: #9e9e9e }
        table#contents td.mtime a { padding-right: 0px; color: #9e9e9e }
        table#contents tr { color: #efefef; }
        table#contents tr:hover * { color: #a1a1a1 !important; }
        table#contents tr.directory td.icon i { color: #FBDD7C !important; }
        table#contents tr.directory.go-up td.icon i { color: #BF8EF3 !important; }
        table#contents tr.separator td { padding: 10px 30px 10px 30px }
        table#contents tr.separator td hr { display: none; }
        table#contents tr td.actions ul { list-style-type: none; margin: 0px; padding: 0px; visibility: hidden; }
        table#contents tr td.actions ul li { float: left; }
        table#contents tr:hover td.actions ul { visibility: visible; }
        table#contents tr td.actions ul li a { display: inline; padding: 10px 10px 10px 10px !important; }
        table#contents tr td.actions ul li a:hover[data-action='delete'] { color: #c90000 !important; }
        body.nowebdav table#contents tr td.actions ul { display: none !important; }
        nav#breadcrumbs { width: 100%; margin-left: auto; margin-right: auto; margin-bottom: 50px; display: flex; justify-content: space-between; align-items: inherit; font-size: 12px; }
        hr#line { width: 100%; margin-left: auto; margin-right: auto; }
        nav#breadcrumbs ul { list-style: none; display: inline-block; margin: 0px; padding: 0px; }
        nav#breadcrumbs ul .icon { font-size: 14px; }
        nav#breadcrumbs ul li { float: left; }
        nav#breadcrumbs ul li a { color: #FFF; display: block; background: #402C81; text-decoration: none; position: relative; height: 40px; line-height: 40px; padding: 0 10px 0 5px; text-align: center; margin-right: 23px; margin-bottom: 10px; }
        nav#breadcrumbs ul li:nth-child(even) a { background-color: #402C81; }
        nav#breadcrumbs ul li:nth-child(even) a:before { border-color: #402C81; border-left-color: transparent; }
        nav#breadcrumbs ul li:nth-child(even) a:after { border-left-color: #402C81; }
        nav#breadcrumbs ul li:first-child a { padding-left: 15px; -moz-border-radius: 4px 0 0 4px; -webkit-border-radius: 4px; border-radius: 4px 0 0 4px; }
        nav#breadcrumbs ul li:first-child a:before { border: none; }
        nav#breadcrumbs ul li:last-child a { padding-right: 15px; -moz-border-radius: 0 4px 4px 0; -webkit-border-radius: 0; border-radius: 0 4px 4px 0; }
        nav#breadcrumbs ul li:last-child a:after { border: none; }
        nav#breadcrumbs ul li a:before, nav#breadcrumbs ul li a:after { content: ""; position: absolute; top: 0; border: 0 solid #402C81; border-width: 20px 10px; width: 0; height: 0; }
        nav#breadcrumbs ul li a:before { left: -20px; border-left-color: transparent; }
        nav#breadcrumbs ul li a:after { left: 100%; border-color: transparent; border-left-color: #402C81; }
        nav#breadcrumbs ul li a:hover { background-color: #f0860b; }
        nav#breadcrumbs ul li a:hover:before { border-color: #f0860b; border-left-color: transparent; }
        nav#breadcrumbs ul li a:hover:after { border-left-color: #f0860b; }
        nav#breadcrumbs ul li a:active { background-color: #330860; }
        nav#breadcrumbs ul li a:active:before { border-color: #330860; border-left-color: transparent; }
        nav#breadcrumbs ul li a:active:after { border-left-color: #330860; }
        div#droparea { height: 100%; width: 100%; border: 5px solid transparent; padding: 10px; }
        div#droparea.highlight { border: 5px dashed #CACACA; }
        div#progresswin { position: absolute; left: 0px; top: 0px; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.8); z-index: 10000; justify-content: center; align-items: center; display: none; }
        div#progresswin.show { display: flex !important; }
        div#progresswin progress#progressbar { width: 25%; }
        .fa-folder::before { color: inherit; }
        .fa-folder-yellow::before { color: #FBDD7C; content: "\f07b"; }
        .fa-file::before { color: #efefef; }

        a.docs-searchbar-suggestion { text-decoration: none; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion--subcategory-column { word-wrap: anywhere; background: #402C81; border-radius: 16px 0px 0px 16px; padding: 15px 10px 15px 10px; color: #fff; width: 50%; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion--highlight { font-weight: bold; background: unset; color: #f0860b; }
        .meilisearch-autocomplete .docs-searchbar-suggestion--title { font-weight: unset; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion--title { font-weight: unset; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .dsb-dropdown-menu .dsb-suggestion { height: auto; padding-bottom: 5px; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion.docs-searchbar-suggestion__main .docs-searchbar-suggestion--category-header { display: inherit; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .dsb-dropdown-menu [class^="dsb-dataset-"] { background: #362F4E; border: unset; border-radius: 16px; padding: 0px 10px 25px 20px; width: 358%; right: 258%; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion { background: #362F4E; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion--category-header .docs-searchbar-suggestion--category-header-lvl0 .docs-searchbar-suggestion--highlight, div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion--category-header .docs-searchbar-suggestion--category-header-lvl1 .docs-searchbar-suggestion--highlight { box-shadow: unset; color: #f0860b; }
        .meilisearch-autocomplete .docs-searchbar-suggestion--category-header { color: #402C81; border: unset; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .dsb-dropdown-menu::before { display: none; }
        div[data-ds-theme="dark"] .searchbox { height: 40px; width: 250px; font-size: 18px; }
        div[data-ds-theme="dark"] .searchbox input { background: #402C81; box-shadow: unset; transition: unset; }
        div[data-ds-theme="dark"] .searchbox__submit { margin-right: 5px; fill: #fff; margin-left: 5px; }
        div[data-ds-theme="dark"] .searchbox input:hover {  box-shadow: inset 0 0 0 2px #f0860b }
        div[data-ds-theme="dark"] .searchbox input:active, div[data-ds-theme="dark"] .searchbox input:focus { background: #402C81; box-shadow: 0px 0px 0px 10000px rgb(0,0,0,0.5); }
        div[data-ds-theme="dark"] .searchbox__submit svg { width: 20px; height: 20px; fill: inherit }
        div[data-ds-theme="dark"] .searchbox input { padding: 0 26px 0 45px; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-footer { display: none; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .dsb-dropdown-menu .dsb-suggestion.dsb-cursor .docs-searchbar-suggestion:not(.suggestion-layout-simple) .docs-searchbar-suggestion--content { border-radius: 0px 16px 16px 0px; background-color: #402C81; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion--wrapper { align-items: inherit; }
        div[data-ds-theme="dark"] .searchbox input::placeholder { font-family: "Courier New";}
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion--category-header { font-size: 0.7em; display: block; margin-top: 50px; color: #888; }
        div[data-ds-theme="dark"] .meilisearch-autocomplete .docs-searchbar-suggestion { display: contents; }

        }


    ]]></style>
    </head>
    <body>
      <div id="progresswin">
        <progress id="progressbar"></progress>
      </div>
      <div id="droparea">
          <nav id="breadcrumbs"><ul><li><a href="/"><i class="fa fa-home"></i></a></li></ul>
                <input type="search" id="search-bar-input" />
            </nav>

            <hr id="line"/>
          <table id="contents">
            <tbody>
                <tr class="directory go-up">
                  <td class="icon"><a href="../"><i class="fa fa-arrow-up"></i></a></td>
                  <td class="name"><a href="../">..</a></td>
                  <td class="size"><a href="../"></a></td>
                  <td class="mtime"><a href="../"></a></td>
                      <td class="actions"><a href="../"></a></td>
                </tr>
    
              <xsl:if test="count(list/directory) != 0">
                <tr class="separator directories">
                  <td colspan="4"><hr/></td>
                </tr>
              </xsl:if>

              <xsl:for-each select="list/directory">
                <tr class="directory">
                    <td class="icon"><a href="{.}/"><i class="fa fa-folder"></i></a></td>
                    <td class="name"><a href="{.}/"><xsl:value-of select="." /></a></td>
                    <td class="size"><a href="{.}/"></a></td>
                    <td class="mtime"><a href="{.}/"><xsl:value-of select="./@mtime" /></a></td>
                    <td class="actions"></td>
                </tr>
              </xsl:for-each>

              <xsl:if test="count(list/file) != 0">
                <tr class="separator files">
                  <td colspan="4"><hr/></td>
                </tr>
              </xsl:if>

              <xsl:for-each select="list/file">
                <tr id="{translate(., ' ', '_')}" class="file">
                  <td class="icon"><a href="{.}" download="{.}"><i class="fa fa-file"></i></a></td>
                  <td class="name"><a href="{.}" download="{.}"><xsl:value-of select="." /></a></td>
                  <td class="size"><a href="{.}" download="{.}"><xsl:value-of select="./@size" /></a></td>
                  <td class="mtime"><a href="{.}" download="{.}"><xsl:value-of select="./@mtime" /></a></td>
                  <td class="actions"></td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/docs-searchbar.js@2.1.0/dist/cdn/docs-searchbar.min.js"></script>
    <script type="text/javascript"><![CDATA[
        docsSearchBar({
            hostUrl: 'http://172.17.17.230:7700',
            apiKey: '5o1elEzQ871df4877ca5a5ca5b2bc53a1e566737b39dbb9666f094d072661d99d17e3d19',
            indexUid: 'docs',
            inputSelector: '#search-bar-input',
            enhancedSearchInput: true,
            enableDarkMode: true,
            meilisearchOptions: {
                limit: 10,
            },
            debug: false,
            transformData: function (data) {
                // console.log(data);

                for (let i = 0; i < data.length; i++) {
                    // prepare
                    var raw_url = data[i]["_formatted"]["url"];
                    var url;
                    var directory = data[i]["_formatted"]["hierarchy_lvl0"];
                    var filename = data[i]["_formatted"]["hierarchy_lvl1"];

                    var subcategory = ""
                    var SUBCATEGORY_LIMIT = 55;

                    // reformat
                    {
                        url = new URL(raw_url).pathname;
                        url = decodeURI(url);
                        url = url.replaceAll("</em>", "<=em>");
                        url = url.slice(0, url.lastIndexOf('/'));
                        url = url.replaceAll("/", '\xa0\xa0\xa0→\xa0<i class="fa fa-folder"></i> ');
                        url = url.replaceAll("<=em>", "</em>");
                    }
                    {
                        if (filename == null && directory == null) {
                            filename = decodeURI(new URL(raw_url).pathname).slice(0, url.lastIndexOf('/'));
                            filename = filename.split('/').slice(-1)[0];
                        }
                        if (filename) {
                            // match file name
                            subcategory = filename;

                            if(subcategory.replaceAll("<em>", "").replaceAll("</em>", "").length > SUBCATEGORY_LIMIT) {
                                subcategory = subcategory.substring(0,SUBCATEGORY_LIMIT) + "...";
                            }
                            subcategory = '<i class="fa fa-file"></i> ' + subcategory;

                        } else {                        
                            // match directory name
                            subcategory = directory;

                            if(subcategory.replaceAll("<em>", "").replaceAll("</em>", "").length > SUBCATEGORY_LIMIT) {
                                subcategory = subcategory.substring(0,SUBCATEGORY_LIMIT) + "...";
                            }
                            subcategory = '<i class="fa fa-folder-yellow"></i> ' + subcategory;

                        } 



                    }


                    // apply
                    data[i]["_formatted"]["hierarchy_lvl0"] = '<i class="fa fa-home"></i>' + url;
                    data[i]["hierarchy_lvl0"] = "main"
                    
                    data[i]["_formatted"]["hierarchy_lvl1"] = subcategory;
                    data[i]["hierarchy_lvl1"] = "main";

                    data[i]["_formatted"]["hierarchy_lvl2"] = ' ';
                    data[i]["hierarchy_lvl2"] = ' ';

                    // data[i]["_formatted"]["hierarchy_lvl3"] = ' ';
                    // data[i]["_formatted"]["hierarchy_lvl4"] = ' ';
                    // data[i]["_formatted"]["hierarchy_lvl5"] = ' ';
                    // data[i]["_formatted"]["hierarchy_lvl6"] = ' ';
                    // data[i]["_formatted"]["content"] = ' ';

                }
                // console.log(data);
                return data;
            },
        });




        // set anchor highlighting
        var last_anchor;        
        function highlight_anchor_element () {
            try {
                document.getElementById(decodeURI(last_anchor)).style.color = null;
            } catch {} 
            try {
                last_anchor = window.location.hash.substr(1);
                document.getElementById(decodeURI(last_anchor)).style.color = "aqua";
            } catch {}
        }
        window.onhashchange = highlight_anchor_element;
        highlight_anchor_element();





        // set searchbox hint
        document.getElementById('docs-searchbar-suggestion').placeholder='Ctrl + /';

        // let escape button to focus out from searchbox
        document.onkeydown = function(evt) {
            evt = evt || window.event;
            if (evt.keyCode == 27) {  // 27 is the code for escape
                document.getElementById("docs-searchbar-suggestion").blur(); 
            }
        };

    ]]></script>    


    </body>
  </html>
  </xsl:template>
</xsl:stylesheet>
