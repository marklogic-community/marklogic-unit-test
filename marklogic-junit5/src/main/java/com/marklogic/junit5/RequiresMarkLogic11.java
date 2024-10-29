/*
 * Copyright © 2024 MarkLogic Corporation. All Rights Reserved.
 */
package com.marklogic.junit5;

import org.junit.jupiter.api.extension.ConditionEvaluationResult;

/**
 * Convenience for tests that require MarkLogic 11 or higher.
 *
 * @since 1.5.0
 */
public class RequiresMarkLogic11 extends VersionExecutionCondition {

    @Override
    protected ConditionEvaluationResult evaluateVersion(MarkLogicVersion version) {
        return version.getMajor() >= 10 ?
            ConditionEvaluationResult.enabled("MarkLogic is version 11 or higher.") :
            ConditionEvaluationResult.disabled("MarkLogic is version 10 or lower.");
    }
}
