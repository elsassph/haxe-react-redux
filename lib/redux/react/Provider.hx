package redux.react;

import react.React;
import react.ReactComponent;
import redux.StoreMethods;

typedef ProvideProps = {
	store: StoreMethods<Dynamic>,
	children: ReactElement
}

class Provider extends ReactComponentOfProps<ProvideProps>
{
	static public var childContextTypes = {
		store: React.PropTypes.object.isRequired
	};
	
	static public var propTypes = {
		children: React.PropTypes.element.isRequired
	};

	public function new(props) 
	{
		super(props);
	}

	public function getChildContext()
	{
		return {
			store: props.store
		};
	}
	
	override function render()
	{
		return React.Children.only(props.children);
	}	
}
