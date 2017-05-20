package example.todo.view;

import react.ReactComponent;
import react.ReactMacro.jsx;

/**
 * Don't hesitate to wrap components even if it doesn't seem useful:
 * it's not a big performance issue, and if you end up needing to connect the AboutView
 * like TodoListView then you won't need to refactor your component
 */
class AboutScreen extends ReactComponent
{
	override public function render()
	{
		return jsx('<AboutView/>');
	}
}
