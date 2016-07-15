#!/usr/bin/env bash

echo "TRAVIS BRANCH: $TRAVIS_BRANCH"

gulp test:unit-ci # !!! generates lcov reports per module - can be used with Climate

if [ "$TRAVIS_BRANCH" = 'master' ] && [ "$TRAVIS_BRANCH" = 'dev' ] ; then
  gulp test:e2e
fi

if [ "$TRAVIS_BRANCH" = 'master' ] && [ "$TRAVIS_PULL_REQUEST" = 'false' ] ; then
  gulp buildWidget
fi
