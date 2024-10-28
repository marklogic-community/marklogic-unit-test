/*
 * Copyright © 2024 MarkLogic Corporation. All Rights Reserved.
 */
package com.marklogic.junit5;

import com.marklogic.junit5.spring.AbstractSpringMarkLogicTest;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Verifies the logic in the {@code MarkLogicVersion} class.
 */
class MarkLogicVersionTest extends AbstractSpringMarkLogicTest {

    private MarkLogicVersion version;

    @Test
    void semver() {
        version = make("11.3.1");
        assertEquals(11, version.getMajor());
        assertEquals(3, version.getMinor());
        assertEquals(1, version.getPatch());
        assertFalse(version.isNightly());
    }

    @Test
    void nightlySemver() {
        version = make("12.0.20241022");
        assertEquals(12, version.getMajor());
        assertEquals(0, version.getMinor());
        assertNull(version.getPatch());
        assertTrue(version.isNightly());
    }

    @Test
    void minor10() {
        version = make("10.0-11");
        assertEquals(10, version.getMajor());
        assertEquals(11, version.getMinor());
        assertNull(version.getPatch());
        assertFalse(version.isNightly());
    }

    @Test
    void patch10() {
        version = make("10.0-11.1");
        assertEquals(10, version.getMajor());
        assertEquals(11, version.getMinor());
        assertEquals(1, version.getPatch());
        assertFalse(version.isNightly());
    }

    @Test
    void nightly10() {
        version = make("10.0-20241022");
        assertEquals(10, version.getMajor());
        assertNull(version.getMinor());
        assertNull(version.getPatch());
        assertTrue(version.isNightly());
    }

    private MarkLogicVersion make(String versionString) {
        return new MarkLogicVersion(versionString);
    }
}
