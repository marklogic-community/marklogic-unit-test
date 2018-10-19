package com.marklogic.test.unit;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.DatabaseClientFactory;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

/**
 * Example of how all the test suites can be run by themselves, e.g. as part of a custom Gradle task.
 */
public class RunSuiteTest extends Assert {

  private DatabaseClient databaseClient;

  @Before
  public void setup() {
    databaseClient = DatabaseClientFactory.newClient("localhost", 8090,
      new DatabaseClientFactory.DigestAuthContext("admin", "admin"));
  }

  @After
  public void teardown() {
    databaseClient.release();
  }

  @Test
  public void test() {
    List<JUnitTestSuite> suites = new TestManager(databaseClient).runAllSuites();
    String report = new DefaultJUnitTestReporter().reportOnJUnitTestSuites(suites);
    System.out.println(report);
  }

  @Test
  public void runTestsInSuite() {
    List<JUnitTestSuite> suites =
      new TestManager(databaseClient).runAllSuites("assert-not-equal", true, true, false);
    String report = new DefaultJUnitTestReporter().reportOnJUnitTestSuites(suites);
    System.out.println(report);
  }
}
