package com.marklogic.junit5.dhf;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.DatabaseClientFactory;
import com.marklogic.client.ext.helper.DatabaseClientProvider;
import com.marklogic.junit5.AbstractMarkLogicTest;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

/**
 * Extends AbstractSpringTest and uses DataHubTestConfig, which provides a sensible default configuration for connecting
 * to a DHF application. Also provides a runHarmonizeFlow convenience method.
 * <p>
 * You do not need to use this class - most of the interesting functionality is delegated to the TestFlowRunner class.
 * This class doesn't provide any additional support for making assertions, it's just focused on making it easy to
 * connect to your staging and test databases and run a harmonize flow.
 */
@ExtendWith(SpringExtension.class)

/**
 * DataHubTestConfig provides a sensible default configuration for testing DHF applications.
 */
@ContextConfiguration(classes = {DataHubTestConfig.class})
public abstract class AbstractDataHubTest extends AbstractMarkLogicTest {

  @Autowired
  protected DataHubTestConfig dataHubTestConfig;

  @Autowired
  protected DatabaseClientProvider databaseClientProvider;

  protected DatabaseClient stagingClient;

  @BeforeEach
  public void setupStagingClient() {
    stagingClient = DatabaseClientFactory.newClient(
      dataHubTestConfig.getHost(), dataHubTestConfig.getStagingPort(), dataHubTestConfig.getStagingDatabaseName(),
      new DatabaseClientFactory.DigestAuthContext(dataHubTestConfig.getUsername(), dataHubTestConfig.getPassword())
    );
  }

  @AfterEach
  public void releaseStagingClient() {
    if (stagingClient != null) {
      stagingClient.release();
    }
  }

  /**
   * The DatabaseClient returned by this method is intended to connect to the test database.
   *
   * @return
   */
  @Override
  protected DatabaseClient getDatabaseClient() {
    return databaseClientProvider.getDatabaseClient();
  }

  /**
   * Assumes digest auth - can override this via a subclass.
   *
   * @return
   */
  protected DatabaseClient newJobsDatabaseClient() {
    return DatabaseClientFactory.newClient(
      dataHubTestConfig.getHost(), dataHubTestConfig.getJobPort(),
      new DatabaseClientFactory.DigestAuthContext(dataHubTestConfig.getUsername(), dataHubTestConfig.getPassword())
    );
  }
}
