package com.marklogic.junit5.spring;

import com.marklogic.client.io.StringHandle;
import com.marklogic.junit5.MarkLogicNamespaceProvider;
import com.marklogic.junit5.NamespaceProvider;
import com.marklogic.junit5.XmlNode;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class XmlNodeTest extends AbstractSpringMarkLogicTest {

	@Override
	protected NamespaceProvider getNamespaceProvider() {
		return new MarkLogicNamespaceProvider("m", "org:example");
	}

	@Test
	public void test() {
		getDatabaseClient().newXMLDocumentManager().write("/test/1.xml",
			new StringHandle("" +
				"<message xmlns='org:example'>" +
				"<color important='true'>red</color>" +
				"<color>blue</color>" +
				"<size>medium</size>" +
				"<parent><kid>hello</kid></parent>" +
				"</message>"));

		XmlNode xml = readXmlDocument("/test/1.xml");

		assertEquals("/test/1.xml", xml.getUri());
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
}
