var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var path = require('path');

module.exports = [
  {
    name: 'client',
    cache: true,
    context: path.join(__dirname, 'src'),
    devServer: {
        outputPath: path.join(__dirname, 'dist')
    },
    entry: {
        perdoco: './perdoco',
        tutor: './tutor'
    },
    output: {
      path: path.join(__dirname, 'dist'),
      filename: "[name].entry.js"
    },
    resolve: {
      extensions: ['', '.jsx', '.cjsx', '.coffee', '.js', '.html'],
      modulesDirectories: ['js', 'node_modules']
    },
    module: {
      loaders: [
        {test: /\.jsx$/, loader: 'jsx-loader?insertPragma=React.DOM'},
        {test: /\.cjsx$/, loaders: ['coffee', 'cjsx']},
        {test: /\.coffee$/, loader: 'coffee'},
        {test: /\.html\.slim$/, loaders: ['html', 'slm']},
        {test: /\.html$/, loader: 'raw-loader'},
        {test: /\.css$/, loaders: ['style', 'css']},
        {
          test: /\.woff$/,
          loader: 'url-loader?limit=10000&mimetype=application/font-woff&name=fonts/[name].[ext]'
        },
        {
          test: /\.woff2$/,
          loader: 'url-loader?limit=10000&mimetype=application/font-woff2&name=fonts/[name].[ext]'
        },
        {
          test: /\.(eot|ttf|svg)$/,
          loader: 'file-loader?name=fonts/[name].[ext]'
        },
        {
          test: /\.ico$/,
          exclude: /node_modules/,
          loader:'file-loader?name=img/[name].[ext]'
        },
        {
          test: /\.(jpg|jpeg|gif|png)$/,
          exclude: /node_modules/,
          loader:'file-loader?name=img/[name].[ext]'
        }
      ]
    },
    plugins: [
      new CopyWebpackPlugin([
          { from: './favicon.ico' },
          { from: './tutor/games', to:'games' },
      ]),
      new webpack.DefinePlugin({
        'process.env':{
          'NODE_ENV': JSON.stringify('production')
        }
      }),
      new HtmlWebpackPlugin({
        title: 'Main App',
        template: 'default.html.slim',
        chunks: ['perdoco']
      }),
      new HtmlWebpackPlugin({
        title: 'Tutor App',
        filename: 'tutor.html',
        template: 'tutor.html.slim',
        chunks: ['tutor']
      }),
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery'
      })
    ]
  }
];
