package example.todo.view;

import example.todo.action.TodoAction;
import example.todo.model.TodoList;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.react.IConnectedComponent;

typedef TodoListState = {
	?message: String,
	?list: Array<TodoState>
}

class TodoListView extends ReactComponentOfState<TodoListState> implements IConnectedComponent
{
	public function new()
	{
		super();
	}
	
	function mapState(state:ApplicationState)
	{
		var todoList = state.todoList;
		var entries = todoList.entries;
		var message = 
			todoList.loading 
			? 'Loading...'
			: entries.length == 0
			  ? 'No items'
			  : '${getRemaining(entries)} remaining of ${entries.length} items to complete';
		
		return {
			message: message,
			list: entries
		}
	}
	
	function getRemaining(entries:Array<TodoState>)
	{
		return entries.filter(function(todo) return !todo.done).length;
	}
	
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
	
	function renderList()
	{
		return [for (todo in state.list)
			jsx('<TodoView key=${todo.id} todo=$todo/>')
		];
	}
}
