#!/usr/bin/env bash

npm install -g bower

npm install

gulp test-unit:bower-prepare
cd test/unit
bower install
