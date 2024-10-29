/*
 * Copyright © 2024 MarkLogic Corporation. All Rights Reserved.
 */
package com.marklogic.junit5;

import org.junit.jupiter.api.extension.ConditionEvaluationResult;
import org.junit.jupiter.api.extension.ExecutionCondition;
import org.junit.jupiter.api.extension.ExtensionContext;

import java.util.Optional;

/**
 * Simplifies implementing an execution condition based on the MarkLogic version. Can only be used on classes that
 * implement the {@code HasMarkLogicVersion} interface.
 *
 * @since 1.5.0
 */
public abstract class VersionExecutionCondition implements ExecutionCondition {

    private static MarkLogicVersion markLogicVersion;

    @Override
    public ConditionEvaluationResult evaluateExecutionCondition(ExtensionContext context) {
        if (markLogicVersion == null) {
            Optional<Object> testInstance = context.getTestInstance();
            if (!testInstance.isPresent()) {
                throw new RuntimeException(getClass() + " can only be used when a test instance is present.");
            }
            if (!(testInstance.get() instanceof MarkLogicVersionSupplier)) {
                throw new RuntimeException(testInstance.getClass() + " must implement " + MarkLogicVersionSupplier.class.getName());
            }
            markLogicVersion = ((MarkLogicVersionSupplier) context.getTestInstance().get()).getMarkLogicVersion();
        }
        return evaluateVersion(markLogicVersion);
    }

    protected abstract ConditionEvaluationResult evaluateVersion(MarkLogicVersion version);
}
