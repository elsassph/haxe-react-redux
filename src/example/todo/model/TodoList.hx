package example.todo.model;

import example.todo.action.TodoAction;
import haxe.Http;
import haxe.Json;
import js.Promise;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;

typedef TodoListState = {
	loading:Bool,
	entries:Array<TodoState>
}

typedef TodoState = {
	?id:String,
	text:String,
	done:Bool
}

class TodoList 
	implements IReducer<TodoAction, TodoListState> 
	implements IMiddleware<TodoAction, ApplicationState>
{
	public var initState:TodoListState = { loading:false, entries:[] };
	public var store:StoreMethods<ApplicationState>;
	
	var ID = 0;
	var loadPending:Promise<Bool>;
	
	public function new()
	{
	}
	
	/* SERVICE */
	
	public function reduce(state:TodoListState, action:TodoAction):TodoListState 
	{
		return switch(action)
		{
			case Add(text):
				var newEntry = { id: '${++ID}', text: text, done: false };
				copy(state, {
					entries: state.entries.concat([newEntry])
				});
				
			case Toggle(id):
				copy(state, {
					entries: [
						for (todo in state.entries)
							if (todo.id != id) todo; 
							else {
								id: todo.id,
								text: todo.text,
								done: !todo.done
							}
					]
				});
				
			case Load:
				copy(state, {
					loading: true
				});
				
			case SetEntries(entries):
				{
					loading: false,
					entries: [
						for (todo in entries) {
							todo.id = '${++ID}';
							todo;
						}
					]
				}
		}
	}
	
	/* MIDDLEWARE */
	
	public function middleware(action:TodoAction, next:Void -> Dynamic)
	{
		return switch(action)
		{
			case Load: loadEntries();
			default: next();
		}
	}
	
	function loadEntries():Promise<Bool>
	{
		// guard for multiple requests
		if (loadPending != null) return loadPending;
		
		return loadPending = new Promise(function(resolve, reject) {
			var http = new Http('data/data.json');
			http.onData = function(data) {
				loadPending = null;
				var entries = Json.parse(data).items;
				store.dispatch(TodoAction.SetEntries(entries));
				resolve(true);
			}
			http.onError = function(error) {
				loadPending = null;
				store.dispatch(TodoAction.SetEntries([]));
				resolve(true);
			}
			http.request();
		});
	}
}
