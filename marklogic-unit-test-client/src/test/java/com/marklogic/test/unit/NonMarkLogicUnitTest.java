package com.marklogic.test.unit;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * This is included as a demonstration of MarkLogic unit tests being included with non-MarkLogic unit tests in the
 * same suite.
 */
public class NonMarkLogicUnitTest {

  @Test
  public void thisShouldSucceed() {
    assertEquals("1", "1");
  }

}
