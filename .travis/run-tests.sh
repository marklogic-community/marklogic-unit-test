#!/bin/bash

if [ "${TRAVIS_SECURE_ENV_VARS}" = "true" ] ; then
  cd marklogic-unit-test-client
  ../gradlew build test
fi
