const path = require('path');
const webpack = require('webpack');
const webpackMerge = require('webpack-merge');

let baseConfig = {
    target: 'web',
    plugins: [
        /*new webpack.optimize.CommonsChunkPlugin({
         name: 'inline',
         filename: 'inline.js',
         minChunks: Infinity
         }),
         new webpack.optimize.AggressiveSplittingPlugin({
         minSize: 5000,
         maxSize: 10000
         }),*/
    ],
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['es2015'],
                        plugins: [
                            ["transform-es2015-classes", {"loose": true}]
                        ]
                    }
                }
            }
        ]
    }
};

let bbModules = ['admin', 'admin-booking', 'admin-dashboard', 'core', 'events', 'member', 'public-booking', 'services', 'settings']
    .map(
        (bbModule) => {
            return webpackMerge(baseConfig, {
                entry: {
                    entry: path.resolve(__dirname, 'src/' + bbModule + '/javascripts/main.module.js')
                },
                output: {
                    path: path.resolve(__dirname, 'build-new/' + bbModule),
                    filename: 'bookingbug-angular-' + bbModule + '.js'
                }
            });
        }
    );

module.exports = bbModules;



