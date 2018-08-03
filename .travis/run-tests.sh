#!/bin/bash

if [ "${TRAVIS_SECURE_ENV_VARS}" = "true" ] ; then
  cd ml-unit-test-client
  ../gradlew build test
fi
