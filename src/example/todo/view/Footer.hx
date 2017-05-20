package example.todo.view;

import react.ReactComponent;
import react.ReactMacro.jsx;

class Footer extends ReactComponent
{
	override public function render():ReactElement
	{
		return jsx('
			<footer>
				<FooterLogo/> A Haxe+React+Redux demo
			</footer>
		');
	}
}