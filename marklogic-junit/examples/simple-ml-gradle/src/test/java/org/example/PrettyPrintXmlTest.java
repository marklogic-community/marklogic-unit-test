package org.example;

import com.marklogic.client.io.StringHandle;
import com.marklogic.junit5.spring.AbstractSpringMarkLogicTest;
import org.junit.jupiter.api.Test;

public class PrettyPrintXmlTest extends AbstractSpringMarkLogicTest {

	/**
	 * Example of using the prettyPrint method on an XmlNode to see the contents of an XML document.
	 */
	@Test
	public void test() {
		getDatabaseClient().newXMLDocumentManager().write("/test/1.xml",
			new StringHandle("<parent><kid>one</kid><kid>two</kid></parent>")
		);

		readXmlDocument("/test/1.xml").prettyPrint();
	}
}
