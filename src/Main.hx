import example.todo.view.AboutView;
import example.todo.view.TodoListView;
import js.Browser;
import js.html.DivElement;
import react.ReactDOM;
import react.ReactMacro.jsx;
import redux.Store;
import redux.react.Provider;
import router.Link;
import router.ReactRouter;
import router.RouteComponentProps;

class Main
{
	static var store:Store<ApplicationState>;
	static var root:DivElement;
	
	/**
		Entry point:
		- setup redux store
		- setup react rendering
		- send a few test messages
	**/
	public static function main()
	{
		store = ApplicationStore.create();
		
		createViews();
		
		ApplicationStore.startup(store);
	}
	
	static function createViews()
	{
		var doc = Browser.document;
		root = doc.createDivElement();
		doc.body.appendChild(root);
		
		render();
	}
	
	static function render() 
	{
		var history = ReactRouter.browserHistory;
		
		var app = ReactDOM.render(jsx('
		
			<Provider store=$store>
				<Router history=$history>
					<Route path="/" component=$pageWrapper>
						<IndexRoute getComponent=${RouteBundle.load(TodoListView)}/>
						<Route path="about" getComponent=${RouteBundle.load(AboutView)}/>
					</Route>
				</Router>
			</Provider>
			
		'), root);
		
		#if (debug && react_hot)
		ReactHMR.autoRefresh(app);
		#end
	}
	
	static function pageWrapper(props:RouteComponentProps)
	{
		return jsx('
			<div>
				<nav>
					<Link to="/">Todo</Link> | <Link to="/about">About</Link> 
				</nav>
				${props.children}
			</div>
		');
	}
}
