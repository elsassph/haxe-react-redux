package example.todo.view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import router.Link;
import router.RouteComponentProps;

typedef AboutState = {
	cpt:Int
}

class AboutView extends ReactComponentOfState<AboutState>
{
	public function new(props:RouteComponentProps)
	{
		super(props);
		state = { cpt:0 };
	}

	override public function render()
	{
		return return jsx('
			<div className="about">
				<div className="about-content">
					<h2>About this demo</h2>
					<p>This is a demonstration of Haxe React with live-reload.</p>
					<p>You have clicked ${state.cpt} time(s).</p>
					<p><button onClick=$onclick>Now click this</button></p>
					<p><Link to="/">Jump to todo</Link></p>
				</div>
				<Footer/>
			</div>
		');
	}

	function onclick(_)
	{
		setState({ cpt:state.cpt + 1 });
		trace('click! ${state.cpt}');
	}
}
