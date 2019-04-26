package org.example;

import com.marklogic.client.io.DocumentMetadataHandle;
import com.marklogic.client.io.StringHandle;
import com.marklogic.junit5.spring.AbstractSpringMarkLogicTest;
import org.junit.jupiter.api.Test;

public class PermissionsTest extends AbstractSpringMarkLogicTest {

	@Test
	public void test() {
		DocumentMetadataHandle metadata = new DocumentMetadataHandle();
		metadata.getPermissions().add("manage-user", DocumentMetadataHandle.Capability.READ);
		metadata.getPermissions().add("manage-admin", DocumentMetadataHandle.Capability.UPDATE);

		getDatabaseClient().newJSONDocumentManager().write(
			"/test/1.json", metadata, new StringHandle("{\"message\":\"Hello world\"}"));

		readDocumentPermissions("/test/1.json")
			.assertReadPermissionExists("manage-user")
			.assertUpdatePermissionExists("manage-admin");
	}
}
