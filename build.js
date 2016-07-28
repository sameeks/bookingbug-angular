'use strict';

var bbGulp = require('./bb-gulp.js');
var mergeStream = require('merge-stream');
var _ = require('underscore');
var fs = require('fs');
var path = require('path');

function getModules(srcpath) {
  return fs.readdirSync(srcpath).filter(function(file) {
    return fs.statSync(path.resolve(path.join(srcpath, file))).isDirectory();
  });
}

function buildModule(streams, module, srcpath, releasepath) {
  try {
    fs.statSync(path.join(srcpath, module, 'javascripts'));
    streams.add(bbGulp.javascripts(module, srcpath, releasepath));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'i18n'));
    streams.add(bbGulp.i18n(module, srcpath, releasepath));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'stylesheets'));
    streams.add(bbGulp.stylesheets(module, srcpath, releasepath));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'images'));
    streams.add(bbGulp.images(module, srcpath, releasepath));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'fonts'));
    streams.add(bbGulp.fonts(module, srcpath, releasepath));
  } catch (e) {
  }
  try {
    fs.statSync(path.join(srcpath, module, 'templates'));
    streams.add(bbGulp.templates(module, srcpath, releasepath));
  } catch (e) {
  }
  streams.add(bbGulp.bower(module, srcpath, releasepath));
  return streams;
}

function run(srcpath, releasepath, module) {
  srcpath || (srcpath = './src');
  var streams = mergeStream();
  if (module) {
    streams = buildModule(streams, module, srcpath, releasepath);
  } else {
    var modules = getModules(srcpath);
    _.each(modules, function(module) {
      streams = buildModule(streams, module, srcpath, releasepath);
    });
  }
  return streams;
}

module.exports = run;
