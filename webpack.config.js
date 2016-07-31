var webpack = require('webpack'),
  HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = [
  {
    name: 'client',
    cache: true,
    entry: './src/perdoco',
    output: {
      path: __dirname + '/dist',
      filename: 'assets/bundle.js'
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
      new webpack.DefinePlugin({
        'process.env':{
          'NODE_ENV': JSON.stringify('production')
        }
      }),
      new HtmlWebpackPlugin({
        title: 'Custom template',
        template: 'src/default.html.slim'
      }),
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery'
      })
    ]
  }
];
