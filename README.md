Todo App
============

This is a simple application demonstrating React+Redux in Haxe. With live-reload.

> This application requires Haxe 3.2.1 or greater
> and https://github.com/massiveinteractive/haxe-react

Overview
-----------

This is a partially implemented Todo application, demonstrating how Haxe macros, enums 
and abstracts can offer a superior React+Redux integration.

* Strongly-typed Enums are used both to dispatch and to match actions,
* Reducers and middlewares are setup to receive a specific Enum type,
* React-redux connection is generated using macros.

The application is also live-reload capable for fast iteration:

* 2 JS files are created; one with the core app (store), 
  and one with the React views and their state-mapping logic.


Building the app
----------------

Install libraries:

	haxelib install react

Compile for live-reload via the hxml file:

	haxe livereload.hxml

Serve with live-reload:
	
	npm install -g livereloadx
	livereloadx -s bin

Release build as a single JS file:
	
	haxe build.hxml


Application Structure
---------------------

The application source contains the following classes:

### /lib

	Require.hx     // Lazy loading and live-reload of Haxe-JS modules
    Stub.hx        // Build macro to export modular Haxe-JS 

    /redux         // Haxe Redux support
		/react     // Haxe React-Redux support
 
### /src

	Main.hx                       // Main entry point: setup store and react render
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
	
Haxe magic
----------

### Live-reload

Live-reload is implemented very simply, just using the "off the shelf" LiveReload servers and 
client libraries. LiveReload client API offers hooks to be notified of local file changes.

Haxe JS code-splitting is based on https://github.com/elsassph/modular-haxe-example


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
