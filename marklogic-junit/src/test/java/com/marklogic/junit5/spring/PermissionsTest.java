package com.marklogic.junit5.spring;

import com.marklogic.client.io.DocumentMetadataHandle;
import com.marklogic.client.io.StringHandle;
import com.marklogic.junit5.PermissionsTester;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNotNull;

public class PermissionsTest extends AbstractSpringMarkLogicTest {

	@Test
	public void test() {
		DocumentMetadataHandle metadata = new DocumentMetadataHandle();
		metadata.getPermissions().add("manage-user",
			DocumentMetadataHandle.Capability.READ, DocumentMetadataHandle.Capability.EXECUTE
		);
		metadata.getPermissions().add("manage-admin",
			DocumentMetadataHandle.Capability.INSERT, DocumentMetadataHandle.Capability.NODE_UPDATE,
			DocumentMetadataHandle.Capability.UPDATE
		);

		getDatabaseClient().newJSONDocumentManager().write(
			"/test/1.json", metadata, new StringHandle("{\"message\":\"Hello world\"}"));

		PermissionsTester tester = readDocumentPermissions("/test/1.json")
			.assertReadPermissionExists("manage-user")
			.assertExecutePermissionExists("manage-user")
			.assertInsertPermissionExists("manage-admin")
			.assertNodeUpdatePermissionExists("manage-admin")
			.assertUpdatePermissionExists("manage-admin");

		assertNotNull(tester.getDocumentPermissions());
	}
}
