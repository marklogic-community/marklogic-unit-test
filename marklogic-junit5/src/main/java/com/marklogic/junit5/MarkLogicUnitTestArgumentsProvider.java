package com.marklogic.junit5;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.ext.helper.DatabaseClientProvider;
import com.marklogic.client.ext.helper.LoggingObject;
import com.marklogic.test.unit.TestManager;
import com.marklogic.test.unit.TestModule;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.ArgumentsProvider;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;
import java.util.stream.Stream;

/**
 * JUnit 5 ArgumentsProvider that uses a DatabaseClient to retrieve the list of modules provided by the
 * marklogic-unit-test REST endpoint. If any test modules are found, a Stream of TestModule instances is returned, one
 * for each marklogic-unit-test test.
 */
public class MarkLogicUnitTestArgumentsProvider extends LoggingObject implements ArgumentsProvider {

	@Override
	public Stream<? extends Arguments> provideArguments(ExtensionContext context) {
		ApplicationContext applicationContext = SpringExtension.getApplicationContext(context);
		DatabaseClientProvider databaseClientProvider = applicationContext.getBean(DatabaseClientProvider.class);
    final DatabaseClient client = databaseClientProvider.getDatabaseClient();
		TestManager testManager = new TestManager(client);
		try {
			List<TestModule> testModules = testManager.list();
			return Stream.of(testModules.toArray(new TestModule[]{})).map(Arguments::of);
		} catch (Exception ex) {
			logger.error("Could not obtain a list of marklogic-unit-test modules; " +
				"please verify that the ml-unit-test library has been properly loaded and that /v1/resources/marklogic-unit-test is accessible", ex);
			return Stream.of();
		}
	}
}
