package com.marklogic.junit5.dhf;

import com.marklogic.client.ext.DatabaseClientConfig;
import com.marklogic.client.ext.helper.DatabaseClientProvider;
import com.marklogic.client.ext.spring.SimpleDatabaseClientProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;

/**
 * This Spring configuration class captures a typical setup for a Data Hub Framework project:
 * <ol>
 * <li>It reads properties from gradle.properties and gradle-local.properties</li>
 * <li>It assumes digest authentication with a username and password</li>
 * </ol>
 */
@Configuration
@PropertySource(value = {"file:gradle.properties", "file:gradle-local.properties"}, ignoreResourceNotFound = true)
public class DataHubTestConfig {

  @Value("${mlHost:localhost}")
  private String host;

  @Value("${mlTestUsername}")
  private String username;

  @Value("${mlTestPassword}")
  private String password;

  @Value("${mlTestPort:0}")
  private Integer testPort;

  @Value("${mlTestDbName}")
  private String testDatabaseName;

  @Value("${mlStagingPort}")
  private Integer stagingPort;

  @Value("${mlStagingDbName}")
  private String stagingDatabaseName;

  @Value("${mlJobPort}")
  private Integer jobPort;

  /**
   * Has to be static so that Spring instantiates it first.
   */
  @Bean
  public static PropertySourcesPlaceholderConfigurer propertyConfigurer() {
    PropertySourcesPlaceholderConfigurer c = new PropertySourcesPlaceholderConfigurer();
    c.setIgnoreResourceNotFound(true);
    return c;
  }

  /**
   * Defines the configuration details for constructing a DatabaseClient.
   *
   * @return
   */
  @Bean
  public DatabaseClientConfig databaseClientConfig() {
    DatabaseClientConfig config = new DatabaseClientConfig(host, testPort, username, password);
    // DHF requires that the database name be set on the DatabaseClient
    config.setDatabase(testDatabaseName);
    return config;
  }

  /**
   * marklogic-junit5 depends on one of these for obtaining a DatabaseClient.
   *
   * @return
   */
  @Bean
  public DatabaseClientProvider databaseClientProvider() {
    return new SimpleDatabaseClientProvider(databaseClientConfig());
  }

  public String getUsername() {
    return username;
  }

  public String getPassword() {
    return password;
  }

  public String getHost() {
    return host;
  }

  public Integer getTestPort() {
    return testPort;
  }

  public String getTestDatabaseName() {
    return testDatabaseName;
  }

  public String getStagingDatabaseName() {
    return stagingDatabaseName;
  }

  public Integer getStagingPort() {
    return stagingPort;
  }

  public Integer getJobPort() {
    return jobPort;
  }
}
