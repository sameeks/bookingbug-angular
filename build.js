'use strict';

var bbGulp = require('./bb-gulp.js');
var mergeStream = require('merge-stream');
var _ = require('underscore');
var fs = require('fs');
var path = require('path');

var srcpath = './src'

function getModules(srcpath) {
  return fs.readdirSync(srcpath).filter(function(file) {
    return fs.statSync(path.resolve(path.join(srcpath, file))).isDirectory();
  });
}

function buildModule(streams, module) {
  try {
    fs.statSync(path.join(srcpath, module, 'javascripts'))
    streams.add(bbGulp.javascripts(module));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'i18n'))
    streams.add(bbGulp.i18n(module));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'stylesheets'))
    streams.add(bbGulp.stylesheets(module));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'images'))
    streams.add(bbGulp.images(module));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'fonts'))
    streams.add(bbGulp.fonts(module));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'templates'))
    streams.add(bbGulp.templates(module));
  } catch (e) {
  }
  streams.add(bbGulp.bower(module));
  return streams;
}

function run() {
  var streams = mergeStream();
  var modules = getModules(srcpath);
  _.each(modules, function(module) {
    streams = buildModule(streams, module);
  });
  return streams;
}

module.exports = run;
