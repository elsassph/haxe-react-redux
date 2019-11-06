package example.todo.view;

import example.todo.action.TodoAction;
import example.todo.model.TodoList;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.react.IConnectedComponent;

typedef TodoProps = {
	todo: TodoState,
	toggle: String -> Void
};

/**
	View for a single Todo model.
**/
class TodoView extends ReactComponentOfProps<TodoProps> implements IConnectedComponent
{
	override public function render()
	{
		var className = 'actionable todoview ' + (props.todo.done ? 'done' : '');

		// random bg color to show re-renders
		var r = Math.floor(Math.random() * 0x33) + 0xcc;
		var g = Math.floor(Math.random() * 0x33) + 0xcc;
		var b = Math.floor(Math.random() * 0x33) + 0xcc;
		var style = { backgroundColor:'rgb($r,$g,$b)' };

		return jsx('
			<li className=$className onClick=$onClick tabIndex="0" style=$style>
				${props.todo.text}
			</li>
		');
	}

	override function shouldComponentUpdate(nextProps:TodoProps, nextState:{}):Bool
	{
		// only re-render if the todo object is a different instance
		// because updates follow immutability rules
		return nextProps.todo != props.todo;
	}

	function onClick(_)
	{
		dispatch(TodoAction.Toggle(props.todo.id));
	}
}
