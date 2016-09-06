#!/usr/bin/env bash

npm install -g bower

npm install

gulp test-unit-bower-prepare
gulp test-unit-bower-install
