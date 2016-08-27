(function () {
    'use strict';

    var fs = require('fs');
    var gulp = require('gulp');
    var gutil = require('gulp-util');
    var gulpif = require('gulp-if');
    var gulpUglify = require('gulp-uglify');
    var coffee = require('gulp-coffee');
    var concat = require('gulp-concat');
    var sass = require('gulp-sass');
    var flatten = require('gulp-flatten');
    var imagemin = require('gulp-imagemin');
    var filter = require('gulp-filter');
    var templateCache = require('gulp-angular-templatecache');
    var path = require('path');
    var rename = require('gulp-rename');
    var plumber = require('gulp-plumber');
    var clone = require('gulp-clone');
    var args = require('../helpers/args.js');
    var streamqueue = require('streamqueue');
    var ngAnnotate = require('gulp-ng-annotate');

    /**
     * @param {String} dir
     * @returns {Array}
     */
    function getFolders(dir) {
        return fs.readdirSync(dir)
            .filter(function (file) {
                return fs.statSync(path.join(dir, file)).isDirectory();
            });
    }

    module.exports = {
        javascripts: function (module, srcpath, releasepath, uglify) {

            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');

            var files = [
                srcpath + '/' + module + '/javascripts/main.js.coffee',
                srcpath + '/' + module + '/javascripts/**/*',
                srcpath + '/' + module + '/i18n/en.js',
                '!' + srcpath + '/' + module + '/javascripts/**/*~',
                '!' + srcpath + '/' + module + '/javascripts/**/*.js.js',
                '!' + srcpath + '/' + module + '/javascripts/**/*.js.js.map',
                '!' + srcpath + '/**/*_test.js.coffee',
                '!' + srcpath + '/**/*.spec.js.coffee'
            ];

            var stream = gulp.src(files, {allowEmpty: true})
                .pipe(plumber())
                .pipe(gulpif(/.*coffee$/, coffee().on('error', gutil.log)))
                .pipe(concat('bookingbug-angular-' + module + '.js'))
                .pipe(gulp.dest(releasepath + '/' + module));

            if ((uglify === true) || (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev')) {
                var cloneSink = clone.sink();
                stream.pipe(cloneSink)
                    .pipe(gulpUglify({mangle: false})).on('error', gutil.log)
                    .pipe(rename({extname: '.min.js'}))
                    .pipe(cloneSink.tap())
                    .pipe(gulp.dest(releasepath + '/' + module));
            }
        },
        coreJavascripts: function (module, srcpath, releasepath, templatesModule, uglify) {
            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');

            if (templatesModule === undefined || templatesModule == '' || !templatesModule) {
                templatesModule = 'BB';
            }

            var scripts = gulp.src([
                srcpath + '/' + module + '/javascripts/**/**/**/*.js.coffee',
                '!' + srcpath + '/' + module + '/javascripts/**/**/**/*.lazy.js.coffee',
                '!' + srcpath + '/' + module + '/javascripts/**/*~',
                '!' + srcpath + '/' + module + '/javascripts/**/*.js.js',
                '!' + srcpath + '/' + module + '/javascripts/**/*.js.js.map',
                '!' + srcpath + '/**/*_test.js.coffee',
                '!' + srcpath + '/**/*.spec.js.coffee'
            ])
                .pipe(gulpif(/.*coffee$/, coffee().on('error', gutil.log)));

            // Add templates to the mix
            var templates = gulp.src([
                path.join(srcpath + '/' + module, 'templates/core/**/**/*.html')
            ])
                .pipe(templateCache({
                    module: templatesModule,
                    root: 'default/core'
                }));

            var orphanTemplates = gulp.src([
                path.join(srcpath + '/' + module, 'templates/*.html')
            ])
                .pipe(templateCache({
                    module: templatesModule,
                    root: 'default'
                }));

            var stream = streamqueue({objectMode: true}, scripts, templates, orphanTemplates)
                .pipe(ngAnnotate({add: true, remove: true}))
                .pipe(concat('bookingbug-angular-' + module + '.js'))
                .pipe(gulp.dest(releasepath + '/' + module));

            if ((uglify === true) || (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev')) {
                var cloneSink = clone.sink();
                stream.pipe(cloneSink)
                    .pipe(gulpUglify({mangle: false})).on('error', gutil.log)
                    .pipe(rename({extname: '.min.js'}))
                    .pipe(cloneSink.tap())
                    .pipe(gulp.dest(releasepath + '/' + module));
            }


        },
        lazyJavascripts: function (module, srcpath, releasepath, templatesModule, uglify) {
            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');
            var folders = getFolders(srcpath + '/' + module + '/javascripts');

            if (templatesModule === undefined || templatesModule == '' || !templatesModule) {
                templatesModule = 'BB';
            }

            return folders.map(function (folder) {
                if (folder == 'core') {
                    return;
                }

                var scripts = gulp.src(path.join(srcpath + '/' + module, 'javascripts/' + folder + '/**/**/*.lazy.js.coffee'))
                    .pipe(gulpif(/.*coffee$/, coffee().on('error', gutil.log)));

                // Add templates to the mix
                var templates = gulp.src(path.join(srcpath + '/' + module, 'templates/' + folder + '/**/**/*.html'))
                    .pipe(templateCache({
                        module: templatesModule + '.' + folder + '-tpls', //lazyloaded run blocks only run for new modules
                        standalone: true,
                        root: 'default/' + folder
                    }));

                var stream = streamqueue({objectMode: true}, scripts, templates)
                    .pipe(ngAnnotate({add: true, remove: true}))
                    .pipe(concat('bookingbug-angular-' + module + '-' + folder + '.lazy.js'))
                    .pipe(gulp.dest(releasepath + '/' + module));

                if ((uglify === true) || (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev')) {
                    var cloneSink = clone.sink();
                    stream.pipe(cloneSink)
                        .pipe(gulpUglify({mangle: false})).on('error', gutil.log)
                        .pipe(rename({extname: '.min.js'}))
                        .pipe(cloneSink.tap())
                        .pipe(gulp.dest(releasepath + '/' + module));
                }
            });
        },
        i18n: function (module, srcpath, releasepath) {
            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');
            return gulp
                .src(srcpath + '/core/i18n/**/*')
                .pipe(gulp.dest(releasepath + '/core/i18n'));
        },
        stylesheets: function (module, srcpath, releasepath) {
            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');
            return gulp.src(srcpath + '/' + module + '/stylesheets/**')
                .pipe(gulp.dest(releasepath + '/' + module + '/src/stylesheets'))
        },
        images: function (module, srcpath, releasepath) {
            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');
            return gulp.src(srcpath + '/' + module + '/images/*')
                .pipe(imagemin())
                .pipe(flatten())
                .pipe(gulp.dest(releasepath + '/' + module));
        },
        fonts: function (module, srcpath, releasepath) {
            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');
            return gulp.src(srcpath + '/' + module + '/fonts/*')
                .pipe(flatten())
                .pipe(gulp.dest(releasepath + '/' + module));
        },
        templates: function (module, srcpath, releasepath, mod_name, keep_path_info) {
            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');
            if (keep_path_info === undefined) {
                keep_path_info = true;
            }
            if (mod_name === undefined || mod_name == '' || !mod_name) {
                mod_name = 'BB';
            }
            return gulp.src(srcpath + '/' + module + '/templates/**/*.html')
                .pipe(gulpif(keep_path_info, flatten()))
                .pipe(templateCache({module: mod_name}))
                .pipe(concat('bookingbug-angular-' + module + '-templates.js'))
                .pipe(gulp.dest(releasepath + '/' + module));
        },
        bower: function (module, srcpath, releasepath) {
            srcpath || (srcpath = './src');
            releasepath || (releasepath = './build');
            return gulp.src(path.join(srcpath, module, 'bower.json'))
                .pipe(gulp.dest(path.join(releasepath, module)));
        }
    };
}).call(this);
