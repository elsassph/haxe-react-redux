# Todo App

This is a simple application demonstrating React+Redux in Haxe. With live-reload.

> This application requires NPM and Haxe 3.2.1 or greater


## Overview

This is a partially implemented Todo application, demonstrating how Haxe macros, enums 
and abstracts can offer a superior React+Router+Redux integration.

* Strongly-typed Enums are used both to dispatch and to match actions,
* Reducers and middlewares are setup to receive a specific Enum type,
* React-redux connection is generated using macros,
* Automatic code splitting by route.

The application is also live-reload capable for fast iteration:

* read carefully: https://github.com/elsassph/haxe-modular

NPM dependencies are bundled into one JS file shared between the Haxe-JS bundles.


### Installation

Install NPM libraries:

	npm install

Install Haxe libraries

	haxelib install react
	haxelib install react-router
	haxelib install redux

For more information:

- https://github.com/massiveinteractive/haxe-react
- https://github.com/elsassph/haxe-react-router
- https://github.com/elsassph/haxe-redux

### NPM dependencies

NPM libraries are referenced in `src/libs.js` - add libraries your Haxe code will need.

Compile them into `bin/libs.js` for development:

	npm run libs:dev

See [Adding NPM dependencies](#adding-npm-dependencies) for a detailed process.

### Live-reload

Any LiveReload-compatible client/server should work but the simplest is `livereloadx`:

	npm run serve

Point your browser to `http://localhost:35729`

(re)Build the Haxe-JS for hot-reload: 

	haxe build.hxml -debug

That's all - no Webpack dark magic needed.

### Release build

Release build as a single Haxe-JS bundle:

	npm run release

This command does: 

- remove JS/MAP files in `bin/`
- build and minify `libs.js`
- build and minify `index.js` 

This is obviously a naive setup - you'll probably want to add some SCSS/LESS and 
assets preprocessors.


## Application Structure

The application source contains the following classes:

### /lib

	/redux         // Haxe Redux support
		/react     // Haxe React-Redux support
 
### /src

	Main.hx                       // Main entry point: setup and react render
	ApplicationStore.hx           // Setup of redux store
	ApplicationState.hx           // Interface of the redux state

	/example
		/todo
			/action
				TodoAction.hx     // Todolist actions Enum
			/model
				TodoList.hx       // State, reducer and middleware
			/view
				TodoListView.hx   // View for TodoList
				TodoView.hx       // View for individual Todo items
				TodoStatsView.hx  // Summary of current todo list + button to create new Todo
				AboutView.hx      // View for About screen


## Polyfills

This project loads (if needed) `core-js` and `dom4` libraries to polyfill modern JS and DOM 
features (see `index.html`).


## Haxe magic

### Code splitting and live-reload

Live-reload is implemented very simply, just using the "off the shelf" LiveReload servers and 
client libraries. LiveReload client API offers hooks to be notified of local file changes.

Haxe JS code-splitting is based on https://github.com/elsassph/modular-haxe-example and 
leverages [react-proxy](https://github.com/gaearon/react-proxy/tree/master) for live-reload
without state loss.

The entire setup of splitting by "route" and live-reload can be seen in the 
main `render` function which directly references the React component classes:

```haxe
static function render() 
{
	var history = ReactRouter.browserHistory;
	
	var app = ReactDOM.render(jsx('
	
		<Provider store=$store>
			<Router history=$history>
				<Route path="/" component=$pageWrapper>
					<IndexRoute getComponent=${RouteBundle.load(TodoListView)}/>
					<Route path="about" getComponent=${RouteBundle.load(AboutView)}/>
				</Route>
			</Router>
		</Provider>
		
	'), root);
	
	#if (debug && react_hot)
	ReactHMR.autoRefresh(app);
	#end
}
```

### Dispatch

The regular Redux `store.dispatch` is declared to accept the type `Action` which is 
in fact a Haxe `abstract` capable of auto-converting Haxe Enums into a regular 
`{ type, value }` Redux object.

For code to be seamless, simple wrapper functions provides the right Haxe Enum value
to the reducer/middleware.

```haxe
// Use regular 'store.dispatch' but passing Haxe Enums!
store.dispatch(TodoAction.Load)
	.then(function(_) {
		store.dispatch(TodoAction.Add('Item 5 (auto)'));
		store.dispatch(TodoAction.Toggle('4'));
	});
```

```haxe
// Match the Haxe Enum directly in your reducer!
public function reduce(state:TodoListState, action:TodoAction):TodoListState 
{
	return switch(action)
	{
		case Add(text):
			var newEntry = { id: '${++ID}', text: text, done: false };
			copy(state, {
				entries: state.entries.concat([newEntry])
			});
		case ...
```

### Connect

Normally for React, you're expected to use react-redux's `connect` high-order component:
http://redux.js.org/docs/basics/UsageWithReact.html

This is ok but rather inefficient because for every connected view, a relatively complex 
class has to be instantiated to puppet your view.

The approach proposed here uses macros to directly modify your class to insert the needed 
lifecycle operations:
- interface `IConnectedComponent` triggers the `ConnectMacro`,
- `this.context.store` is wired automatically,
- a `this.dispatch` function is created, forwarding to the connected store,
- if a `mapState` (static or not) function is declared, it will be used: 
	- in the constructor to set the initial state (instead of props),
	- when the state changes, to call `setState` with a new mapped state.

Using this system you don't normally even need to wrap the views using a separate component, 
but you should be able to manually reproduce this setup if desired. 

```haxe
// Implement IConnectComponent and (optionally) simply declare your state mapping function.
// No need to wrap your React view with Redux's connect function!
class TodoListView extends ReactComponentOfState<TodoListState> implements IConnectedComponent
{
	static function mapState(state:ApplicationState)
	{
		var todoList = state.todoList;
		var entries = todoList.entries;
		var message = 
			todoList.loading 
			? 'Loading...'
			: '${getRemaining(entries)} remaining of ${entries.length} items to complete';
		
		return {
			message: message,
			list: entries
		}
	}
	...
	override public function render() 
	{
		return jsx('
			<div>
				<TodoStatsView message=${state.message} addNew=$addNew/>
				<hr/>
				<ul>
					${renderList()}
				</ul>
			</div>
		');
	}
	
	function addNew() 
	{
		dispatch(TodoAction.Add('A new task'));
	}
	...
```

## Adding NPM dependencies

Here's an example, adding React Perf add-on:

#### Install the depency:

	npm install react-addons-perf --save

#### Update registry in `src/libs.js`:

```javascript
// 
// npm dependencies library
//
(function(scope) {
	'use-strict';
	scope.__registry__ = Object.assign({}, scope.__registry__, {
		
		// list npm modules required in Haxe
		
		'react': require('react'),
		'react-dom': require('react-dom'),
		'redux': require('redux'),
		// new module:
		'react-addons-perf': require('react-addons-perf'),
		
	});
	
	if (process.env.NODE_ENV !== 'production') {
		// enable hot-reload
		require('haxe-modular');
	}

})(typeof $hx_scope != "undefined" ? $hx_scope : $hx_scope = {});
```

Rebuild `lib.js`:

	npm run libs:dev

#### Create externs if none exist: 

Regular externs using `@:jsRequire` will work out of the box. 
To create new externs follow the normal procedure: https://haxe.org/manual/target-javascript-require.html

```haxe
@:jsRequire('react-addons-perf')
extern class Perf
{
	static public function start():Void;
	static public function stop():Void;
	static public function getLastMeasurements():PerfMeasurements;
	static public function printInclusive(measurements:PerfMeasurements):Void;
	static public function printExclusive(measurements:PerfMeasurements):Void;
	static public function printWasted(measurements:PerfMeasurements):Void;
	static public function printOperations(measurements:PerfMeasurements):Void;
}

typedef PerfMeasurements = Dynamic;
```

#### Use in your code:

Here's for example how to measure the main render action.

```haxe
	static function render() 
	{
		Perf.start();
		
		ReactDOM.render(jsx('
			<Provider store=$store>
				<TodoListView/>
			</Provider>
		'), root);
		
		Perf.stop();
		var measurements = Perf.getLastMeasurements();
		Perf.printInclusive(measurements);
	}
```
