<?xml version="1.0" encoding="UTF-8"?>
<!--
     Author: Stéphane Sire <s.sire@opppidoc.fr>

     Copier dans le répertoire du cours et ajuster les balises suivantes :
     - meta
     - title

     April 2014 - (c) Copyright 2014 Oppidoc SARL. All Rights Reserved.
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="yes" />

  <xsl:preserve-space elements="Source"/>

  <xsl:param name="cours.css">resources/cours.css</xsl:param>
  <xsl:param name="slidy.base">resources/Slidy2/</xsl:param>
  <xsl:param name="ace.base">resources/ace-builds-master/</xsl:param>
  <xsl:param name="icons.base">icons/</xsl:param>
  <xsl:param name="timestamp"></xsl:param>

  <xsl:template match="SlideShow">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="copyright" content="Tutorial Web application development with XML &#169; S. Sire - Oppidoc pour DocEng 2015{$timestamp}" />

        <title>Tutorial Web application development with XML</title>
        <link rel="stylesheet" type="text/css" media="screen, projection, print" href="{$slidy.base}styles/slidy.css" />
        <link rel="stylesheet" type="text/css" media="screen, projection, print" href="{$slidy.base}styles/w3c-blue.css" />
        <link rel="stylesheet" type="text/css" media="screen, projection, print" href="{$cours.css}" />
        <script src="{$slidy.base}scripts/slidy.js"  charset="utf-8" type="text/javascript">//</script>
        <script src="resources/jquery/js/jquery-1.7.1.min.js">//</script>
        <script src="{$ace.base}src-noconflict/ace.js" type="text/javascript" charset="utf-8">//</script>
        <script>
          (function () {
            function doScaleText ( e, incr ) {
              var mask = $(e.target).closest('.mask'),
                  pre = mask.find('pre'),
                  size, m, nsize;
              if (pre.length === 0) {
                pre = mask.find('div.pre');
              }
              size = pre.css('font-size') || '20';
              m = size.match(/(\d+)/);
              nsize = (m) ? parseInt(m) : 20;
              pre.css('font-size', (nsize + incr) + 'px');
            };
            function doColorize ( e ) {
              var root = $(e.target).closest('.mask'),
                  pre = root.find('pre'),
                  lines = pre.contents(),
                  size = pre.css('font-size') || '20px',
                  t = root.append('&lt;div class="pre"/>').find('div.pre').get(0),
                  language = pre.attr('data-language');
              lines.each(function(i,e){t.appendChild(e)});
              pre.remove();
              $(t).css('font-size', size);
              editor = ace.edit(t);
              editor.setOptions({
                    readOnly: true,
                    highlightActiveLine: false,
                    highlightGutterLine: false,
                    maxLines: Infinity
              });
              editor.setTheme("ace/theme/textmate");
              editor.getSession().setMode("ace/mode/" + language);
              // $(e.target).css('z-index', 0);
              $(e.target).hide();
            };
            function init() {
              $('div.commands > button[data-command="ace"]').click( doColorize );
              $('div.commands > button[data-command="text-in"]').click( function (e) { doScaleText(e,2) } );
              $('div.commands button[data-command="text-out"]').click( function (e) { doScaleText(e,-2) } );
            };
            jQuery(init);
          }());
      </script>
      </head>
      <body>
        <div class="background">
        </div>
        <xsl:apply-templates select="Slides/Slide"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Slide">
    <div class="slide">
      <h1><xsl:value-of select="Title"/></h1>
      <xsl:apply-templates select="Region"/>
    </div>
  </xsl:template>

  <xsl:template match="Region">
    <div class="region">
      <xsl:apply-templates select="Meta" mode="region"/>
      <xsl:apply-templates select="Block"/>
    </div>
  </xsl:template>

  <xsl:template match="Meta" mode="region">
  </xsl:template>

  <xsl:template match="Meta[*]" mode="region">
    <xsl:variable name="styles" as="xs:string*">
        <xsl:apply-templates select="*"/>
    </xsl:variable>
    <xsl:attribute name="style">
      <xsl:value-of select="string-join($styles,';')"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="Block">
    <ul class="block {@Numbering}">
      <xsl:apply-templates select="Item"/>
    </ul>
  </xsl:template>

  <xsl:template match="Item">
    <li>
      <xsl:apply-templates select="*"/>
    </li>
  </xsl:template>

  <xsl:template match="Title">
    <h2>
      <xsl:value-of select="."/>
    </h2>
  </xsl:template>

  <xsl:template match="Para">
    <p>
      <xsl:apply-templates select="Fragment | Link"/>
    </p>
  </xsl:template>

  <xsl:template match="Code">
    <div class="mask">
       <div class="commands">
          <button data-command="text-in">T&#9650;</button>
          <button data-command="text-out">T&#9660;</button>
       </div>
       <pre>
          <xsl:apply-templates select="Meta" mode="code"/>
          <xsl:value-of select="Source"/>
        </pre>
    </div>
  </xsl:template>

  <xsl:template match="Code[Meta/Language]">
    <div class="mask">
       <div class="commands">
          <button data-command="ace">Ace</button>
          <button data-command="text-in">T&#9650;</button>
          <button data-command="text-out">T&#9660;</button>
       </div>
       <pre>
         <xsl:apply-templates select="Meta" mode="code"/>
         <xsl:value-of select="Source"/>
       </pre>
    </div>
  </xsl:template>

  <xsl:template match="Meta" mode="code">
    <xsl:apply-templates select="Language | Size"/>
  </xsl:template>

  <xsl:template match="Language">
    <xsl:attribute name="data-language"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>

  <xsl:template match="Size">
    <xsl:attribute name="style">font-size:<xsl:value-of select="."/></xsl:attribute>
  </xsl:template>

  <xsl:template match="SubList">
    <ul class="sublist">
      <xsl:apply-templates select="Item" mode="sublist"/>
    </ul>
  </xsl:template>

  <xsl:template match="Item" mode="sublist">
    <li>
      <xsl:apply-templates select="*"/>
    </li>
  </xsl:template>

  <xsl:template match="Illustration">
    <div class="illustration">
      <xsl:apply-templates select="Meta/Alignment" mode="standalone"/>
      <xsl:apply-templates select="Meta/Link" mode="illustration"/>
      <img src="{@Source}">
        <xsl:apply-templates select="Meta/Width" mode="standalone"/>
      </img>
      <xsl:apply-templates select="Legend"/>
    </div>
  </xsl:template>

  <xsl:template match="Link" mode="illustration">
    <a class="e-link" href="{.}" target="_blank"><img src="{$icons.base}external_link.png"/></a>
  </xsl:template>

  <xsl:template match="Legend">
    <p class="legend"><xsl:apply-templates select="Fragment | Link"/></p>
  </xsl:template>

  <!-- Rich Text Fragments -->

  <xsl:template match="Fragment[@FragmentKind = 'important']">
    <strong><xsl:value-of select="."/></strong>
  </xsl:template>

  <xsl:template match="Fragment[@FragmentKind = 'emphasize']">
    <em><xsl:value-of select="."/></em>
  </xsl:template>

  <xsl:template match="Fragment[@FragmentKind = 'verbatim']">
    <tt><xsl:value-of select="."/></tt>
  </xsl:template>

  <!-- External links open in a new window -->
  <xsl:template match="Link">
    <xsl:choose>
      <xsl:when test="starts-with(LinkRef, 'http:') or starts-with(LinkRef, 'https:')">
        <a href="{LinkRef}" target="_blank"><xsl:value-of select="LinkText"/></a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{LinkRef}" target="_blank"><xsl:value-of select="LinkText"/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  Shared CSS key:value string constructors -->

  <xsl:template match="Clear">
    <xsl:value-of select="concat('clear:',.)"/>
  </xsl:template>

  <xsl:template match="Float">
    <xsl:value-of select="concat('float:',.)"/>
  </xsl:template>

  <xsl:template match="Width">
    <xsl:value-of select="concat('width:',.,'%')"/>
  </xsl:template>

  <xsl:template match="Width" mode="standalone">
    <xsl:attribute name="style">
      <xsl:apply-templates select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="LeftSpacing">
    <xsl:value-of select="concat('padding-left:',.)"/>
  </xsl:template>

  <xsl:template match="TopSpacing">
    <xsl:value-of select="concat('margin-top:',.)"/>
  </xsl:template>

  <xsl:template match="Alignment" mode="standalone">
    <xsl:attribute name="style">
      <xsl:value-of select="concat('text-align:',.)"/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
