package com.marklogic.test.unit;

import org.junit.Assert;
import org.junit.Test;

/**
 * This is included as a demonstration of MarkLogic unit tests being included with non-MarkLogic unit tests in the
 * same suite.
 */
public class NonMarkLogicUnitTest extends Assert {

	@Test
	public void thisShouldSucceed() {
		assertEquals("1", "1");
	}

}