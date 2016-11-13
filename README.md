Todo App
============

This is a simple application demonstrating React+Redux in Haxe. With live-reload.

> This application requires Haxe 3.2.1 or greater.

Overview
-----------

This is a partially implemented Todo application, demonstrating how Haxe 
macros, enums and abstracts can offer the best React+Redux integration.

* Strongly-typed Enums are used both to dispatch and to match actions,
* Abstracts allow seemless transformation of Enums into regular actions,
* Reducers and middlewares are setup to receive a specific Enum type.

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

	Require.hx     // Lazy loading of Haxe-JS modules
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
	
