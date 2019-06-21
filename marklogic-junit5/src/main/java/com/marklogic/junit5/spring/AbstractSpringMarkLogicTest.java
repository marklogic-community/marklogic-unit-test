package com.marklogic.junit5.spring;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.ext.helper.DatabaseClientProvider;
import com.marklogic.junit5.AbstractMarkLogicTest;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

/**
 * Extends JUnit5 with Spring's support for tests.
 */
@ExtendWith(SpringExtension.class)

/**
 * SimpleTestConfig provides a sensible default configuration for testing applications that use ml-gradle for
 * deployment. You can override this via your own ContextConfiguration in a subclass.
 */
@ContextConfiguration(classes = {SimpleTestConfig.class})

/**
 * Provides basic support for JUnit tests that use Spring's support for tests. A DatabaseClientProvider is expected to
 * be in the Spring container so that this class can implement its parent class's getDatabaseClient method.
 */
public abstract class AbstractSpringMarkLogicTest extends AbstractMarkLogicTest {

	@Autowired
	protected DatabaseClientProvider databaseClientProvider;

	@Override
	protected DatabaseClient getDatabaseClient() {
		return databaseClientProvider.getDatabaseClient();
	}

}
