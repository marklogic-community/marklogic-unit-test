package com.marklogic.junit5;

import com.marklogic.client.io.DocumentMetadataHandle;
import org.junit.jupiter.api.Assertions;

import java.util.Set;

/**
 * Convenience class for making assertions on the permissions on a document.
 */
public class PermissionsTester {

	private DocumentMetadataHandle.DocumentPermissions documentPermissions;

	public PermissionsTester(DocumentMetadataHandle.DocumentPermissions documentPermissions) {
		this.documentPermissions = documentPermissions;
	}

	public PermissionsTester assertExecutePermissionExists(String role) {
		return assertExecutePermissionExists(null, role);
	}

	public PermissionsTester assertExecutePermissionExists(String message, String role) {
		return assertCapabilityExists(message, role, DocumentMetadataHandle.Capability.EXECUTE);
	}

	public PermissionsTester assertInsertPermissionExists(String role) {
		return assertInsertPermissionExists(null, role);
	}

	public PermissionsTester assertInsertPermissionExists(String message, String role) {
		return assertCapabilityExists(message, role, DocumentMetadataHandle.Capability.INSERT);
	}

	public PermissionsTester assertNodeUpdatePermissionExists(String role) {
		return assertNodeUpdatePermissionExists(null, role);
	}

	public PermissionsTester assertNodeUpdatePermissionExists(String message, String role) {
		return assertCapabilityExists(message, role, DocumentMetadataHandle.Capability.NODE_UPDATE);
	}

	public PermissionsTester assertReadPermissionExists(String role) {
		return assertReadPermissionExists(null, role);
	}

	public PermissionsTester assertReadPermissionExists(String message, String role) {
		return assertCapabilityExists(message, role, DocumentMetadataHandle.Capability.READ);
	}

	public PermissionsTester assertUpdatePermissionExists(String role) {
		return assertUpdatePermissionExists(null, role);
	}

	public PermissionsTester assertUpdatePermissionExists(String message, String role) {
		return assertCapabilityExists(message, role, DocumentMetadataHandle.Capability.UPDATE);
	}

	private PermissionsTester assertCapabilityExists(String message, String role, DocumentMetadataHandle.Capability capability) {
		Set<DocumentMetadataHandle.Capability> capabilities = this.documentPermissions.get(role);
		Assertions.assertTrue(capabilities != null && capabilities.contains(capability), message);
		return this;
	}

	public DocumentMetadataHandle.DocumentPermissions getDocumentPermissions() {
		return documentPermissions;
	}
}
