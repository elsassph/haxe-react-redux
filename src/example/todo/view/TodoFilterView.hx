package example.todo.view;

import example.todo.action.TodoAction;
import example.todo.model.TodoList.FilterOption;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.react.IConnectedComponent;

class TodoFilterView extends ReactComponent
	implements IConnectedComponent
{
	static function mapState(state:ApplicationState, props)
	{
		return {
			current: state.todoList.filter
		};
	}
	
	public function new()
	{
		super();
	}
	
	override public function render():ReactElement 
	{
		return jsx('
			<ul className="filterview">
				${renderOptions()}
			</ul>
		');
	}
	
	function renderOptions() 
	{
		var options = [FilterOption.All, FilterOption.Completed, FilterOption.Remaining];
		
		return [for (option in options) {
			var cname = option == state.current ? 'selected' : '';
			var select = function() {
				dispatch(TodoAction.SetFilter(option));
			};
			jsx('<li key=$option className=$cname onClick=$select>${option}</li>');
		}];
	}
}
