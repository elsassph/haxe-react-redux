package example.todo.model;

import example.todo.action.TodoAction;
import haxe.Timer;
import js.Promise;
import react.ReactUtil.assign;
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
			case Toggle(id):
				assign({}, [state, {
					entries: [
						for (todo in state.entries)
							if (todo.id != id) todo; 
							else {
								id: todo.id,
								text: todo.text,
								done: !todo.done
							}
					]
				}]);
				
			case Add(text):
				assign({}, [state, {
					entries: state.entries.concat([{ id: '${++ID}', text: text, done: false }])
				}]);
				
			case Load:
				assign({}, [state, {
					loading: true
				}]);
				
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
	
	public function middleware(store:StoreMethods<ApplicationState>, action:TodoAction, skip:Void -> Dynamic)
	{
		return switch(action)
		{
			case Load: loadEntries(store);
			default: skip();
		}
	}
	
	function loadEntries(store:StoreMethods<ApplicationState>):Promise<Bool>
	{
		// guard for multiple requests
		if (loadPending != null) return loadPending;
		
		return loadPending = new Promise(function(resolve, reject) {
				// simulate async loading
				Timer.delay(function() {
					loadPending = null;
					store.dispatch(TodoAction.SetEntries([
						{ text:'First one', done:false },
						{ text:'Second one', done:true }
					]));
					resolve(true);
				}, 1000);
			});
	}
}
