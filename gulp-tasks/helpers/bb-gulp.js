(function () {
    'use strict';

    let fs = require('fs');
    let gulp = require('gulp');
    let gutil = require('gulp-util');
    let gulpif = require('gulp-if');
    let coffee = require('gulp-coffee');
    let concat = require('gulp-concat');
    let uglify = require('gulp-uglify');
    let sass = require('gulp-sass');
    let flatten = require('gulp-flatten');
    let imagemin = require('gulp-imagemin');
    let filter = require('gulp-filter');
    let templateCache = require('gulp-angular-templatecache');
    let path = require('path');
    let rename = require('gulp-rename');
    let plumber = require('gulp-plumber');
    let clone = require('gulp-clone');
    let args = require('../helpers/args.js');
    let babel = require('gulp-babel');

    module.exports = {
        javascripts: function (module, srcPath, releasePath) {

            srcPath || (srcPath = './src');
            releasePath || (releasePath = './build');

            let files = [
                srcPath + '/' + module + '/javascripts/**/*.module.js',
                srcPath + '/' + module + '/javascripts/**/*.js',
                '!' + srcPath + '/**/*.spec.js'
            ];

            let stream = gulp.src(files, {allowEmpty: true})
                .pipe(plumber())
                //.pipe(gulpif(/.*coffee$/, coffee().on('error', gutil.log)))
                .pipe(gulpif(/.*js$/, babel({presets: ['es2015']}).on('error', gutil.log)))
                .pipe(concat('bookingbug-angular-' + module + '.js'))
                .pipe(gulp.dest(releasePath + '/' + module));

            if (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev') {
                let cloneSink = clone.sink();
                stream.pipe(cloneSink)
                    .pipe(uglify({mangle: false})).on('error', gutil.log)
                    .pipe(rename({extname: '.min.js'}))
                    .pipe(cloneSink.tap())
                    .pipe(gulp.dest(releasePath + '/' + module));
            }


        },
        i18n: function (module, srcPath, releasePath) {
            srcPath || (srcPath = './src');
            releasePath || (releasePath = './build');
            return gulp
                .src(srcPath + '/core/i18n/**/*')
                .pipe(gulp.dest(releasePath + '/core/i18n'));
        },
        stylesheets: function (module, srcPath, releasePath) {
            srcPath || (srcPath = './src');
            releasePath || (releasePath = './build');
            return gulp.src(srcPath + '/' + module + '/stylesheets/**')
                .pipe(gulp.dest(releasePath + '/' + module + '/src/stylesheets'))
        },
        images: function (module, srcPath, releasePath) {
            srcPath || (srcPath = './src');
            releasePath || (releasePath = './build');
            return gulp.src(srcPath + '/' + module + '/images/*')
                .pipe(imagemin())
                .pipe(flatten())
                .pipe(gulp.dest(releasePath + '/' + module));
        },
        fonts: function (module, srcPath, releasePath) {
            srcPath || (srcPath = './src');
            releasePath || (releasePath = './build');
            return gulp.src(srcPath + '/' + module + '/fonts/*')
                .pipe(flatten())
                .pipe(gulp.dest(releasePath + '/' + module));
        },
        templates: function (module, srcPath, releasePath, mod_name) {
            srcPath || (srcPath = './src');
            releasePath || (releasePath = './build');

            if (mod_name === undefined || mod_name == '' || !mod_name) {
                mod_name = 'BB';
            }

            return gulp.src(srcPath + '/' + module + '/templates/**/*.html')
                .pipe(templateCache({module: mod_name}))
                .pipe(concat('bookingbug-angular-' + module + '-templates.js'))
                .pipe(gulp.dest(releasePath + '/' + module));
        },
        bower: function (module, srcPath, releasePath) {
            srcPath || (srcPath = './src');
            releasePath || (releasePath = './build');
            return gulp.src(path.join(srcPath, module, 'bower.json'))
                .pipe(gulp.dest(path.join(releasePath, module)));
        }
    };
}).call(this);
