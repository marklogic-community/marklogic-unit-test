package com.marklogic.junit5.spring;

import com.marklogic.client.io.StringHandle;
import com.marklogic.junit5.MarkLogicNamespaceProvider;
import com.marklogic.junit5.NamespaceProvider;
import com.marklogic.junit5.XmlNode;
import org.jdom2.Namespace;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class XmlNodeTest extends AbstractSpringMarkLogicTest {

    private static final String TEST_URI = "/test/1.xml";

    private boolean useCustomNamespaceProvider = true;

    @Override
    protected NamespaceProvider getNamespaceProvider() {
        return useCustomNamespaceProvider ?
            new MarkLogicNamespaceProvider("m", "org:example") :
            super.getNamespaceProvider();
    }

    @BeforeEach
    void setup() {
        getDatabaseClient().newXMLDocumentManager().write(TEST_URI,
            new StringHandle("" +
                "<message xmlns='org:example'>" +
                "<color important='true'>red</color>" +
                "<color>blue</color>" +
                "<size>medium</size>" +
                "<parent><kid>hello</kid></parent>" +
                "</message>"));
    }

    @Test
    public void test() {
        XmlNode xml = readXmlDocument(TEST_URI);

        assertEquals(TEST_URI, xml.getUri());
        xml.assertElementValue("/m:message/m:size", "medium");
        assertEquals("medium", xml.getElementValue("/m:message/m:size"));
        assertEquals("true", xml.getAttributeValue("/m:message/m:color[. = 'red']", "important"));
        xml.assertElementExists("/m:message");
        xml.assertElementCount("/m:message/m:color", 2);

        xml.getXmlNode("/m:message/m:parent").assertElementExists("/m:parent/m:kid[. = 'hello']");

        assertEquals(2, xml.getXmlNodes("/m:message/m:color").size());

        XmlNode other = new XmlNode(xml);
        Assertions.assertNotNull(other.getInternalDoc());

        xml.prettyPrint();
        assertNotNull(xml.getPrettyXml());
    }

    @Test
    void readWithNamespaces() {
        useCustomNamespaceProvider = false;
        XmlNode xml = readXmlDocument(TEST_URI, Namespace.getNamespace("m", "org:example"));
        xml.assertElementValue("/m:message/m:size", "medium");
    }
}
