package example.todo.view;

import react.ReactComponent;
import react.ReactMacro.jsx;

typedef TodoStatsProps = {
	message: String,
	addNew: String -> Void
}

class TodoStatsView extends ReactComponentOfProps<TodoStatsProps>
{
	public function new()
	{
		super();
	}
	
	override public function render() 
	{
		return jsx('
			<div className="statsview">
				<label>${props.message}</label>
				<a onClick=$onClick tabIndex="0">Add item</a>
			</div>
		');
	}
	
	function onClick(_)
	{
		props.addNew('A new todo');
	}
}
