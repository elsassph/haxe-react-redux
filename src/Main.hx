import example.todo.action.TodoAction;
import example.todo.model.TodoList;
import example.todo.view.TodoListView;
import js.Browser;
import js.html.DivElement;
import react.ReactDOM;
import react.ReactMacro.jsx;
import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;
import redux.react.Provider;

class Main
{
	static var store:Store<ApplicationState>;
	static var root:DivElement;
	
	/**
		Entry point:
		- setup redux store
		- setup react rendering
		- send a few test messages
	**/
	public static function main()
	{
		setupStore();
		createViews();
		
		// use regular 'store.dispatch' but passing Haxe Enums!
		store.dispatch(TodoAction.Load)
			.then(function(_) {
				store.dispatch(TodoAction.Add('Item 5 (auto)'));
				store.dispatch(TodoAction.Toggle('4'));
			});
	}
	
	static function setupStore()
	{
		// store model, implementing reducer and middleware logic
		var todoList = new TodoList();
		
		// create root reducer normally, excepted you must use 
		// 'StoreBuilder.mapReducer' to wrap the Enum-based reducer
		var rootReducer = Redux.combineReducers({
			todoList: mapReducer(TodoAction, todoList)
		});
		
		// create middleware normally, excepted you must use 
		// 'StoreBuilder.mapMiddleware' to wrap the Enum-based middleware
		var middleware = Redux.applyMiddleware(
			mapMiddleware(TodoAction, todoList)
		);
		
		// user 'StoreBuilder.createStore' helper to automatically wire
		// the Redux devtools browser extension:
		// https://github.com/zalmoxisus/redux-devtools-extension
		store = createStore(rootReducer, null, middleware);
	}
	
	static function createViews()
	{
		var doc = Browser.document;
		root = doc.createDivElement();
		doc.body.appendChild(root);
		
		#if livereload
		Require.module('view').then(render);
		Require.hot(render);
		#else
		render(); // non-hot
		#end
	}
	
	static function render(?_) 
	{
		ReactDOM.render(jsx('
			<Provider store=$store>
				<TodoListView/>
			</Provider>
		'), root);
	}
}
