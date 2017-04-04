const path = require('path');
const webpack = require('webpack');

const config = [
    {
        entry: {
            'admin-booking': path.resolve(__dirname, 'src/admin-dashboard/javascripts/main.js'),
            'member-booking': path.resolve(__dirname, 'src/member/javascripts/main.js'),
            'public-booking': path.resolve(__dirname, 'src/public-booking/javascripts/main.js')
        },
        output: {
            path: path.resolve(__dirname, 'build-new'),
            filename: '[name]/bookingbug-angular-[name].js'
        },
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
                    use: [

                        {
                            loader: 'babel-loader',
                            options: {
                                presets: ['es2015'],
                                plugins: [
                                    ["transform-es2015-classes", {"loose": true}]
                                ]
                            }
                        },
                        {
                            loader: 'import-glob'
                        }
                    ]
                }
            ]
        }
    }
];

module.exports = config;
