/*
 * Copyright © 2024 MarkLogic Corporation. All Rights Reserved.
 */
package com.marklogic.junit5;

import com.marklogic.client.DatabaseClient;

/**
 * Parses a MarkLogic version string - i.e. from xdmp.version() - into its major, minor, and patch values.
 */
public class MarkLogicVersion {

    // For semver releases, which started with MarkLogic 11.
    private final static String SEMVER_PATTERN = "^[0-9]+\\.[0-9]+\\.[0-9]+";
    private final static String NIGHTLY_SEMVER_PATTERN = "^[0-9]+\\.[0-9]+\\.[0-9]{8}";

    // For non-semver releases.
    private final static String MAJOR_WITH_MINOR_PATTERN = "^.*-(.+)$";

    private final static String VERSION_WITH_PATCH_PATTERN = "^.*-(.+)\\..*";
    private final static String NIGHTLY_BUILD_PATTERN = "[^-]+-(\\d{4})(\\d{2})(\\d{2})";

    private final int major;
    private final Integer minor;
    private final Integer patch;
    private final boolean nightly;
    
    public static MarkLogicVersion getVersion(DatabaseClient client) {
        String version = client.newServerEval().javascript("xdmp.version()").evalAs(String.class);
        return new MarkLogicVersion(version);
    }

    public MarkLogicVersion(String version) {
        if (version.matches(NIGHTLY_SEMVER_PATTERN)) {
            String[] tokens = version.split("\\.");
            this.major = Integer.parseInt(tokens[0]);
            this.minor = Integer.parseInt(tokens[1]);
            this.patch = null;
            this.nightly = true;
        } else if (version.matches(SEMVER_PATTERN)) {
            String[] tokens = version.split("\\.");
            this.major = Integer.parseInt(tokens[0]);
            this.minor = Integer.parseInt(tokens[1]);
            this.patch = Integer.parseInt(tokens[2]);
            this.nightly = false;
        } else {
            this.major = Integer.parseInt(version.replaceAll("([^.]+)\\..*", "$1"));
            if (version.matches(NIGHTLY_BUILD_PATTERN)) {
                this.minor = null;
                this.patch = null;
                this.nightly = true;
            } else {
                this.nightly = false;
                if (version.matches(MAJOR_WITH_MINOR_PATTERN)) {
                    if (version.matches(VERSION_WITH_PATCH_PATTERN)) {
                        this.minor = Integer.parseInt(version.replaceAll(VERSION_WITH_PATCH_PATTERN, "$1"));
                        this.patch = Integer.parseInt(version.replaceAll("^.*-(.+)\\.(.*)", "$2"));
                    } else {
                        this.minor = Integer.parseInt(version.replaceAll(MAJOR_WITH_MINOR_PATTERN, "$1"));
                        this.patch = null;
                    }
                } else {
                    this.minor = null;
                    this.patch = null;
                }
            }
        }
    }

    public int getMajor() {
        return major;
    }

    public Integer getMinor() {
        return minor;
    }

    public Integer getPatch() {
        return patch;
    }

    public boolean isNightly() {
        return nightly;
    }
}
