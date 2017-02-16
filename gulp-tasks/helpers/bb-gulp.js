(function () {
    'use strict';

    const argv = require('yargs').argv;
    const fs = require('fs');
    const gulp = require('gulp');
    const gutil = require('gulp-util');
    const gulpif = require('gulp-if');
    const coffee = require('gulp-coffee');
    const concat = require('gulp-concat');
    const uglify = require('gulp-uglify');
    const sass = require('gulp-sass');
    const flatten = require('gulp-flatten');
    const imagemin = require('gulp-imagemin');
    const filter = require('gulp-filter');
    const templateCache = require('gulp-angular-templatecache');
    const path = require('path');
    const rename = require('gulp-rename');
    const plumber = require('gulp-plumber');
    const clone = require('gulp-clone');
    const args = require('../helpers/args.js');
    const babel = require('gulp-babel');

    const watchOptions = {
        read: false,
        readDelay: 500
    };

    let srcPath = './src';
    let buildPath = './build';
    let tmpPath = './tmp';

    let jsWatchers = {};

    function jsTranspilation(done, files, module) {

        let stream = gulp.src(files, {allowEmpty: true})
            .pipe(plumber())
            .pipe(gulpif(/.*js$/, babel({presets: ['es2015']}).on('error', gutil.log)))
            .pipe(gulp.dest(tmpPath + '/es5/' + module + '/javascripts/'));

        stream.on('end', function () {
            jsConcatenate(module).on('end', function () {

                if (typeof done === 'function') {
                    done();
                }

                if (jsWatchers[module] !== true) { //TODO we need additional flag to enable|disable watchers
                    jsWatchers[module] = true;

                    gulp.watch(files, function (file) {
                        let fileToRetranspile = [file.path];
                        console.log('SDK change', fileToRetranspile);
                        jsTranspilation(null, fileToRetranspile, module);
                    }, watchOptions);
                }
            });
        });

        return stream;
    }

    function jsConcatenate(module) {
        let files = [
            tmpPath + '/es5/' + module + '/javascripts/**/*.module.js',
            tmpPath + '/es5/' + module + '/javascripts/**/*.js'
        ];

        let stream = gulp.src(files, {allowEmpty: true})
            .pipe(plumber())
            .pipe(concat('bookingbug-angular-' + module + '.js'))
            .pipe(gulp.dest(buildPath + '/' + module));

        if (args.getEnvironment() === 'prod' || argv.uglify === 'true') {

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
        overrideRootPath: function(rootPath){
            srcPath = path.join(rootPath, 'src');
            buildPath = path.join(rootPath, 'build');
            tmpPath = path.join(rootPath, 'tmp');
        },
        javascripts: function (done, module) {

            let files = [
                srcPath + '/' + module + '/javascripts/**/*.module.js',
                srcPath + '/' + module + '/javascripts/**/*.js',
                '!' + srcPath + '/**/*.spec.js'
            ];

            jsTranspilation(done, files, module);
        },
        stylesheets: function (module) {

            return gulp.src(srcPath + '/' + module + '/stylesheets/**')
                .pipe(gulp.dest(buildPath + '/' + module + '/src/stylesheets'));
        },
        images: function (module) {

            return gulp.src(srcPath + '/' + module + '/images/*')
                .pipe(imagemin())
                .pipe(flatten())
                .pipe(gulp.dest(buildPath + '/' + module));
        },
        fonts: function (module) {

            return gulp.src(srcPath + '/' + module + '/fonts/*')
                .pipe(flatten())
                .pipe(gulp.dest(buildPath + '/' + module));
        },
        templates: function (module, modName = 'BB') {

            return gulp.src(srcPath + '/' + module + '/templates/**/*.html')
                .pipe(templateCache({module: modName}))
                .pipe(concat('bookingbug-angular-' + module + '-templates.js'))
                .pipe(gulp.dest(buildPath + '/' + module));
        },
        bower: function (module) {

            return gulp.src(path.join(srcPath, module, 'bower.json'))
                .pipe(gulp.dest(path.join(buildPath, module)));
        }
    };
}).call(this);
