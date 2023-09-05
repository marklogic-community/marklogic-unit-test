package com.marklogic.test.unit;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.DatabaseClientFactory;

public class ClientUtil {

    private static DatabaseClient client;

    /**
     * Simple utility for creating a client for this project's test application. Using this until we get a real
     * test-app in place and can then use spring-test for loading properties from gradle.properties and
     * gradle-local.properties.
     *
     * @return
     */
    public static DatabaseClient getClient() {
        if (client == null) {
            client = DatabaseClientFactory.newClient("localhost", 8008,
                new DatabaseClientFactory.DigestAuthContext("admin", "admin"));
        }
        return client;
    }
}
