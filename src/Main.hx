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
		
		store.dispatch(TodoAction.Load)
			.then(function(_) {
				store.dispatch(TodoAction.Add('Third (scripted) one'));
				store.dispatch(TodoAction.Toggle('1'));
			});
	}
	
	static function setupStore()
	{
		var todoList = new TodoList();
		
		var rootReducer = Redux.combineReducers({
			todoList: mapReducer(TodoAction, todoList)
		});
		
		var middleware = Redux.applyMiddleware(
			mapMiddleware(TodoAction, todoList)
		);
		
		store = createStore(rootReducer, null, middleware);
	}
	
	static function createViews()
	{
		var doc = Browser.document;
		root = doc.createDivElement();
		doc.body.appendChild(root);
		
		#if livereload
		Require.module('view', false).then(render);
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
