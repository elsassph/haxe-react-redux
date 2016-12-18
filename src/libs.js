// 
// npm dependencies library
//
(function(scope) {
	'use-strict';
	scope.__registry__ = Object.assign({}, scope.__registry__, {
		
		// list npm modules required in Haxe
		
		'react': require('react'),
		'react-dom': require('react-dom'),
		'react-router': require('react-router'),
		'redux': require('redux')
	});
	
	if (process.env.NODE_ENV !== 'production') {
		// enable hot-reload
		require('haxe-modular');
	}
	
})(typeof $hx_scope != "undefined" ? $hx_scope : $hx_scope = {});
