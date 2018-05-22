<!--
 Copyright 2012-2018 MarkLogic Corporation

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 The use of the Apache License does not indicate that this project is
 affiliated with the Apache Software Foundation.

 Code adapted from xray
 https://github.com/robwhitby/xray/tree/v2.1

 Modifications copyright (c) 2018 MarkLogic Corporation
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:error="http://marklogic.com/xdmp/error"
                xmlns:prof="http://marklogic.com/xdmp/profile"
                xmlns:test="http://marklogic.com/roxy/test"
                xmlns:xdmp="http://marklogic.com/xdmp"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="error prof test xdmp xs">

  <xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes" />

  <xsl:include href="../common.xsl"/>

  <xsl:template match="test:module | test:suite">
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <section>
          <details open="true">
            <summary>
              <xsl:value-of select="concat('Code Coverage for ',
                                            @uri,
                                            ':',
                                            test:coverage-percent(xs:int(@covered), xs:int(@wanted)),
                                            '%')"/>
            </summary>
            <ol class="coverage-source">
              <xsl:apply-templates/>
            </ol>
          </details>
        </section>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="test:line">
   <li class="{@state}">
     <pre><xsl:value-of select="."/></pre>
   </li>
  </xsl:template>

</xsl:stylesheet>
