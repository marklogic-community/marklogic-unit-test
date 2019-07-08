package com.marklogic.junit5.spring;

import com.fasterxml.jackson.databind.JsonNode;
import com.marklogic.client.io.StringHandle;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class JsonNodeTest extends AbstractSpringMarkLogicTest {

	@Test
	public void test() {
		getDatabaseClient().newJSONDocumentManager().write(
			"/test/1.json", new StringHandle("{\"message\":\"Hello world\"}"));

		JsonNode json = readJsonDocument("/test/1.json");
		assertEquals("Hello world", json.get("message").asText());
	}
}
