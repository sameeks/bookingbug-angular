var cs = require('coffee-script');
var gulp = require('gulp');
cs.register();
require('./gulp-tasks/gulpfile.js')(gulp, __dirname);
