<!--
 Copyright 2012-2019 MarkLogic Corporation

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

 Modifications copyright (c) 2018-2019 MarkLogic Corporation
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:test="http://marklogic.com/test"
                xmlns:xdmp="http://marklogic.com/xdmp"
                xmlns:error="http://marklogic.com/xdmp/error"
                xmlns:prof="http://marklogic.com/xdmp/profile"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="error prof test xdmp xs">

  <xsl:template name="html-head">
    <head>
      <title>marklogic-unit-test</title>
      <link rel="stylesheet" type="text/css" href="css/coverage.css" />
    </head>
  </xsl:template>

  <xsl:function name="test:coverage-percent" as="xs:int">
    <xsl:param name="covered" as="xs:int"/>
    <xsl:param name="wanted" as="xs:int"/>
    <xsl:value-of select="if ($wanted ne 0) then min((100, round(100 * $covered div $wanted))) else 0"/>
  </xsl:function>

</xsl:stylesheet>
