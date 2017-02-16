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

    const watchOptions = {
        read: false,
        readDelay: 500
    };

    let jsWatchers = {};

    function jsTranspilation(files, module, srcPath, buildPath, tmpPath) {

        let stream = gulp.src(files, {allowEmpty: true})
            .pipe(plumber())
            .pipe(gulpif(/.*js$/, babel({presets: ['es2015']}).on('error', gutil.log)))
            .pipe(gulp.dest(tmpPath + '/es5/' + module + '/javascripts/'));

        stream.on('end', function () {
            jsConcatenate(module, srcPath, buildPath, tmpPath).on('end', function () {
                if (jsWatchers[module] !== true) { //TODO we need additional flag to enable|disable watchers
                    jsWatchers[module] = true;

                    gulp.watch(files, function (file) {
                        let fileToRetranspile = [file.path];
                        console.log('Transpilation', fileToRetranspile);
                        jsTranspilation(fileToRetranspile, module, srcPath, buildPath, tmpPath);
                    }, watchOptions);
                }
            });
        });

        return stream;
    }

    function jsConcatenate(module, srcPath, buildPath, tmpPath) {
        let files = [
            tmpPath + '/es5/' + module + '/javascripts/**/*.module.js',
            tmpPath + '/es5/' + module + '/javascripts/**/*.js'
        ];

        let stream = gulp.src(files, {allowEmpty: true})
            .pipe(plumber())
            .pipe(concat('bookingbug-angular-' + module + '.js'))
            .pipe(gulp.dest(buildPath + '/' + module));

        if (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev') { //TODO could be better to rely on uglify flag

            let cloneSink = clone.sink();
            stream.pipe(cloneSink)
                .pipe(uglify({mangle: false})).on('error', gutil.log)
                .pipe(rename({extname: '.min.js'}))
                .pipe(cloneSink.tap())
                .pipe(gulp.dest(buildPath + '/' + module));
        }

        return stream;
    }

    module.exports = {
        javascripts: function (module, srcPath, buildPath, tmpPath) {

            srcPath || (srcPath = './src');
            buildPath || (buildPath = './build');
            tmpPath || (tmpPath = './tmp');

            let filesToTranspile = [
                srcPath + '/' + module + '/javascripts/**/*.module.js',
                srcPath + '/' + module + '/javascripts/**/*.js',
                '!' + srcPath + '/**/*.spec.js'
            ];

            jsTranspilation(filesToTranspile, module, srcPath, buildPath, tmpPath);
        },
        i18n: function (module, srcPath, buildPath) {
            srcPath || (srcPath = './src');
            buildPath || (buildPath = './build');
            return gulp
                .src(srcPath + '/core/i18n/**/*')
                .pipe(gulp.dest(buildPath + '/core/i18n'));
        },
        stylesheets: function (module, srcPath, buildPath) {
            srcPath || (srcPath = './src');
            buildPath || (buildPath = './build');
            return gulp.src(srcPath + '/' + module + '/stylesheets/**')
                .pipe(gulp.dest(buildPath + '/' + module + '/src/stylesheets'))
        },
        images: function (module, srcPath, buildPath) {
            srcPath || (srcPath = './src');
            buildPath || (buildPath = './build');
            return gulp.src(srcPath + '/' + module + '/images/*')
                .pipe(imagemin())
                .pipe(flatten())
                .pipe(gulp.dest(buildPath + '/' + module));
        },
        fonts: function (module, srcPath, buildPath) {
            srcPath || (srcPath = './src');
            buildPath || (buildPath = './build');
            return gulp.src(srcPath + '/' + module + '/fonts/*')
                .pipe(flatten())
                .pipe(gulp.dest(buildPath + '/' + module));
        },
        templates: function (module, srcPath, buildPath, modName) {
            srcPath || (srcPath = './src');
            buildPath || (buildPath = './build');

            if (modName === undefined || modName == '' || !modName) {
                modName = 'BB';
            }

            return gulp.src(srcPath + '/' + module + '/templates/**/*.html')
                .pipe(templateCache({module: modName}))
                .pipe(concat('bookingbug-angular-' + module + '-templates.js'))
                .pipe(gulp.dest(buildPath + '/' + module));
        },
        bower: function (module, srcPath, buildPath) {
            srcPath || (srcPath = './src');
            buildPath || (buildPath = './build');
            return gulp.src(path.join(srcPath, module, 'bower.json'))
                .pipe(gulp.dest(path.join(buildPath, module)));
        }
    };
}).call(this);
