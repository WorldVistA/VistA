const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ZipPlugin = require('zip-webpack-plugin');

module.exports = (env, argv) => {
    const isProduction = argv.mode === 'production';
    return {
        devtool: isProduction ? false : 'eval-source-map',
        entry: './src/index.js',
        output: {
            path: path.resolve(__dirname, 'dist'),
            filename: 'bundle.js'
        },
        module: {
            rules: [
                {
                    test: /\.(ts|tsx|js|jsx)$/,
                    exclude: /node_modules/,
                    use: {
                        loader: 'babel-loader',
                        options: {
                            presets: ['@babel/preset-env', '@babel/preset-react', '@babel/preset-typescript'],
                            plugins: ['@babel/plugin-transform-react-jsx']
                        },
                    }
                },
                //   {
                //     test: /\.css$/,
                //     use: ['style-loader', 'css-loader'],
                //   },
            ]
        },
        resolve: {
            extensions: ['.ts', '.tsx', '.js', '.jsx']
        },
        plugins: [
            new HtmlWebpackPlugin({
                template: './src/index.html'
            }),
            new ZipPlugin({
                filename: 'bundle.zip', // Name of the zip file
                include: [/\.js$/], // Include only JavaScript files
            })
        ],
        devServer: {
            static: {
                directory: path.join(__dirname, 'dist'),
            },
            compress: true,
            port: 9000
        }
    }
};