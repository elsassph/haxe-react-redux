// WARNING: run with `NODE_ENV=production` for optimal results

var fs = require('fs');
var path = require('path');
var UglifyJS = require('uglify-js');

var bin = './bin/';

function onlyJS(files) {
	return files.filter(function(file) { 
		return path.extname(file) == '.js'; 
	}).map(function(file) {
		return bin + file;
	});
}

function minify(file) {
	console.log('Minify ' + file);
	
	var result = UglifyJS.minify(file, {
		mangle:true
	});
	
	if (result && result.code) {
		fs.writeFile(file, result.code);
	}
}

fs.readdir(bin, function(err, files) {
	onlyJS(files).forEach(minify)
});
