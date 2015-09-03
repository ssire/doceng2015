java -cp /usr/local/share/SaxonHE9-6-0-7J/saxon9he.jar net.sf.saxon.Transform -s:$1.xml -xsl:cours.xsl -o:$1.xhtml timestamp="`date '+ (generated %d/%m/%Y)'`"
