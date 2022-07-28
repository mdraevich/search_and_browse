<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" />

<xsl:template match="/">
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

  <html>
    <head>
      <title>Browse | Search</title>
        <link rel="icon" type="image/x-icon" href="/favicon.ico"/>

        <!-- meilisearch searhbox css -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/docs-searchbar.js@2.1.0/dist/cdn/docs-searchbar.min.css"/>
        
        <!-- icons loaded -->
        <script src="https://kit.fontawesome.com/55eb9c16a8.js"></script>
        

        <script type="text/javascript" src="/scripts/content_load_event.js"></script>
        <link rel="stylesheet" href="/css/main.css"/>

    </head>


    <body>
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
