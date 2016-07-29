#!/usr/bin/env bash

npm install -g bower

echo "TRAVIS BRANCH: $TRAVIS_BRANCH"

npm install
bower install

cd src/test-examples
bower install

cd ../core
bower install

cd ../admin
bower install

cd ../admin-booking
bower install

cd ../admin-dashboard
bower install

cd ../events
bower install

cd ../member
bower install

cd ../services
bower install

cd ../settings
bower install
