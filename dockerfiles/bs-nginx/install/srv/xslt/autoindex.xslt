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
    <script type="text/javascript" src="/scripts/searchbar.js"></script>


    </body>
  </html>
  </xsl:template>
</xsl:stylesheet>
