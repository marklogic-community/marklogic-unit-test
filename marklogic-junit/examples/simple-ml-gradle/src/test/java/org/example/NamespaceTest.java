package org.example;

import com.marklogic.client.io.StringHandle;
import com.marklogic.junit5.MarkLogicNamespaceProvider;
import com.marklogic.junit5.NamespaceProvider;
import com.marklogic.junit5.XmlNode;
import com.marklogic.junit5.spring.AbstractSpringMarkLogicTest;
import org.junit.jupiter.api.Test;

public class NamespaceTest extends AbstractSpringMarkLogicTest {

	@Override
	protected NamespaceProvider getNamespaceProvider() {
		return new MarkLogicNamespaceProvider("m", "org:example");
	}

	@Test
	public void test() {
		getDatabaseClient().newXMLDocumentManager().write("/test/1.xml", new StringHandle("<message xmlns='org:example'>Hello world</message>"));

		XmlNode xml = readXmlDocument("/test/1.xml");

		xml.assertElementValue(
			"Verifies that the custom namespace registered in getNamespaceProvider can then be used in assertions",
			"/m:message", "Hello world"
		);
	}
}
