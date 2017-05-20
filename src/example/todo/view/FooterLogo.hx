package example.todo.view;

import react.ReactComponent;
import react.ReactMacro.jsx;

class FooterLogo extends ReactComponent
{
	override public function render():ReactElement
	{
		return jsx('<img className="footer-logo" src="img/haxe-react.svg" />');
	}
}