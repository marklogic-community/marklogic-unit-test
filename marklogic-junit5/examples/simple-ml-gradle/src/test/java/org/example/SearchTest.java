package org.example;

import com.fasterxml.jackson.databind.JsonNode;
import com.marklogic.client.io.SearchHandle;
import com.marklogic.client.io.StringHandle;
import com.marklogic.client.query.QueryManager;
import com.marklogic.junit5.XmlNode;
import com.marklogic.junit5.spring.AbstractSpringMarkLogicTest;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class SearchTest extends AbstractSpringMarkLogicTest {

	@Test
	public void twoDocuments() {
		getDatabaseClient().newXMLDocumentManager().write("/test/1.xml", new StringHandle("<message>Hello world</message>"));
		getDatabaseClient().newJSONDocumentManager().write("/test/2.json", new StringHandle("{\"message\":\"Hello world\"}"));

		QueryManager queryManager = getDatabaseClient().newQueryManager();
		SearchHandle searchHandle = queryManager.search(queryManager.newStringDefinition(), new SearchHandle());
		assertEquals(2, searchHandle.getTotalResults());

		XmlNode xml = readXmlDocument("/test/1.xml");
		xml.assertElementValue("/message", "Hello world");

		JsonNode json = readJsonDocument("/test/2.json");
		assertEquals("Hello world", json.get("message").asText());
	}
}
