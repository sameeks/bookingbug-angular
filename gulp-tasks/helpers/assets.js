(function () {
    'use strict';

    const argv = require('yargs').argv;
    const del = require('del');
    const gulp = require('gulp');
    const gutil = require('gulp-util');
    const gulpif = require('gulp-if');
    const concat = require('gulp-concat');
    const uglify = require('gulp-uglify');
    const flatten = require('gulp-flatten');
    const imagemin = require('gulp-imagemin');
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
            .pipe(gulpif(/.*js$/, babel({
                presets: ['es2015', 'es2016'],
                plugins: [
                    ["transform-es2015-classes", {"loose": true}]
                ]
            }).on('error', gutil.log)))
            .pipe(gulp.dest(tmpPath + '/es5/' + module + '/javascripts/'));

        stream.on('end', function () {
            jsConcatenate(module).on('end', function () {

                if (typeof done === 'function') {
                    done();
                }

                if (argv._.indexOf('deploy') !== -1 || argv.skipWatch === true) {
                    return;
                }

                if (jsWatchers[module] !== true) {
                    jsWatchers[module] = true;

                    gulp.watch(files, function (file) {
                        let filePath = file.path;
                        console.log('SDK (' + file.type + '):', filePath);

                        let fileToRemove = filePath.replace('src', path.join('tmp', 'es5'));
                        del([fileToRemove], {force: true}).then(() => {
                            jsTranspilation(null, [filePath], module);
                        });

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

        if (args.getEnvironment() === 'prod' || argv.uglify === 'true') { //TODO value should come from args helper

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
        overrideRootPath: function (rootPath) {
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
        stylesheets: function (done, module) {

            gulp.src(srcPath + '/' + module + '/stylesheets/**')
                .pipe(gulp.dest(buildPath + '/' + module + '/src/stylesheets'))
                .on('end', function () {
                    done();
                });
        },
        images: function (done, module) {

            gulp.src(srcPath + '/' + module + '/images/*')
                .pipe(imagemin())
                .pipe(flatten())
                .pipe(gulp.dest(buildPath + '/' + module))
                .on('end', function () {
                    done();
                });
        },
        fonts: function (done, module) {

            gulp.src(srcPath + '/' + module + '/fonts/*')
                .pipe(flatten())
                .pipe(gulp.dest(buildPath + '/' + module))
                .on('end', function () {
                    done();
                });
        },
        templates: function (done, module, modName) {

            if (modName == null) {
                modName = 'BB';
            }

            gulp.src(srcPath + '/' + module + '/templates/**/*.html')
                .pipe(templateCache({module: modName}))
                .pipe(concat('bookingbug-angular-' + module + '-templates.js'))
                .pipe(gulp.dest(buildPath + '/' + module))
                .on('end', function () {
                    done();
                });
        },
        bower: function (done, module) {

            gulp.src(path.join(srcPath, module, 'bower.json'))
                .pipe(gulp.dest(path.join(buildPath, module)))
                .on('end', function () {
                    done();
                });
        }
    };
}).call(this);
