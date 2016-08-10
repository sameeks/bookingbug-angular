#!/usr/bin/env bash

npm install -g bower

npm install

gulp test-unit:dependencies
cd test/unit
bower install
