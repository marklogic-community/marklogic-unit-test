package com.marklogic.test.unit;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.DatabaseClientFactory;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.ArgumentsProvider;
import org.junit.jupiter.params.provider.ArgumentsSource;

import java.io.FileReader;
import java.util.Properties;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.fail;

/**
 * Example of running each test module as a separate JUnit test. Not a lot of code to reuse here, because the
 * important stuff is in static blocks.
 */
public class SampleParameterizedTest implements ArgumentsProvider {

  private static TestManager testManager;
  private static DatabaseClient databaseClient;

  @AfterAll
  public static void releaseDatabaseClient() {
    if (databaseClient != null) {
      databaseClient.release();
    }
  }

  @ParameterizedTest
  @ArgumentsSource(SampleParameterizedTest.class)
  public void test(TestModule testModule) {
    TestSuiteResult result = testManager.run(testModule);
    for (TestResult testResult : result.getTestResults()) {
      String failureXml = testResult.getFailureXml();
      if (failureXml != null) {
        fail(String.format("Test %s in suite %s failed, cause: %s", testResult.getName(), testModule.getSuite(), failureXml));
      }
    }
  }

  /**
   * This sets up the parameters for our test by getting a list of the test modules.
   * <p>
   * Also creates a DatabaseClient based on the values in gradle.properties. Typically, properties will be retrieved via
   * a more robust mechanism, like Spring's test framework support.
   *
   * @return
   * @throws Exception
   */
  @Override
  public Stream<? extends Arguments> provideArguments(ExtensionContext context) throws Exception {
    Properties props = new Properties();
    props.load(new FileReader("gradle.properties"));
    final String host = props.getProperty("mlHost");
    final int port = Integer.parseInt(props.getProperty("mlRestPort"));
    final String username = props.getProperty("mlUsername");
    final String password = props.getProperty("mlPassword");

    databaseClient = DatabaseClientFactory.newClient(host, port,
      new DatabaseClientFactory.DigestAuthContext(username, password));
    testManager = new TestManager(databaseClient);
    return Stream.of(testManager.list().toArray(new TestModule[]{})).map(Arguments::of);
  }
}

