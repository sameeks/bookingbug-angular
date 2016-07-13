'use strict';

var fs = require('fs');
var gulp = require('gulp');
var gutil = require('gulp-util');
var gulpif = require('gulp-if');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var sass = require('gulp-sass');
var flatten = require('gulp-flatten');
var imagemin = require('gulp-imagemin');
var flatten = require('gulp-flatten');
var filter = require('gulp-filter');
var templateCache = require('gulp-angular-templatecache');
var path = require('path');
var rename = require('gulp-rename');
var plumber = require('gulp-plumber');

process.env.srcpath = process.env.srcpath || './src'
process.env.releasepath = process.env.releasepath || './build'

module.exports = {
  javascripts: function(module) {
    return gulp.src([
          process.env.srcpath+'/'+module+'/javascripts/main.js.coffee',
          process.env.srcpath+'/'+module+'/javascripts/**/*',
          process.env.srcpath+'/'+module+'/i18n/en.js',
          '!'+process.env.srcpath+'/'+module+'/javascripts/**/*~',
          '!'+process.env.srcpath+'/**/*_test.js.coffee'
        ],
        {allowEmpty: true}
      )
      .pipe(plumber())
      .pipe(gulpif(/.*coffee$/, coffee().on('error', gutil.log)))
      .pipe(concat('bookingbug-angular-'+module+'.js'))
      .pipe(gulp.dest(process.env.releasepath+'/'+module))
      .pipe(uglify({mangle: false})).on('error', gutil.log)
      .pipe(rename({extname: '.min.js'}))
      .pipe(gulp.dest(process.env.releasepath+'/'+module));
  },
  i18n: function() {
    return gulp
      .src(process.env.srcpath+'/core/i18n/**/*')
      .pipe(gulp.dest(process.env.releasepath+'/core/i18n'));
  },
  stylesheets: function(module) {
    return gulp.src(process.env.srcpath+'/'+module+'/stylesheets/main.scss')
      .pipe(plumber())
      .pipe(sass({errLogToConsole: true}))
      .pipe(flatten())
      .pipe(concat('bookingbug-angular-'+module+'.css'))
      .pipe(gulp.dest(process.env.releasepath+'/'+module));
  },
  images: function(module) {
    return gulp.src(process.env.srcpath+'/'+module+'/images/*')
      .pipe(imagemin())
      .pipe(flatten())
      .pipe(gulp.dest(process.env.releasepath+'/'+module));
  },
  fonts: function(module) {
    return gulp.src(process.env.srcpath+'/'+module+'/fonts/*')
      .pipe(flatten())
      .pipe(gulp.dest(process.env.releasepath+'/'+module));
  },
  templates: function(module, mod_name, keep_path_info) {
    if (keep_path_info === undefined) {
        keep_path_info = true;
    }

    if (mod_name === undefined || mod_name == '' || !mod_name) {
        mod_name = 'BB';
    }

    return gulp.src(process.env.srcpath+'/'+module+'/templates/**/*.html')
      .pipe(gulpif(keep_path_info, flatten()))
      .pipe(templateCache({module: mod_name}))
      .pipe(concat('bookingbug-angular-'+module+'-templates.js'))
      .pipe(gulp.dest(process.env.releasepath+'/'+module));
  },
  bower: function(module) {
    return gulp.src(path.join(process.env.srcpath, module, 'bower.json'))
      .pipe(gulp.dest(path.join(process.env.releasepath, module)));
  }
}
