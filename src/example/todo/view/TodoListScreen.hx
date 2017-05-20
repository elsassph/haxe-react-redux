package example.todo.view;

import example.todo.model.TodoList;
import example.todo.view.TodoListView;
import react.ReactComponent;
import redux.react.IConnectedComponent;
import react.ReactMacro.jsx;
import router.RouteComponentProps;

/**
 * You *can* connect directly your view but it's better to have a "connector" component
 * to separate state mapping and view rendering and local state.
 */
class TodoListScreen
	extends ReactComponentOfPropsAndState<RouteComponentProps, TodoListProps>
	implements IConnectedComponent
{
	public function new(props:RouteComponentProps)
	{
		super(props);
	}

	/**
	 * Very important rule of `mapState`:
	 * - return either value types (int/string)
	 * - or objects/arrays as-is: avoid creating new objects/arrays here
	 *
	 * Creating a new objects in `mapState` will trigger a systematic re-render
	 * for each and every state update because the shallow-comparison of the new
	 * state object will find an object that changed.
	 * - Array map/filter/slice create new Arrays.
	 */
	function mapState(state:ApplicationState, props:RouteComponentProps):TodoListProps
	{
		var todoList = state.todoList;
		var entries = todoList.entries;
		var message =
			todoList.loading
			? 'Loading...'
			: entries.length == 0
			  ? 'No item'
			  : '${getRemaining(entries)} remaining of ${entries.length} items to complete';

		return {
			message: message,
			list: todoList.entries,
			filter: todoList.filter
		}
	}

	function getRemaining(entries:Array<TodoState>)
	{
		return entries.filter(function(todo) return !todo.done).length;
	}

	override public function render():ReactElement
	{
		// passing computed state as props and `dispatch` function
		return jsx('<TodoListView {...state} dispatch=$dispatch />');
	}
}