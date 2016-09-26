(function () {
    'use strict';

    var args = require('../helpers/args.js');
    var fs = require('fs');
    var gulp = require('gulp');
    var gulpAngularTemplateCache = require('gulp-angular-templatecache');
    var gulpClone = require('gulp-clone');
    var gulpCoffee = require('gulp-coffee');
    var gulpConcat = require('gulp-concat');
    var gulpFlatten = require('gulp-flatten');
    var gulpIf = require('gulp-if');
    var gulpImageMin = require('gulp-imagemin');
    var gulpNgAnnotate = require('gulp-ng-annotate');
    var gulpPlumber = require('gulp-plumber');
    var gulpRename = require('gulp-rename');
    var gulpUglify = require('gulp-uglify');
    var gulpUtil = require('gulp-util');
    var path = require('path');
    var streamqueue = require('streamqueue');

    module.exports = {
        bower: bower,
        fonts: fonts,
        images: images,
        javascripts: javascripts,
        javascriptsCore: javascriptsCore,
        javascriptsLazy: javascriptsLazy,
        stylesheets: stylesheets,
        templates: templates
    };

    function bower(moduleDirName, srcPath, releasePath) {
        srcPath || (srcPath = './src');
        releasePath || (releasePath = './build');

        return gulp.src(path.join(srcPath, moduleDirName, 'bower.json'))
            .pipe(gulp.dest(path.join(releasePath, moduleDirName)));
    }

    function fonts(moduleDirName, srcPath, releasepath) {
        srcPath || (srcPath = './src');
        releasepath || (releasepath = './build');
        return gulp.src(srcPath + '/' + moduleDirName + '/fonts/*')
            .pipe(gulpFlatten())
            .pipe(gulp.dest(releasepath + '/' + moduleDirName));
    }

    function images(moduleDirName, srcPath, releasePath) {
        srcPath || (srcPath = './src');
        releasePath || (releasePath = './build');

        return gulp.src(srcPath + '/' + moduleDirName + '/images/*')
            .pipe(gulpImageMin())
            .pipe(gulpFlatten())
            .pipe(gulp.dest(releasePath + '/' + moduleDirName));
    }

    function javascripts(moduleDirName, srcPath, releasePath, uglify) {
        srcPath || (srcPath = './src');
        releasePath || (releasePath = './build');

        var files = [
            srcPath + '/' + moduleDirName + '/javascripts/main.js.coffee',
            srcPath + '/' + moduleDirName + '/javascripts/**/*.module.js.coffee',
            srcPath + '/' + moduleDirName + '/javascripts/**/*',
            srcPath + '/' + moduleDirName + '/javascripts/**/*',
            srcPath + '/' + moduleDirName + '/i18n/en.js',
            '!' + srcPath + '/' + moduleDirName + '/javascripts/**/*~',
            '!' + srcPath + '/' + moduleDirName + '/javascripts/**/*.js.js',
            '!' + srcPath + '/' + moduleDirName + '/javascripts/**/*.js.js.map',
            '!' + srcPath + '/**/*_test.js.coffee',
            '!' + srcPath + '/**/*.spec.js.coffee'
        ];

        var stream = gulp.src(files, {allowEmpty: true})
            .pipe(gulpPlumber())
            .pipe(gulpIf(/.*coffee$/, gulpCoffee().on('error', gulpUtil.log)))
            .pipe(gulpConcat('bookingbug-angular-' + moduleDirName + '.js'))
            .pipe(gulp.dest(releasePath + '/' + moduleDirName));

        if ((uglify === true) || (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev')) {
            var cloneSink = gulpClone.sink();
            stream.pipe(cloneSink)
                .pipe(gulpUglify({mangle: false})).on('error', gulpUtil.log)
                .pipe(gulpRename({extname: '.min.js'}))
                .pipe(cloneSink.tap())
                .pipe(gulp.dest(releasePath + '/' + moduleDirName));
        }
    }

    function javascriptsCore(moduleDirName, srcPath, releasePath, templatesModule, uglify) {
        srcPath || (srcPath = './src');
        releasePath || (releasePath = './build');

        if (templatesModule === undefined || templatesModule == '' || !templatesModule) {
            templatesModule = 'BB';
        }

        var scripts = gulp.src([
            srcPath + '/' + moduleDirName + '/javascripts/**/**/**/*.js.coffee',
            '!' + srcPath + '/' + moduleDirName + '/javascripts/**/**/**/*.lazy.js.coffee',
            '!' + srcPath + '/' + moduleDirName + '/javascripts/**/*~',
            '!' + srcPath + '/' + moduleDirName + '/javascripts/**/*.js.js',
            '!' + srcPath + '/' + moduleDirName + '/javascripts/**/*.js.js.map',
            '!' + srcPath + '/**/*_test.js.coffee',
            '!' + srcPath + '/**/*.spec.js.coffee'
        ])
            .pipe(gulpIf(/.*coffee$/, gulpCoffee().on('error', gulpUtil.log)));

        // Add templates to the mix
        var templates = gulp.src([
            path.join(srcPath + '/' + moduleDirName, 'templates/core/**/**/*.html')
        ])
            .pipe(gulpAngularTemplateCache({
                module: templatesModule,
                root: 'default/core'
            }));

        var orphanTemplates = gulp.src([
            path.join(srcPath + '/' + moduleDirName, 'templates/*.html')
        ])
            .pipe(gulpAngularTemplateCache({
                module: templatesModule,
                root: 'default'
            }));

        var stream = streamqueue({objectMode: true}, scripts, templates, orphanTemplates)
            .pipe(gulpNgAnnotate({add: true, remove: true}))
            .pipe(gulpConcat('bookingbug-angular-' + moduleDirName + '.js'))
            .pipe(gulp.dest(releasePath + '/' + moduleDirName));

        if ((uglify === true) || (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev')) {
            var cloneSink = gulpClone.sink();
            stream.pipe(cloneSink)
                .pipe(gulpUglify({mangle: false})).on('error', gulpUtil.log)
                .pipe(gulpRename({extname: '.min.js'}))
                .pipe(cloneSink.tap())
                .pipe(gulp.dest(releasePath + '/' + moduleDirName));
        }
    }

    function javascriptsLazy(moduleDirName, srcPath, releasePath, templatesModule, uglify) {
        srcPath || (srcPath = './src');
        releasePath || (releasePath = './build');

        var folders = getFolders(srcPath + '/' + moduleDirName + '/javascripts');

        if (templatesModule === undefined || templatesModule == '' || !templatesModule) {
            templatesModule = 'BB';
        }

        return folders.map(function (folder) {
            if (folder == 'core') {
                return;
            }

            var scripts = gulp.src(path.join(srcPath + '/' + moduleDirName, 'javascripts/' + folder + '/**/**/*.lazy.js.coffee'))
                .pipe(gulpIf(/.*coffee$/, gulpCoffee().on('error', gulpUtil.log)));

            // Add templates to the mix
            var templates = gulp.src(path.join(srcPath + '/' + moduleDirName, 'templates/' + folder + '/**/**/*.html'))
                .pipe(gulpAngularTemplateCache({
                    module: templatesModule + '.' + folder + '-tpls', //lazyloaded run blocks only run for new modules
                    standalone: true,
                    root: 'default/' + folder
                }));

            var stream = streamqueue({objectMode: true}, scripts, templates)
                .pipe(gulpNgAnnotate({add: true, remove: true}))
                .pipe(gulpConcat('bookingbug-angular-' + moduleDirName + '-' + folder + '.lazy.js'))
                .pipe(gulp.dest(releasePath + '/' + moduleDirName));

            if ((uglify === true) || (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev')) {
                var cloneSink = gulpClone.sink();
                stream.pipe(cloneSink)
                    .pipe(gulpUglify({mangle: false})).on('error', gulpUtil.log)
                    .pipe(gulpRename({extname: '.min.js'}))
                    .pipe(cloneSink.tap())
                    .pipe(gulp.dest(releasePath + '/' + moduleDirName));
            }
        });
    }

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

    function stylesheets(moduleDirName, srcPath, releasePath) {
        srcPath || (srcPath = './src');
        releasePath || (releasePath = './build');

        return gulp.src(srcPath + '/' + moduleDirName + '/stylesheets/**')
            .pipe(gulp.dest(releasePath + '/' + moduleDirName + '/src/stylesheets'))
    }

    function templates(moduleDirName, srcPath, releasePath, moduleName) {
        srcPath || (srcPath = './src');
        releasePath || (releasePath = './build');

        if (moduleName === undefined || moduleName == '' || !moduleName) {
            moduleName = 'BB';
        }
        return gulp.src(srcPath + '/' + moduleDirName + '/templates/**/*.html')
            .pipe(gulpAngularTemplateCache({module: moduleName, root: 'default'}))
            .pipe(gulpConcat('bookingbug-angular-' + moduleDirName + '-templates.js'))
            .pipe(gulp.dest(releasePath + '/' + moduleDirName));
    }

}).call(this);
