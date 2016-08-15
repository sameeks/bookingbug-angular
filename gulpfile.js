var cs = require('coffee-script');
var gulp = require('gulp');
cs.register();
require('./gulp-tasks/gulpfile.js.coffee')(gulp, __dirname);
