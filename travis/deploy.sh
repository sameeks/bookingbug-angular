#!/usr/bin/env bash

echo "TRAVIS BRANCH: $TRAVIS_BRANCH"
echo "TRAVIS TAG: $TRAVIS_TAG"

gulp deploy
